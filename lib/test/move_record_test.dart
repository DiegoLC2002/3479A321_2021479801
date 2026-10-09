import '../models/board_position.dart';
import '../models/move_record.dart';

void main() {
  print('=== PRUEBA DE CAJA BLANCA: MoveRecord ===');

  // 1. Crear un MoveRecord
  final move = MoveRecord(
    from: const BoardPosition(3, 1),
    to: const BoardPosition(3, 3),
    timestamp: DateTime.parse('2026-10-09T12:30:00.000'),
  );

  print('[OK] Creación de MoveRecord: $move');

  // 2. Llamar a toJson()
  final json = move.toJson();
  print('[OK] Resultado de toJson(): $json');

  // 3. Llamar a fromJson()
  final restoredMove = MoveRecord.fromJson(json);
  print('[OK] Resultado de fromJson(): $restoredMove');

  // 4. Verificar que los datos se conservaron
  final success =
      restoredMove.from == move.from &&
      restoredMove.to == move.to &&
      restoredMove.timestamp == move.timestamp;

  print(
    success
        ? '[OK] Todos los datos se conservaron correctamente.'
        : '[ERROR] Los datos no coinciden.',
  );

  print('=== FIN DE LA PRUEBA ===');
}
