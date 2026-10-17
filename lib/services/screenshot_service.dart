import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_laboratorio/core/utils/app_logger.dart';
import 'package:path_provider/path_provider.dart';

/// Servicio para extraer buffers visuales del Render Tree
/// y convertirlos en archivos de imagen.
class ScreenshotService {
  static Future<String?> captureWidgetToImage(GlobalKey boundaryKey) async {
    try {
      final boundary =
          boundaryKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

      if (boundary == null) {
        AppLogger.warning(
          'No se encontró RenderRepaintBoundary asociado a la GlobalKey',
        );
        return null;
      }

      // Renderizado a imagen con escala para alta definición.
      final ui.Image image = await boundary.toImage(pixelRatio: 2.0);

      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData == null) {
        AppLogger.warning('No se pudieron obtener los bytes de la captura');
        image.dispose();
        return null;
      }

      final buffer = byteData.buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      );

      final tempDir = await getTemporaryDirectory();

      final filePath =
          '${tempDir.path}/peg_solitaire_record_'
          '${DateTime.now().millisecondsSinceEpoch}.png';

      final file = File(filePath);
      await file.writeAsBytes(buffer, flush: true);

      image.dispose();

      AppLogger.info('Evidencia gráfica capturada con éxito en: $filePath');

      return filePath;
    } catch (e, stackTrace) {
      AppLogger.error(
        'Error al capturar evidencia gráfica del tablero',
        e,
        stackTrace,
      );
      return null;
    }
  }
}
