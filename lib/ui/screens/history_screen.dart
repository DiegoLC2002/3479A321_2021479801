import 'package:flutter/material.dart';
import 'package:flutter_laboratorio/models/game_record.dart';
import 'package:flutter_laboratorio/repositories/game_history_repository.dart';
import 'package:flutter_laboratorio/repositories/json_file_history_repository.dart';
import 'package:flutter_laboratorio/ui/screens/replay_screen.dart';
import 'package:share_plus/share_plus.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final IGameHistoryRepository _repository = JsonFileHistoryRepository();

  late Future<List<GameRecord>> _historyFuture;

  @override
  void initState() {
    super.initState();
    _historyFuture = _repository.getHistory();
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/'
        '${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:'
        '${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    return '${minutes}m ${remainingSeconds}s';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de Partidas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            tooltip: 'Exportar respaldo del historial',
            onPressed: () async {
              try {
                final file = _repository is JsonFileHistoryRepository
                    ? await _repository.getHistoryFile()
                    : null;

                if (!context.mounted) return;

                if (file == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No existe un historial para exportar.'),
                    ),
                  );
                  return;
                }

                await SharePlus.instance.share(
                  ShareParams(
                    files: [XFile(file.path)],
                    subject: 'Respaldo de partidas de Solitario Inglés',
                  ),
                );
              } catch (e) {
                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('No se pudo exportar el historial: $e'),
                  ),
                );
              }
            },
          ),
        ],
      ),

      body: FutureBuilder<List<GameRecord>>(
        future: _historyFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar el historial: ${snapshot.error}'),
            );
          }

          final records = snapshot.data ?? [];

          if (records.isEmpty) {
            return const Center(
              child: Text('Todavía no hay partidas guardadas.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12.0),
            itemCount: records.length,
            itemBuilder: (context, index) {
              final record = records[index];

              return Card(
                margin: const EdgeInsets.only(bottom: 12.0),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReplayScreen(record: record),
                      ),
                    );
                  },

                  leading: Icon(
                    record.isVictory ? Icons.emoji_events : Icons.close,
                    color: record.isVictory ? Colors.green : Colors.red,
                    size: 32,
                  ),
                  title: Text(
                    'Partida ${record.id}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Fecha: ${_formatDate(record.date)}\n'
                    'Clavijas restantes: ${record.remainingPegs}\n'
                    'Movimientos: ${record.totalMoves}\n'
                    'Duración: ${_formatDuration(record.durationSeconds)}',
                  ),
                  trailing: Text(
                    record.isVictory ? 'Victoria' : 'Derrota',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: record.isVictory ? Colors.green : Colors.red,
                    ),
                  ),
                  isThreeLine: true,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
