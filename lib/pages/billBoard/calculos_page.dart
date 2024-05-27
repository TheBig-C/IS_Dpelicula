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
            children: [
              Text(
                'Matriz de Costos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _buildMatrixTable(costsMatrix),
              SizedBox(height: 20),
              Text(
                'Matriz de Asignación',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              _buildMatrixTable(assignmentMatrix),
              SizedBox(height: 20),
              Text(
                'Grafo Correspondiente a la Matriz de Costos',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GrafoWidget(matrix: costsMatrix),
              SizedBox(height: 20),
              Text(
                'Grafo Correspondiente a la Matriz de Asignación',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GrafoWidget(matrix: assignmentMatrix),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMatrixTable(List<List<int>> matrix) {
    return Table(
      border: TableBorder.all(),
      children: [
        for (var row in matrix)
          TableRow(
            children: [
              for (var value in row)
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
    );
  }
}
