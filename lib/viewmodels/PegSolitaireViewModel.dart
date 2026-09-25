import 'package:flutter/foundation.dart';
import 'package:flutter_laboratorio/models/board_position.dart';

import '../core/enums/cell_type.dart';

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
    notifyListeners();
  }

  /// Retorna el tipo de celda en una coordenada cartesiana segura.
  CellType getCellType(int row, int col) {
    if (row < 0 || row >= gridSize || col < 0 || col >= gridSize) {
      return CellType.voidCell;
    }
    return _board[row][col];
  }
}
