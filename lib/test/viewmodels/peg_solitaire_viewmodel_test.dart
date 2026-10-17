import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_laboratorio/core/enums/cell_type.dart';
import 'package:flutter_laboratorio/models/board_position.dart';
import 'package:flutter_laboratorio/viewmodels/peg_solitaire_view_model.dart';

import '../fakes/fake_audio_service.dart';
import '../fakes/fake_game_history_repository.dart';
import '../fakes/fake_preferences_service.dart';

void main() {
  // Inicialización formal del entorno de testing para prevenir fallos de bindings
  TestWidgetsFlutterBinding.ensureInitialized();

  late PegSolitaireViewModel viewModel;
  late FakeGameHistoryRepository fakeRepo;
  late FakePreferencesService fakePrefs;
  late FakeAudioService fakeAudio;

  // Ciclo de vida: Se ejecuta limpiamente antes de CADA prueba individual
  setUp(() {
    fakeRepo = FakeGameHistoryRepository();
    fakePrefs = FakePreferencesService();
    fakeAudio = FakeAudioService();

    viewModel = PegSolitaireViewModel(
      historyRepository: fakeRepo,
      preferencesService: fakePrefs,
      audioService: fakeAudio,
    );
  });

  // Ciclo de vida: Liberación de recursos al terminar cada prueba
  tearDown(() {
    viewModel.dispose();
  });

  group('PegSolitaireViewModel - Pruebas Unitarias del Motor Lógico', () {
    test('TC-01: Ejecuta salto ortogonal válido y remueve atómicamente la clavija intermedia', () {
      // 1. ARRANGE: Tablero inglés estándar inicial
      // Fila 1, Col 3 tiene clavija; Fila 2, Col 3 tiene clavija; Centro (3, 3) está vacío.
      const from = BoardPosition(1, 3);
      const jumped = BoardPosition(2, 3);
      const to = BoardPosition(3, 3);

      expect(viewModel.getCellType(from.row, from.col), CellType.occupiedPeg);
      expect(
        viewModel.getCellType(jumped.row, jumped.col),
        CellType.occupiedPeg,
      );
      expect(viewModel.getCellType(to.row, to.col), CellType.emptyHole);

      // 2. ACT: Paso 1 de FSM (Seleccionar origen)
      viewModel.onCellTapped(from);
      expect(viewModel.selectedPosition, from);
      expect(fakeAudio.playSelectCount, 1);

      // ACT: Paso 2 de FSM (Saltar a destino válido)
      viewModel.onCellTapped(to);

      // 3. ASSERT: Mutación atómica en memoria
      expect(
        viewModel.getCellType(from.row, from.col),
        CellType.emptyHole,
        reason: 'El origen debe quedar vacío',
      );
      expect(
        viewModel.getCellType(jumped.row, jumped.col),
        CellType.emptyHole,
        reason: 'La clavija saltada debe ser removida',
      );
      expect(
        viewModel.getCellType(to.row, to.col),
        CellType.occupiedPeg,
        reason: 'El destino debe alojar la clavija',
      );
      expect(
        viewModel.selectedPosition,
        isNull,
        reason: 'La FSM debe retornar a estado IDLE',
      );
      expect(
        fakeAudio.playJumpCount,
        1,
        reason: 'Debe emitirse el sonido de salto',
      );
    });

    test(
      'TC-02: Rechaza categóricamente saltos diagonales y preserva invariantes',
      () {
        // 1. ARRANGE
        const from = BoardPosition(1, 3);
        const invalidDiagonal = BoardPosition(
          3,
          5,
        ); // Salto en diagonal prohibido

        // Preparamos un destino vacío para probar el salto diagonal.
        viewModel.board[invalidDiagonal.row][invalidDiagonal.col] =
            CellType.emptyHole;

        // 2. ACT
        viewModel.onCellTapped(from);
        viewModel.onCellTapped(invalidDiagonal);

        // 3. ASSERT: El estado cinemático debe permanecer inalterado
        expect(viewModel.remainingPegs, 32);
        expect(viewModel.moveCount, 0);
        expect(viewModel.getCellType(from.row, from.col), CellType.occupiedPeg);
        expect(
          viewModel.selectedPosition,
          from,
          reason: 'Mantiene la selección ante destino inválido',
        );
      },
    );

    test('TC-03: Rechaza desplazamientos simples de distancia 1 hacia hueco vacío', () {
      // 1. ARRANGE: Posición con distancia Manhattan = 1 (adyacente, sin salto)
      const from = BoardPosition(3, 2);
      const adjacentHole = BoardPosition(3, 3);

      // 2. ACT
      viewModel.onCellTapped(from);
      viewModel.onCellTapped(adjacentHole);

      // 3. ASSERT
      expect(viewModel.remainingPegs, 32);
      expect(viewModel.moveCount, 0);
      expect(viewModel.getCellType(from.row, from.col), CellType.occupiedPeg);
    });

    test('TC-04: Mantiene la consistencia de los contadores de piezas y turnos jugados', () {
      // 1. ARRANGE
      const from = BoardPosition(1, 3);
      const to = BoardPosition(3, 3);

      expect(viewModel.remainingPegs, 32);
      expect(viewModel.moveCount, 0);

      // 2. ACT
      viewModel.onCellTapped(from);
      viewModel.onCellTapped(to);

      // 3. ASSERT: Invariantes numéricas
      expect(
        viewModel.remainingPegs,
        31,
        reason: 'Debe decrementar exactamente 1 clavija',
      );
      expect(
        viewModel.moveCount,
        1,
        reason: 'Debe incrementar exactamente 1 turno',
      );
    });

    test('TC-05: Estado inicial coherente con tablero inglés estándar', () {
      // ASSERT: Verificación de arranque limpio
      expect(viewModel.isGameOver, isFalse);
      expect(viewModel.isVictory, isFalse);
      expect(viewModel.remainingPegs, 32);
      expect(viewModel.moveCount, 0);
      expect(viewModel.selectedPosition, isNull);
    });
  });
}
