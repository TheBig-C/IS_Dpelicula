import 'dart:ui';
import 'package:flutter/material.dart';
import 'dart:math';
import 'modelos.dart';

class Nodo extends CustomPainter {
  List<ModeloNodo> vNodo;
  List<ModeloEnlace> vEnlace;

  Nodo(this.vNodo, this.vEnlace);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    // Dibujar los nodos
    for (final nodo in vNodo) {
      paint.color = nodo.color;
      canvas.drawCircle(Offset(nodo.x, nodo.y), nodo.radio, paint);

      // Dibujar etiquetas en los nodos
      final textSpan = TextSpan(
        text: nodo.etiqueta,
        style: TextStyle(color: Colors.white, fontSize: 22),
      );
      final textPainter = TextPainter(
        text: textSpan,
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );
      textPainter.layout();
      final offset = Offset(nodo.x - textPainter.width / 2, nodo.y - textPainter.height / 2);
      textPainter.paint(canvas, offset);
    }

    paint
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.black;

    final textPainter = TextPainter(
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    // Dibujar enlaces entre nodos
    for (final enlace in vEnlace) {
      final nodoInicio = vNodo[enlace.nodoInicio];
      final nodoFinal = vNodo[enlace.nodoFinal];
      final startPoint = calculateEdgePoint(nodoInicio.x, nodoInicio.y, nodoFinal.x, nodoFinal.y, nodoInicio.radio);
      final endPoint = calculateEdgePoint(nodoFinal.x, nodoFinal.y, nodoInicio.x, nodoInicio.y, nodoFinal.radio);

      // Dibujar la línea recta o curva
      if (enlace.esCurva) {
        final controlPoint = Offset((startPoint.dx + endPoint.dx) / 2, (startPoint.dy + endPoint.dy) / 2 - 50);
        final path = Path()
          ..moveTo(startPoint.dx, startPoint.dy)
          ..quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy);
        canvas.drawPath(path, paint);
        drawArrow(canvas, paint, path);
      } else {
        canvas.drawLine(startPoint, endPoint, paint);
        drawArrow(canvas, paint, Path()..moveTo(startPoint.dx, startPoint.dy)..lineTo(endPoint.dx, endPoint.dy));
      }

      // Dibujar etiqueta del enlace
      final midPoint = Offset((startPoint.dx + endPoint.dx) / 2, (startPoint.dy + endPoint.dy) / 2);
      textPainter.text = TextSpan(
        text: enlace.valor,
        style: TextStyle(color: Colors.lightBlueAccent.shade700, fontSize: 20),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(midPoint.dx - textPainter.width / 2, midPoint.dy - textPainter.height / 2));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;

  Offset calculateEdgePoint(double x1, double y1, double x2, double y2, double radius) {
    double angle = atan2(y2 - y1, x2 - x1);
    return Offset(x1 + cos(angle) * radius, y1 + sin(angle) * radius);
  }

  void drawArrow(Canvas canvas, Paint paint, Path path) {
    final pathMetrics = path.computeMetrics();
    for (final pathMetric in pathMetrics) {
      final length = pathMetric.length;
      final end = pathMetric.getTangentForOffset(length)?.position ?? Offset.zero;
      final start = pathMetric.getTangentForOffset(length - 10)?.position ?? Offset.zero;

      final angle = atan2(end.dy - start.dy, end.dx - start.dx);
      const arrowSize = 10.0;
      final arrowPath = Path()
        ..moveTo(end.dx, end.dy)
        ..lineTo(end.dx - arrowSize * cos(angle - pi / 6), end.dy - arrowSize * sin(angle - pi / 6))
        ..moveTo(end.dx, end.dy)
        ..lineTo(end.dx - arrowSize * cos(angle + pi / 6), end.dy - arrowSize * sin(angle + pi / 6));
      canvas.drawPath(arrowPath, paint);
    }
  }
}
