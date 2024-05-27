import 'dart:math';
import 'package:flutter/material.dart';
import 'package:is_dpelicula/pages/billBoard/modelos.dart';
import 'package:is_dpelicula/pages/billBoard/formas.dart';

class GrafoWidget extends StatefulWidget {
  final List<List<int>> matrix;

  const GrafoWidget({Key? key, required this.matrix}) : super(key: key);

  @override
  _GrafoWidgetState createState() => _GrafoWidgetState();
}

class _GrafoWidgetState extends State<GrafoWidget> {
  List<ModeloNodo> vNodo = [];
  List<ModeloEnlace> vEnlace = [];

  @override
  void initState() {
    super.initState();
    _generarGrafoDesdeMatriz(widget.matrix);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      child: CustomPaint(
        painter: Nodo(vNodo, vEnlace),
      ),
    );
  }

  void _generarGrafoDesdeMatriz(List<List<int>> matrizAdyacencia) {
    // Limpiar nodos y enlaces actuales
    vNodo.clear();
    vEnlace.clear();

    // Tamaño del área de dibujo
    double width = 400;
    double height = 400;

    // Ajuste de margen
    double margin = 50.0;

    // Calcular posiciones de nodos
    int numNodos = matrizAdyacencia.length - 1;
    for (int i = 0; i < numNodos; i++) {
      // Distribuir nodos en un círculo
      double angle = 2 * pi * i / numNodos;
      double x = width / 2 + (width / 2 - margin) * cos(angle);
      double y = height / 2 + (height / 2 - margin) * sin(angle);

      vNodo.add(ModeloNodo('N$i', x, y, 20, Colors.amber));
    }

    // Crear enlaces a partir de la matriz de adyacencia
    for (int i = 0; i < numNodos; i++) {
      for (int j = 0; j < numNodos; j++) {
        if (matrizAdyacencia[i][j] != 0) {
          String valor = matrizAdyacencia[i][j].toString();
          vEnlace.add(ModeloEnlace(i, j, valor, true));
        }
      }
    }
  }
}
