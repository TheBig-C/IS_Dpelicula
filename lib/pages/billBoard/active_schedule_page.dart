import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:is_dpelicula/controllers/billboard_controller.dart';
import 'package:is_dpelicula/controllers/function_controller.dart';
import 'package:is_dpelicula/controllers/movie_controllers.dart';
import 'package:is_dpelicula/controllers/room_controllers.dart';
import 'package:intl/intl.dart';
import 'package:is_dpelicula/models/billBoard.dart';
import 'package:is_dpelicula/models/functionCine.dart';
import 'package:is_dpelicula/models/movie.dart';
import 'package:is_dpelicula/models/room.dart';
import 'package:is_dpelicula/pages/billBoard/create_billboard_page.dart';

class ActiveSchedulePage extends ConsumerStatefulWidget {
  @override
  _ActiveSchedulePageState createState() => _ActiveSchedulePageState();
}

class _ActiveSchedulePageState extends ConsumerState<ActiveSchedulePage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final billboardState = ref.watch(billboardControllerProvider);
    final functionCineState = ref.watch(functionCineControllerProvider);
    final movieState = ref.watch(allMoviesProviderFuture);
    final roomState = ref.watch(roomControllerProvider);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
            bottomRight: Radius.circular(50.0),
          ),
          child: AppBar(
            title: Text(
              'Horario Activo',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.grey[700],
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateBillboardPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: MediaQuery.of(context).size.width > 800
            ? Center(
                child: SizedBox(width: 800, child: _buildContent(billboardState, functionCineState, movieState, roomState)),
              )
            : ListView(children: [_buildContent(billboardState, functionCineState, movieState, roomState)]),
      ),
    );
  }

  Widget _buildContent(
    AsyncValue<List<BillBoard>> billboardState,
    AsyncValue<List<FunctionCine>> functionCineState,
    AsyncValue<List<Movie>> movieState,
    AsyncValue<List<Room>> roomState,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: searchController,
            decoration: InputDecoration(
              labelText: 'Buscar por título de película',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (query) {
              setState(() {
                searchQuery = query.toLowerCase();
              });
            },
          ),
        ),
        Expanded(
          child: billboardState.when(
            data: (billboards) {
              print("Billboards data loaded: ${billboards.length}");
              final activeBillboard = billboards.isNotEmpty ? billboards.last : null;

              if (activeBillboard == null) {
                return Center(
                  child: Text('No hay un horario activo en este momento.'),
                );
              }

              print("Active Billboard found: ${activeBillboard.id}");

              return functionCineState.when(
                data: (functions) {
                  print("Functions data loaded: ${functions.length}");
                  final activeFunctions = functions
                      .where((function) => activeBillboard.functionIds.contains(function.id))
                      .toList();

                  if (activeFunctions.isEmpty) {
                    return Center(
                      child: Text('No hay funciones para el horario activo.'),
                    );
                  }

                  return movieState.when(
                    data: (movies) {
                      return roomState.when(
                        data: (rooms) {
                          final filteredFunctions = activeFunctions.where((function) {
                            final movie = movies.firstWhere(
                              (movie) => movie.id == function.movieId,
                            );
                            return movie != null && movie.title.toLowerCase().contains(searchQuery);
                          }).toList();

                          return ListView.builder(
                            itemCount: filteredFunctions.length,
                            itemBuilder: (context, index) {
                              final function = filteredFunctions[index];
                              final movie = movies.firstWhere(
                                (movie) => movie.id == function.movieId,
                              );
                              final room = rooms.firstWhere(
                                (room) => room.id == function.roomId,
                              );
                              final startTimeFormatted = DateFormat('yyyy-MM-dd – kk:mm').format(function.startTime);
                              final endTimeFormatted = DateFormat('yyyy-MM-dd – kk:mm').format(function.endTime);
                              print("Rendering function: ${function.movieId}, Start: ${function.startTime}, End: ${function.endTime}");
                              return Card(
                                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            width: 100,
                                            child: AspectRatio(
                                              aspectRatio: 2 / 3,
                                              child: movie != null && movie.posterPath != null
                                                  ? ClipRRect(
                                                      borderRadius: BorderRadius.circular(10),
                                                      child: Image.network(
                                                        movie.posterPath!,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    )
                                                  : Container(
                                                      width: 100,
                                                      height: 150,
                                                      color: Colors.grey,
                                                      child: Icon(
                                                        Icons.movie,
                                                        color: Colors.white,
                                                        size: 50,
                                                      ),
                                                    ),
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  movie != null ? movie.title : 'Película no encontrada',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 8),
                                                Text(
                                                  'Sala: ${room != null ? room.name : 'Sala no encontrada'}',
                                                  style: TextStyle(color: Colors.black),
                                                ),
                                                Text(
                                                  'Inicio: $startTimeFormatted',
                                                  style: TextStyle(color: Colors.black),
                                                ),
                                                Text(
                                                  'Fin: $endTimeFormatted',
                                                  style: TextStyle(color: Colors.black),
                                                ),
                                                Text(
                                                  'Precio: \$${function.price}',
                                                  style: TextStyle(color: Colors.black),
                                                ),
                                                if (movie != null && movie.overview != null)
                                                  Padding(
                                                    padding: const EdgeInsets.only(top: 5),
                                                    child: Text(
                                                      movie.overview!,
                                                      maxLines: 3,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(color: Colors.grey[600]),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        loading: () => Center(child: CircularProgressIndicator()),
                        error: (error, stackTrace) {
                          print("Error loading rooms: $error");
                          return Center(child: Text('Error al cargar las salas: $error'));
                        },
                      );
                    },
                    loading: () => Center(child: CircularProgressIndicator()),
                    error: (error, stackTrace) {
                      print("Error loading movies: $error");
                      return Center(child: Text('Error al cargar las películas: $error'));
                    },
                  );
                },
                loading: () => Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) {
                  print("Error loading functions: $error");
                  return Center(child: Text('Error al cargar las funciones: $error'));
                },
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) {
              print("Error loading billboards: $error");
              return Center(child: Text('Error al cargar los horarios: $error'));
            },
          ),
        ),
      ],
    );
  }
}
