import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../models/game_record.dart';
import 'game_history_repository.dart';

import 'package:flutter_laboratorio/core/utils/app_logger.dart';

/// Implementación del repositorio respaldada en el sistema de archivos (JSON).
class JsonFileHistoryRepository implements IGameHistoryRepository {
  static const String _fileName = 'games_history.json';

  /// Resuelve la ruta del archivo dentro del almacenamiento privado de la aplicación.
  Future<File> _resolveLocalFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/$_fileName');
  }

  /// Obtener el archivo JSON del historial para exportarlo.
  Future<File?> getHistoryFile() async {
    try {
      final file = await _resolveLocalFile();

      if (await file.exists()) {
        return file;
      }

      AppLogger.warning('No existe un archivo de historial para exportar.');
      return null;
    } catch (e) {
      AppLogger.error('Error al obtener el archivo de historial: $e');
      rethrow;
    }
  }

  @override
  Future<List<GameRecord>> getHistory() async {
    try {
      final file = await _resolveLocalFile();

      if (!await file.exists()) {
        AppLogger.info(
          'Historial inexistente en disco. Retornando colección vacía.',
        );
        return [];
      }

      final String content = await file.readAsString();

      if (content.trim().isEmpty) {
        return [];
      }

      final List<dynamic> decodedList = jsonDecode(content) as List<dynamic>;

      return decodedList
          .map((item) => GameRecord.fromJson(item as Map<String, dynamic>))
          .toList();
    } on FileSystemException catch (e) {
      AppLogger.error(
        'Error de bajo nivel en el sistema de archivos: ${e.message}',
      );
      return [];
    } on FormatException catch (e) {
      AppLogger.error(
        'Corrupción detectada en games_history.json: ${e.message}',
      );
      return [];
    } catch (e) {
      AppLogger.error('Excepción no controlada al leer historial: $e');
      return [];
    }
  }

  @override
  Future<void> saveGame(GameRecord record) async {
    try {
      final file = await _resolveLocalFile();

      // Recuperar el historial existente.
      final List<GameRecord> currentList = await getHistory();

      // Insertar la partida al inicio de la lista.
      currentList.insert(0, record);

      // Convertir las partidas a JSON.
      final String encoded = jsonEncode(
        currentList.map((game) => game.toJson()).toList(),
      );

      // Escribir el contenido en el archivo.
      await file.writeAsString(encoded, mode: FileMode.write, flush: true);

      AppLogger.info('Partida ${record.id} persistida con éxito en disco.');
    } catch (e) {
      AppLogger.error('Fallo al persistir partida en archivo local: $e');
      rethrow;
    }
  }

  @override
  Future<void> clearHistory() async {
    try {
      final file = await _resolveLocalFile();

      if (await file.exists()) {
        await file.delete();
        AppLogger.info('Archivo de historial purgado exitosamente.');
      }
    } catch (e) {
      AppLogger.error('Error al purgar historial: $e');
    }
  }
}
