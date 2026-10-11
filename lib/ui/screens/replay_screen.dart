import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_laboratorio/core/enums/cell_type.dart';
import 'package:flutter_laboratorio/models/board_position.dart';
import 'package:flutter_laboratorio/models/game_record.dart';
import 'package:flutter_laboratorio/ui/widgets/peg_cell.dart';
import 'package:flutter_laboratorio/viewmodels/peg_solitaire_view_model.dart';

class ReplayScreen extends StatefulWidget {
  final GameRecord record;

  const ReplayScreen({super.key, required this.record});

  @override
  State<ReplayScreen> createState() => _ReplayScreenState();
}

class _ReplayScreenState extends State<ReplayScreen> {
  Timer? _replayTimer;

  late List<List<CellType>> _board;

  int _currentMove = 0;
  int _remainingPegs = 32;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();

    _initializeReplayBoard();

    // Iniciar la reproducción automáticamente si hay movimientos guardados.
    if (widget.record.moves.isNotEmpty) {
      _startReplay();
    }
  }

  void _initializeReplayBoard() {
    _board = List.generate(PegSolitaireViewModel.gridSize, (row) {
      return List.generate(PegSolitaireViewModel.gridSize, (col) {
        // Las cuatro esquinas no forman parte del tablero jugable.
        if ((row < 2 || row > 4) && (col < 2 || col > 4)) {
          return CellType.voidCell;
        }

        // El hueco central comienza vacío.
        if (row == 3 && col == 3) {
          return CellType.emptyHole;
        }

        return CellType.occupiedPeg;
      });
    });

    _currentMove = 0;
    _remainingPegs = 32;
    _isPlaying = false;
  }

  void _startReplay() {
    if (_currentMove >= widget.record.moves.length) {
      return;
    }

    _replayTimer?.cancel();

    setState(() {
      _isPlaying = true;
    });

    _replayTimer = Timer.periodic(const Duration(milliseconds: 700), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_currentMove >= widget.record.moves.length) {
        timer.cancel();

        setState(() {
          _isPlaying = false;
        });

        return;
      }

      final move = widget.record.moves[_currentMove];

      final int fromRow = move.from.row;
      final int fromCol = move.from.col;
      final int toRow = move.to.row;
      final int toCol = move.to.col;

      final int midRow = (fromRow + toRow) ~/ 2;
      final int midCol = (fromCol + toCol) ~/ 2;

      setState(() {
        // Aplicar el salto registrado sobre el tablero pasivo.
        _board[fromRow][fromCol] = CellType.emptyHole;
        _board[midRow][midCol] = CellType.emptyHole;
        _board[toRow][toCol] = CellType.occupiedPeg;

        _remainingPegs--;
        _currentMove++;
      });

      // Detener el temporizador cuando termine la reproducción.
      if (_currentMove >= widget.record.moves.length) {
        timer.cancel();

        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  void _pauseReplay() {
    _replayTimer?.cancel();
    _replayTimer = null;

    setState(() {
      _isPlaying = false;
    });
  }

  void _restartReplay() {
    _replayTimer?.cancel();
    _replayTimer = null;

    setState(() {
      _initializeReplayBoard();
    });

    if (widget.record.moves.isNotEmpty) {
      _startReplay();
    }
  }

  @override
  void dispose() {
    // Evitar que el temporizador siga ejecutándose al salir de la pantalla.
    _replayTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int totalMoves = widget.record.moves.length;

    return Scaffold(
      appBar: AppBar(title: const Text('Reproducción de partida')),
      body: SafeArea(
        child: Column(
          children: [
            // Información del progreso de reproducción.
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      const Text(
                        'MOVIMIENTO',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$_currentMove / $totalMoves',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        'CLAVIJAS',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '$_remainingPegs',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Tablero pasivo: no se permiten movimientos manuales.
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: PegSolitaireViewModel.gridSize,
                            crossAxisSpacing: 2.0,
                            mainAxisSpacing: 2.0,
                          ),
                      itemCount:
                          PegSolitaireViewModel.gridSize *
                          PegSolitaireViewModel.gridSize,
                      itemBuilder: (context, index) {
                        final int row = index ~/ PegSolitaireViewModel.gridSize;
                        final int col = index % PegSolitaireViewModel.gridSize;

                        return PegCell(
                          position: BoardPosition(row, col),
                          cellType: _board[row][col],
                          onTap: null,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  if (totalMoves == 0)
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Esta partida no contiene movimientos guardados.',
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    Text(
                      _currentMove >= totalMoves
                          ? 'Reproducción finalizada'
                          : _isPlaying
                          ? 'Reproduciendo movimientos...'
                          : 'Reproducción pausada',
                    ),

                  const SizedBox(height: 8),

                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      FilledButton.icon(
                        onPressed: _isPlaying ? _pauseReplay : _startReplay,
                        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                        label: Text(_isPlaying ? 'Pausar' : 'Continuar'),
                      ),
                      OutlinedButton.icon(
                        onPressed: _restartReplay,
                        icon: const Icon(Icons.restart_alt),
                        label: const Text('Reiniciar'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
