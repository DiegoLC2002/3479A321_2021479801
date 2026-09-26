import 'package:flutter/foundation.dart';
import 'package:flutter_laboratorio/models/board_position.dart';
import 'package:logger/logger.dart';

import '../core/enums/cell_type.dart';

var logger = Logger(printer: PrettyPrinter());

class PegSolitaireViewModel extends ChangeNotifier {
  static const int gridSize = 7;

  // Estado interno matricial y contadores
  late List<List<CellType>> _board;
  BoardPosition? _selectedPosition;

  int _remainingPegs = 0;
  int _moveCount = 0;
  bool _isGameOver = false;
  bool _isVictory = false;

  // Getters inmutables expuestos hacia la UI
  List<List<CellType>> get board => _board;
  BoardPosition? get selectedPosition => _selectedPosition;
  int get remainingPegs => _remainingPegs;
  int get moveCount => _moveCount;
  bool get isGameOver => _isGameOver;
  bool get isVictory => _isVictory;
  bool get canUndo => _undoStack.isNotEmpty;

  // Historial de estados anteriores del tablero para deshacer movimientos
  final List<List<List<CellType>>> _undoStack = [];

  bool isCellSelected(BoardPosition position) {
    return _selectedPosition == position;
  }

  bool isValidDestination(BoardPosition position) {
    return getValidDestinations().contains(position);
  }

  bool _isValidMove(BoardPosition from, BoardPosition to) {
    final int rowDelta = (from.row - to.row).abs();
    final int colDelta = (from.col - to.col).abs();

    // 1. Debe ser un salto ortogonal estricto de distancia 2
    final bool isOrthogonalTwoStep =
        (rowDelta == 2 && colDelta == 0) || (rowDelta == 0 && colDelta == 2);

    if (!isOrthogonalTwoStep) return false;

    // 2. El destino debe ser un hueco vacío
    if (_board[to.row][to.col] != CellType.emptyHole) return false;

    // 3. La celda intermedia debe contener una clavija para ser capturada
    final int midRow = (from.row + to.row) ~/ 2;
    final int midCol = (from.col + to.col) ~/ 2;

    if (_board[midRow][midCol] != CellType.occupiedPeg) return false;

    return true;
  }

  void _executeMove(BoardPosition from, BoardPosition to) {
    final int midRow = (from.row + to.row) ~/ 2;
    final int midCol = (from.col + to.col) ~/ 2;

    _board[from.row][from.col] = CellType.emptyHole;
    _board[midRow][midCol] = CellType.emptyHole;
    _board[to.row][to.col] = CellType.occupiedPeg;

    _remainingPegs--;
    _moveCount++;

    logger.i(
      'Salto ejecutado con éxito: $from -> $to | Clavijas restantes: $_remainingPegs',
    );
  }

  void _evaluateGameTermination() {
    // Condición de Victoria: Queda exactamente 1 clavija en el tablero
    if (_remainingPegs == 1) {
      _isGameOver = true;
      _isVictory = true;

      logger.i('¡VICTORIA! Partida completada en $_moveCount movimientos.');
      return;
    }

    // No quedan saltos ortogonales válidos
    if (!_hasValidMovesRemaining()) {
      _isGameOver = true;
      _isVictory = false;
      logger.w('Fin de juego por bloqueo. No existen movimientos válidos.');
    }
  }

  /// Algoritmo exhaustivo de detección de estancamiento sobre las 33 casillas jugables.
  bool _hasValidMovesRemaining() {
    const List<List<int>> directions = [
      [-2, 0], // Arriba
      [2, 0], // Abajo
      [0, -2], // Izquierda
      [0, 2], // Derecha
    ];
    for (int r = 0; r < gridSize; r++) {
      for (int c = 0; c < gridSize; c++) {
        if (_board[r][c] == CellType.occupiedPeg) {
          final from = BoardPosition(r, c);
          for (final dir in directions) {
            final int targetRow = r + dir[0];
            final int targetCol = c + dir[1];
            // Validar que el salto potencial no desborde los límites de la matriz
            if (targetRow >= 0 &&
                targetRow < gridSize &&
                targetCol >= 0 &&
                targetCol < gridSize) {
              final to = BoardPosition(targetRow, targetCol);
              if (_board[targetRow][targetCol] != CellType.voidCell &&
                  _isValidMove(from, to)) {
                return true; // Existe al menos un movimiento válido en el tablero
              }
            }
          }
        }
      }
    }
    return false;
  }

