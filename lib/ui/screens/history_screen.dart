import 'package:flutter/material.dart';
import 'package:flutter_laboratorio/models/foundation.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  //Lista del historial
  List<GameRecord> _getMockRecords() {
    return [
      GameRecord(
        id: 'REC-101',
        date: DateTime.now().subtract(const Duration(hours: 1)),
        remainingPegs: 1,
        totalMoves: 31,
        durationSeconds: 145,
        isVictory: true,
      ),
      GameRecord(
        id: 'REC-102',
        date: DateTime.now().subtract(const Duration(days: 1)),
        remainingPegs: 3,
        totalMoves: 29,
        durationSeconds: 215,
        isVictory: false,
      ),
      GameRecord(
        id: 'REC-103',
        date: DateTime.now().subtract(const Duration(days: 2)),
        remainingPegs: 1,
        totalMoves: 32,
        durationSeconds: 180,
        isVictory: true,
      ),
      GameRecord(
        id: 'REC-104',
        date: DateTime.now().subtract(const Duration(days: 3)),
        remainingPegs: 5,
        totalMoves: 27,
        durationSeconds: 240,
        isVictory: false,
      ),
      GameRecord(
        id: 'REC-105',
        date: DateTime.now().subtract(const Duration(days: 4)),
        remainingPegs: 1,
        totalMoves: 31,
        durationSeconds: 152,
        isVictory: true,
      ),
      GameRecord(
        id: 'REC-106',
        date: DateTime.now().subtract(const Duration(days: 5)),
        remainingPegs: 4,
        totalMoves: 28,
        durationSeconds: 205,
        isVictory: false,
      ),
      GameRecord(
        id: 'REC-107',
        date: DateTime.now().subtract(const Duration(days: 6)),
        remainingPegs: 1,
        totalMoves: 30,
        durationSeconds: 167,
        isVictory: true,
      ),
      GameRecord(
        id: 'REC-108',
        date: DateTime.now().subtract(const Duration(days: 7)),
        remainingPegs: 6,
        totalMoves: 25,
        durationSeconds: 270,
        isVictory: false,
      ),
      GameRecord(
        id: 'REC-109',
        date: DateTime.now().subtract(const Duration(days: 8)),
        remainingPegs: 2,
        totalMoves: 31,
        durationSeconds: 195,
        isVictory: false,
      ),
      GameRecord(
        id: 'REC-110',
        date: DateTime.now().subtract(const Duration(days: 9)),
        remainingPegs: 1,
        totalMoves: 32,
        durationSeconds: 138,
        isVictory: true,
      ),
    ];
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
    final records = _getMockRecords();

    return Scaffold(
      appBar: AppBar(title: const Text('Historial de Partidas')),
      body: ListView.builder(
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
      ),
    );
  }
}
