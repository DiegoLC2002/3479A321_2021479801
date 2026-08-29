import 'package:flutter/material.dart';
import 'package:flutter_laboratorio/core/enums/cell_type.dart';
import 'package:flutter_laboratorio/ui/theme/app_theme.dart';

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
    final bool isPlayable = cellType != CellType.voidCell;

    return GestureDetector(
      onTap: isPlayable ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isPlayable ? AppTheme.boardBaseColor : Colors.transparent,
          border: isPlayable
              ? Border.all(
                  color: isSelected
                      ? AppTheme.selectedPegColor
                      : AppTheme.boardBorderColor,
                  width: isSelected ? 3 : 1.5,
                )
              : null,
        ),

        child: Center(
          child: cellType == CellType.occupiedPeg
              ? AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: isSelected ? 38 : 30,
                  height: isSelected ? 38 : 30,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppTheme.selectedPegColor
                        : AppTheme.pegColor,
                    shape: BoxShape.circle,
                    boxShadow: isSelected
                        ? const [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(0, 3),
                            ),
                          ]
                        : null,
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, color: Colors.white, size: 20)
                      : ClipOval(
                          child: Image.asset(
                            'assets/icons/icon_image.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                )
              : cellType == CellType.emptyHole
              ? Container(
                  width: 30,
                  height: 30,
                  decoration: const BoxDecoration(
                    color: AppTheme.emptyHoleColor,
                    shape: BoxShape.circle,
                  ),
                )
              : null, //No dibujar nada para voidCell
        ),
      ),
    );
  }
}
