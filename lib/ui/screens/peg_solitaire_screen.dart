import 'package:flutter/material.dart';
import 'package:flutter_laboratorio/core/enums/cell_type.dart';

import '../widgets/peg_cell.dart';
import '../screens/rules_screen.dart';
import '../screens/about_screen.dart';

import 'package:flutter_laboratorio/models/foundation.dart';

import 'package:logger/logger.dart';

var logger = Logger(printer: PrettyPrinter());
GameRecord _lastGameRecord = GameRecord(
  id: '007',
  date: DateTime(2026, 9, 7, 17, 30),
  remainingPegs: 5,
  totalMoves: 18,
  durationSeconds: 90,
  isVictory: true,
);

class PegSolitaireScreen extends StatefulWidget {
  const PegSolitaireScreen({super.key});

  @override
  State<PegSolitaireScreen> createState() => _PegSolitaireScreenState();
}

class _PegSolitaireScreenState extends State<PegSolitaireScreen> {
  static const int gridSize = 7;
  static const int totalCells = gridSize * gridSize; //49 casillas

  int? selectedRow;
  int? selectedCol;

  //Determinar el tipo de celda segun sus cordenadas matriciales (row, col)
  CellType _getCellType(int row, int col) {
    //Esquinas 2x2 no jugables en el tablero ingles estandar
    final bool isCorner = (row < 2 || row > 4) && (col < 2 || col > 4);

    if (isCorner) {
      return CellType.voidCell;
    }

    //El centro comienza vacio
    if (row == 3 && col == 3) {
      return CellType.emptyHole;
    }

    return CellType
        .occupiedPeg; //El resto de las 33 posiciones aparecen ocupadas.
  }

  void selectCell(int row, int col, CellType cellType) {
    // Solo se pueden seleccionar clavijas.
    if (cellType != CellType.occupiedPeg) {
      return;
    }

    setState(() {
      // Si se toca nuevamente la misma clavija, se deselecciona.
      if (selectedRow == row && selectedCol == col) {
        selectedRow = null;
        selectedCol = null;
        logger.i('Clavija deseleccionada: ($row, $col)');
      } else {
        selectedRow = row;
        selectedCol = col;
        logger.i('Clavija seleccionada: ($row, $col)');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Solitario Ingles',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        //backgroundColor: const Color(0xFF5D4037),
        //foregroundColor: Colors.white,

        //Boton para reglas del juego
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            tooltip: 'Reglas del juego',
            onPressed: () {
              logger.i('Navegando a RulesScreen desde PegSolitaireScreen');
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RulesScreen()),
              );
            },
          ),

          //Boton para informacion del proyecto
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: 'Sobre el proyecto',
            onPressed: () {
              logger.i('Navegando a AboutScreen desde PegSolitaireScreen');

              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AboutScreen()),
              );
            },
          ),
        ],
      ),

      body: SafeArea(
        // Protege la UI de los bordes del dispositivo
        child: Column(
          // Apila el marcador arriba y el tablero abajo
          children: [
            // Área de Status
            Container(
              height: 75,
              color: Theme.of(context).colorScheme.primary,
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'TIEMPO',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '349 s',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'PIEZAS',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '32',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 1, thickness: 1),
            // Área de Juego
            Expanded(
              // Expande el tablero para llenar la pantalla
              child: _gameBoard(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _gameBoard() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AspectRatio(
          aspectRatio: 1.0, // Cuadrado perfecto
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(), // Bloquea el scroll
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridSize, // 7 columnas
              crossAxisSpacing: 2.0,
              mainAxisSpacing: 2.0,
            ),
            itemCount: totalCells, // 7x7 = 49 celdas
            itemBuilder: (context, index) {
              //Convertir el indice en coordenadas matriciales
              final int row = index ~/ gridSize;
              final int col = index % gridSize;
              final CellType cellType = _getCellType(row, col);

              final bool isSelected = selectedRow == row && selectedCol == col;

              logger.i(
                "Último registro de juego:Piezas restantes ${_lastGameRecord.remainingPegs}, "
                "${_lastGameRecord.durationSeconds} segundos jugados",
              );

              return PegCell(
                row: row,
                col: col,
                cellType: cellType,
                isSelected: isSelected,
                onTap: () => selectCell(row, col, cellType),
              );
            },
          ),
        ),
      ),
    );
  }
}
