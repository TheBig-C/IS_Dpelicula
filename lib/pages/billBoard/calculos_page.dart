import 'dart:math';
import 'package:flutter/material.dart';
import 'package:is_dpelicula/pages/billBoard/grafo_widget.dart';

class CalculosPage extends StatelessWidget {
  final List<List<int>> costsMatrix;
  final List<List<int>> assignmentMatrix;

  const CalculosPage({
    Key? key,
    required this.costsMatrix,
    required this.assignmentMatrix,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cálculos y Grafos'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Cálculos de la Matriz de Costos y Asignación',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                'Este cálculo se realizó utilizando el método del noroeste para asignar películas a las salas y horarios disponibles de manera óptima.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Matriz de Costos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              _buildMatrixTable(costsMatrix, "Películas/Funciones", "Películas", "Funciones"),
              SizedBox(height: 20),
              Text(
                'Matriz de Asignación',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              _buildMatrixTable(assignmentMatrix, "Asignación de Funciones", "Películas", "Funciones"),
              SizedBox(height: 20),
              Text(
                'Grafo Correspondiente a la Matriz de Costos',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              GrafoWidget(matrix: costsMatrix),
              SizedBox(height: 20),
              Text(
                'Grafo Correspondiente a la Matriz de Asignación',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              GrafoWidget(matrix: assignmentMatrix),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatrixTable(List<List<int>> matrix, String label, String rowLabel, String colLabel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Table(
          border: TableBorder.all(),
          children: [
            TableRow(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(''),
                ),
                for (int i = 0; i < matrix[0].length; i++)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '$colLabel ${i + 1}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
            for (int i = 0; i < matrix.length; i++)
              TableRow(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '$rowLabel ${i + 1}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  for (var value in matrix[i])
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        value.toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