  //Guardar estado del tablero
  void _saveBoardSnapshot() {
    final snapshot = _board.map((row) => List<CellType>.from(row)).toList();

    _undoStack.add(snapshot);

    logger.i(
      'Estado guardado en Undo Stack. '
      'Estados disponibles: ${_undoStack.length}',
    );
  }

  //Deshacer movimiento realizado
  void undoMove() {
    if (_undoStack.isEmpty) {
      logger.w('No existen movimientos para deshacer.');
      return;
    }

    _board = _undoStack.removeLast();

    _remainingPegs++;
    _moveCount--;

    _selectedPosition = null;
    _isGameOver = false;
    _isVictory = false;

    logger.i(
      'Movimiento deshecho. '
      'Movimientos: $_moveCount | '
      'Clavijas: $_remainingPegs',
    );

    notifyListeners();
  }

  //Obtener destinos validos para moverse
  List<BoardPosition> getValidDestinations() {
    final List<BoardPosition> destinations = [];

    if (_selectedPosition == null) {
      return destinations;
    }

    final BoardPosition origin = _selectedPosition!;

    const List<List<int>> directions = [
      [-2, 0], // Arriba
      [2, 0], // Abajo
      [0, -2], // Izquierda
      [0, 2], // Derecha
    ];

    for (final direction in directions) {
      final int targetRow = origin.row + direction[0];
      final int targetCol = origin.col + direction[1];

      if (targetRow >= 0 &&
          targetRow < gridSize &&
          targetCol >= 0 &&
          targetCol < gridSize) {
        final destination = BoardPosition(targetRow, targetCol);

        if (_isValidMove(origin, destination)) {
          destinations.add(destination);
        }
      }
    }

    return destinations;
  }

  PegSolitaireViewModel() {
    initializeBoard();
  }

  void initializeBoard() {
    _board = List.generate(gridSize, (row) {
      return List.generate(gridSize, (col) {
        // Esquinas no jugables (bloques 2x2 en las cuatro esquinas)
        if ((row < 2 || row > 4) && (col < 2 || col > 4)) {
          return CellType.voidCell;
        }
        // Centro estándar desocupado (3, 3)
        if (row == 3 && col == 3) {
          return CellType.emptyHole;
        }
        return CellType.occupiedPeg;
      });
    });

    _selectedPosition = null;
    _remainingPegs = 32;
    _moveCount = 0;
    _isGameOver = false;
    _isVictory = false;
    _undoStack.clear();
    notifyListeners();
  }

  /// Retorna el tipo de celda en una coordenada cartesiana segura.
  CellType getCellType(int row, int col) {
    if (row < 0 || row >= gridSize || col < 0 || col >= gridSize) {
      return CellType.voidCell;
    }
    return _board[row][col];
  }

  void onCellTapped(BoardPosition pos) {
    if (_isGameOver) {
      return;
    }
    final CellType tappedType = _board[pos.row][pos.col];
    if (tappedType == CellType.voidCell) return;
    // ESTADO 0: IDLE (No hay celda origen seleccionada)
    if (_selectedPosition == null) {
      if (tappedType == CellType.occupiedPeg) {
        _selectedPosition = pos;
        notifyListeners();
      }
      return;
    }

    // ESTADO 1: SOURCE_SELECTED (Existe una clavija origen activa)
    final BoardPosition origin = _selectedPosition!;
    // Transición 1.1: Pulsar sobre la misma casilla -> Deselección (Toggle)
    if (origin == pos) {
      _selectedPosition = null;
      notifyListeners();
      return;
    }
    // Transición 1.2: Pulsar sobre otra clavija propia -> Alternar selección
    if (tappedType == CellType.occupiedPeg) {
      _selectedPosition = pos;
      notifyListeners();
      return;
    }
    // Transición 1.3: Pulsar sobre un hueco vacío -> Evaluar salto y captura
    if (tappedType == CellType.emptyHole) {
      if (_isValidMove(origin, pos)) {
        _saveBoardSnapshot();

        _executeMove(origin, pos);
        _selectedPosition = null; // Regreso automático a IDLE tras el salto
        _evaluateGameTermination();
        notifyListeners();
      } else {
        logger.w(
          'Reglas: Intento de salto inválido rechazado desde $origin hacia $pos',
        );
      }
    }
  }
}
