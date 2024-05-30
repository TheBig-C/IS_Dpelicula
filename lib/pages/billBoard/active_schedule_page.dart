import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:is_dpelicula/controllers/billboard_controller.dart';
import 'package:is_dpelicula/controllers/function_controller.dart';
import 'package:is_dpelicula/core/extensions.dart';
import 'package:is_dpelicula/models/billBoard.dart';
import 'package:is_dpelicula/models/functionCine.dart';
import 'package:intl/intl.dart';

class ActiveSchedulePage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final billboardState = ref.watch(billboardControllerProvider);
    final functionCineState = ref.watch(functionCineControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Horario Activo'),
      ),
      body: billboardState.when(
        data: (billboards) {
          final activeBillboard = billboards.firstWhereOrNull((billboard) => billboard.isActive);

          if (activeBillboard == null) {
            return Center(
              child: Text('No hay un horario activo en este momento.'),
            );
          }

          return functionCineState.when(
            data: (functions) {
              final activeFunctions = functions
                  .where((function) => activeBillboard.functionIds.contains(function.id))
                  .toList();

              if (activeFunctions.isEmpty) {
                return Center(
                  child: Text('No hay funciones para el horario activo.'),
                );
              }

              return ListView.builder(
                itemCount: activeFunctions.length,
                itemBuilder: (context, index) {
                  final function = activeFunctions[index];
                 // final startTimeFormatted =function.startTime;
             //     final endTimeFormatted = function.endTime;
                  return ListTile(
                    title: Text('Película: ${function.movieId}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sala: ${function.roomId}'),
                        //Text('Inicio: $startTimeFormatted'),
                       // Text('Fin: $endTimeFormatted'),
                        Text('Precio: \$${function.price}'),
                      ],
                    ),
                  );
                },
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(child: Text('Error al cargar las funciones: $error')),
          );
        },
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(child: Text('Error al cargar los horarios: $error')),
      ),
    );
  }
}
