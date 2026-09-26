import 'package:flutter/material.dart';
import 'package:flutter_laboratorio/core/enums/cell_type.dart';
import 'package:flutter_laboratorio/models/board_position.dart';
import 'package:flutter_laboratorio/viewmodels/peg_solitaire_view_model.dart';

import '../widgets/peg_cell.dart';
import '../screens/rules_screen.dart';
import '../screens/about_screen.dart';

import 'package:provider/provider.dart';
import 'package:logger/logger.dart';

var logger = Logger(printer: PrettyPrinter());

class PegSolitaireScreen extends StatelessWidget {
  const PegSolitaireScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PegSolitaireViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Solitario Ingles',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        //backgroundColor: const Color(0xFF5D4037),
        //foregroundColor: Colors.white,

        //Botones
        actions: [
          IconButton(
            icon: const Icon(Icons.undo_rounded),
            tooltip: 'Deshacer movimiento',
            onPressed: vm.canUndo
                ? () {
                    context.read<PegSolitaireViewModel>().undoMove();
                  }
                : null,
          ),

          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Reiniciar Tablero',
            onPressed: () {
              context.read<PegSolitaireViewModel>().initializeBoard();
            },
          ),
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
            //Area de estado
            _buildScoreBoard(context, vm),

            const Divider(height: 1),

            //Area de juego
            Expanded(child: _gameBoard(context, vm)),

            //Mensaje de finalizacion
            if (vm.isGameOver) _buildGameOverBanner(context, vm),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBoard(BuildContext context, PegSolitaireViewModel vm) {
    return Container(
      height: 75,
      color: Theme.of(context).colorScheme.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'MOVIMIENTOS',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${vm.moveCount}',
                style: const TextStyle(
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
              const Text(
                'PIEZAS',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${vm.remainingPegs}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _gameBoard(BuildContext context, PegSolitaireViewModel vm) {
    logger.i('Construyendo el tablero de juego');

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AspectRatio(
          aspectRatio: 1.0,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),

            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: PegSolitaireViewModel.gridSize,
              crossAxisSpacing: 2.0,
              mainAxisSpacing: 2.0,
            ),

            itemCount:
                PegSolitaireViewModel.gridSize * PegSolitaireViewModel.gridSize,

            itemBuilder: (context, index) {
              final int row = index ~/ PegSolitaireViewModel.gridSize;
              final int col = index % PegSolitaireViewModel.gridSize;
              final position = BoardPosition(row, col);
              final CellType cellType = vm.getCellType(row, col);

              return PegCell(
                position: position,
                cellType: cellType,
                isSelected: vm.isCellSelected(position),
                onTap: () {
                  context.read<PegSolitaireViewModel>().onCellTapped(position);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildGameOverBanner(BuildContext context, PegSolitaireViewModel vm) {
    final bool victory = vm.isVictory;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      color: victory ? Colors.green.shade700 : Colors.red.shade700,
      child: Column(
        children: [
          Icon(
            victory ? Icons.emoji_events : Icons.block,
            color: Colors.white,
            size: 32,
          ),

          const SizedBox(height: 6),

          Text(
            victory ? '¡Victoria!' : 'Partida finalizada',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            victory
                ? 'Has conseguido dejar una sola clavija.'
                : 'No quedan movimientos válidos.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),

          const SizedBox(height: 10),

          OutlinedButton.icon(
            onPressed: () {
              context.read<PegSolitaireViewModel>().initializeBoard();
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Nueva partida'),
            style: OutlinedButton.styleFrom(
              foregroundColor: Colors.white,
              side: const BorderSide(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
