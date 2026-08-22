import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

//Estados de la celda en el tablero
enum CellType {
  voidCell, //Fuera de limites jugables(esquinas 2x2)
  emptyHole, //Casilla jugable desocupada
  occupiedPeg, //Casilla jugable con clavija presente
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Solitario Ingles',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: PegSolitaireScreen(),
    );
  }
}

//Celdas individuales del tablero
class PegCell extends StatelessWidget {
  final int row;
  final int col;
  final CellType cellType;
  final bool isSelected;
  final VoidCallback? onTap;

  const PegCell({
    super.key,
    required this.row,
    required this.col,
    required this.cellType,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFD2A679),
          border: Border.all(color: const Color(0xFF8B5A2B), width: 1.5),
        ),

        child: Center(
          child: cellType == CellType.occupiedPeg
              ? Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Color(0xFF6B3E26),
                    shape: BoxShape.circle,
                  ),
                )
              : cellType == CellType.emptyHole
              ? Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: Color(0xFF8B5A2B),
                    shape: BoxShape.circle,
                  ),
                )
              : null, //No dibujar nada para voidCell
        ),
      ),
    );
  }
}

//Scaffold
class PegSolitaireScreen extends StatelessWidget {
  const PegSolitaireScreen({Key? key}) : super(key: key);

  static const int gridSize = 7;
  static const int totalCells = gridSize * gridSize; //49 casillas

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Solitario Ingles',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF5D4037),
        foregroundColor: Colors.white,
      ),

      body: SafeArea(
        // Protege la UI de los bordes del dispositivo
        child: Column(
          // Apila el marcador arriba y el tablero abajo
          children: [
            // Área de Status
            Container(
              height: 75,
              color: const Color(0xFF5D4037),
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
              crossAxisCount: 7, // 7 columnas
              crossAxisSpacing: 2.0,
              mainAxisSpacing: 2.0,
            ),
            itemCount: 49, // 7x7 = 49 celdas
            itemBuilder: (context, index) {
              //Convertir el indice en coordenadas matriciales
              final int row = index ~/ gridSize;
              final int col = index % gridSize;
              final CellType cellType = _getCellType(row, col);

              return PegCell(row: row, col: col, cellType: cellType);
            },
          ),
        ),
      ),
    );
  }
}
