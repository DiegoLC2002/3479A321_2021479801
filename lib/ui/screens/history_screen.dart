import 'package:flutter/material.dart';
import 'package:flutter_laboratorio/models/game_record.dart';
import 'package:flutter_laboratorio/repositories/game_history_repository.dart';
import 'package:flutter_laboratorio/repositories/json_file_history_repository.dart';

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
      appBar: AppBar(title: const Text('Historial de Partidas')),
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
