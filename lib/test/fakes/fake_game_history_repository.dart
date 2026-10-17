import 'package:flutter_laboratorio/models/game_record.dart';
import 'package:flutter_laboratorio/repositories/game_history_repository.dart';

class FakeGameHistoryRepository implements IGameHistoryRepository {
  final List<GameRecord> _storage = [];

  /// Permite a las aserciones de prueba inspeccionar los registros persistidos en RAM
  List<GameRecord> get memoryRecords => List.unmodifiable(_storage);

  @override
  Future<List<GameRecord>> getHistory() async {
    return List.from(_storage);
  }

  @override
  Future<void> saveGame(GameRecord record) async {
    _storage.insert(0, record);
  }

  @override
  Future<void> clearHistory() async {
    _storage.clear();
  }
}
