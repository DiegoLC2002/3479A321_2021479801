import 'package:flutter/material.dart';
import 'package:flutter_laboratorio/core/enums/cell_type.dart';

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

                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 20)
                      : Image.asset('assets/icons/icon_image.jpg'),
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
