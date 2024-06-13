import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:is_dpelicula/controllers/room_controllers.dart';
import 'package:is_dpelicula/models/functionCine.dart';
import 'package:is_dpelicula/models/movie.dart';
import 'package:is_dpelicula/controllers/movie_controllers.dart';
import 'package:is_dpelicula/models/room.dart';
import 'package:is_dpelicula/controllers/billboard_controller.dart';
import 'package:is_dpelicula/models/billBoard.dart';
import 'package:is_dpelicula/core/extensions.dart';
import 'dart:math';
import 'package:is_dpelicula/pages/billBoard/roomSlot.dart';
import 'package:is_dpelicula/pages/billBoard/calculos_page.dart';

class CreateBillboardPage extends ConsumerStatefulWidget {
  const CreateBillboardPage({Key? key}) : super(key: key);

  @override
  _CreateBillboardPageState createState() => _CreateBillboardPageState();
}

class _CreateBillboardPageState extends ConsumerState<CreateBillboardPage> {
  final Map<String, List<FunctionCine>> _schedule = {};
  String? _selectedMovieId;
  List<List<int>> costsMatrix = [];
  List<List<int>> assignmentMatrix = [];

  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(getAllMoviesProvider.future));
    Future.microtask(
        () => ref.read(roomControllerProvider.notifier).fetchRooms());
  }

  @override
  Widget build(BuildContext context) {
    final movieListAsyncValue = ref.watch(allMoviesProviderFuture);
    final roomListAsyncValue = ref.watch(roomControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Crear Cartelera'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _clearSchedule,
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveSchedule,
          ),
          IconButton(
            icon: Icon(Icons.autorenew),
            onPressed: _autoFillSchedule,
          ),
          IconButton(
            icon: Icon(Icons.show_chart),
            onPressed: _mostrarCalculos,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Flexible(
                flex: 1,
                child: _buildMoviesList(movieListAsyncValue),
              ),
              SizedBox(width: 20),
              Flexible(
                flex: 3,
                child: Column(
                  children: [
                    _buildRoomHeaders(roomListAsyncValue),
                    SizedBox(height: 10),
                    Expanded(
                      child: _buildScheduleMatrix(roomListAsyncValue),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _autoFillSchedule() {
    final movieListAsyncValue = ref.read(allMoviesProviderFuture);
    final roomListAsyncValue = ref.read(roomControllerProvider);

    movieListAsyncValue.when(
      data: (movies) {
        final nowPlayingMovies = movies.where((movie) => movie.status == "en cartelera").toList();
        roomListAsyncValue.when(
          data: (rooms) {
            if (nowPlayingMovies.isEmpty || rooms.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('No se pueden obtener películas o salas.'),
                  backgroundColor: Colors.red,
                ),
              );
              return;
            }

            costsMatrix = _buildCostsMatrix(nowPlayingMovies, rooms);
            assignmentMatrix = northWest(costsMatrix);

            _applyAssignmentToSchedule(assignmentMatrix, nowPlayingMovies, rooms);
          },
          loading: () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Cargando salas...'),
              backgroundColor: Colors.blue,
            ),
          ),
          error: (error, stackTrace) => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error al cargar salas: $error'),
              backgroundColor: Colors.red,
            ),
          ),
        );
      },
      loading: () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cargando películas...'),
          backgroundColor: Colors.blue,
        ),
      ),
      error: (error, stackTrace) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al cargar películas: $error'),
          backgroundColor: Colors.red,
        ),
      ),
    );
  }

  List<List<int>> _buildCostsMatrix(List<Movie> movies, List<Room> rooms) {
    int numMovies = movies.length;
    int numSlots = rooms.length * 6; // Asumiendo 6 slots por sala como ejemplo

    List<List<int>> costsMatrix = List.generate(
      numMovies + 1, 
      (i) => List.generate(numSlots + 1, (j) => 50), 
      growable: false
    );

    for (int i = 0; i < numMovies; i++) {
      costsMatrix[i][numSlots] = movies[i].usBoxOffice;
    }

    for (int j = 0; j < numSlots; j++) {
      costsMatrix[numMovies][j] = 50; // Ejemplo con oferta fija de 50
    }

    costsMatrix[numMovies][numSlots] = 0; // Cierre de oferta y demanda

    return costsMatrix;
  }

List<List<int>> northWest(List<List<int>> costsMatrix) {
    int numRows = costsMatrix.length;
    int numCols = costsMatrix[0].length;
    List<List<int>> assignmentMatrix = List.generate(numRows - 1, (i) => List.filled(numCols - 1, 0));

    List<int> supply = getSupply(costsMatrix);
    List<int> demand = getDemand(costsMatrix);

    int i = 0, j = 0;

    while (i < supply.length && j < demand.length) {
      int amount = min(supply[i], demand[j]);
      assignmentMatrix[i][j] = amount;

      supply[i] -= amount;
      demand[j] -= amount;

      if ( supply[i] == 0 && i < supply.length) i++;
      if ( demand[j] == 0 && j < demand.length) j++;
    }

    return assignmentMatrix;
  }

// Funciones de apoyo
List<int> getSupply(List<List<int>> matrix) {
  return matrix.take(matrix.length - 1).map((row) => row.last).toList();
}

List<int> getDemand(List<List<int>> matrix) {
  return matrix.last.take(matrix[0].length - 1).toList();
}

// Incluye aquí las funciones convertidas de JS a Dart

void modiMethodMax(List<List<int>> costsMatrix, List<List<int>> assignmentMatrix) {
  bool improvement = true;
  int ccc = 0;
  while (improvement) {
    ccc++;
    print(ccc);
    if(ccc >= 100){
      break;
    }
    int numRows = costsMatrix.length - 1;
    int numCols = costsMatrix[0].length - 1;
    List<int?> u = List.filled(numRows, null);
    List<int?> v = List.filled(numCols, null);
    List<List<int>> markedIndices = [];

    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < numCols; j++) {
        if (assignmentMatrix[i][j] > 0) {
          markedIndices.add([i, j]);
        }
      }
    }

    u[0] = 0;
    bool progressMade;
    int ddd = 0;
    do {
      print(u);
      print(v);
      progressMade = false;
      List<List<int>> remainingIndices = [];
      for (int index = 0; index < markedIndices.length; index++) {
        int i = markedIndices[index][0];
        int j = markedIndices[index][1];
        if (u[i] != null && v[j] == null) {
          v[j] = costsMatrix[i][j] - u[i]!;
          progressMade = true;
        } else if (u[i] == null && v[j] != null) {
          u[i] = costsMatrix[i][j] - v[j]!;
          progressMade = true;
        } else {
          remainingIndices.add([i, j]);
        }
      }
      markedIndices = remainingIndices;
      if (!progressMade && markedIndices.isNotEmpty) {
        int i = markedIndices[0][0];
        int j = markedIndices[0][1];
        if (u[i] == null) {
          u[i] = 0;
        } else {
          v[j] = 0;
        }
        progressMade = true;
      }
      ddd++;
      if(ddd >= 1000){
        break;
      }
    } while (progressMade && markedIndices.isNotEmpty);

    print(u);
    print(v);

    List<List<int>> d = List.generate(numRows, (_) => List.filled(numCols, 0));
    bool canImprove = false;
    for (int i = 0; i < numRows; i++) {
      for (int j = 0; j < numCols; j++) {
        if (assignmentMatrix[i][j] == 0) {
          d[i][j] = u[i]! + v[j]! - costsMatrix[i][j];
          if (d[i][j] < 0) canImprove = true;
        }
      }
    }
    print("matrixd");
    for (int i = 0; i < d.length; i++) {
      print(d[i]);
    }
    var matrix1 = List<List<int>>.generate(assignmentMatrix.length, (i) => List<int>.from(assignmentMatrix[i]));
    print("matrix");
    for (int i = 0; i < matrix1.length; i++) {
      print(matrix1[i]);
    }
    if (canImprove) {
      int maxPositive = 0;
      List<List<int>> cellsToImprove = [];
      for (int i = 0; i < numRows; i++) {
        for (int j = 0; j < numCols; j++) {
          if (d[i][j] < maxPositive) {
            maxPositive = d[i][j];
            cellsToImprove = [[i, j]];
          } else if (d[i][j] == maxPositive) {
            cellsToImprove.add([i, j]);
          }
        }
      }

      print(cellsToImprove);
      bool cycleFound = false;
      for (var cell in cellsToImprove) {
        try {
          var cycle = findCycle(assignmentMatrix, cell);
          if (cycle != null) {
            adjustAssignmentsMax(assignmentMatrix, cycle);
            print("Se puede mejorar la solución, se encontró un ciclo para la celda: $cell");
            cycleFound = true;
            break;
          } else {
            improvement = false;
          }
        } catch (e) {
          if (e is TypeError && e.toString().contains("null")) {
            print("Valor nulo encontrado, continuando con el siguiente elemento.");
            continue;
          } else {
            print("Error encontrado: $e");
            break;
          }
        }
      }

      if (!cycleFound) {
        print("No se puede mejorar, no se encontró un ciclo para ninguna celda candidata");
        improvement = false;
      }
    } else {
      improvement = false;
    }
  }
}

void adjustAssignmentsMax(List<List<int>> assignmentMatrix, List<List<int>> cycle) {
  int min = 0;
  for (int i = 1; i < cycle.length; i += 2) {
    var r = cycle[i][0];
    var c = cycle[i][1];
    min = min > assignmentMatrix[r][c] ? assignmentMatrix[r][c] : min;
  }

  for (int i = 0; i < cycle.length; ++i) {
    var r = cycle[i][0];
    var c = cycle[i][1];
    if (i % 2 == 0) {
      assignmentMatrix[r][c] += min;
    } else {
      assignmentMatrix[r][c] -= min;
    }
  }
}

List<List<int>>? findCycle(List<List<int>> matrix, List<int> startCell) {
  bool cantB = true;
  int c = 0;
  List<List<int>> d = [], matriz = [], valor1 = [], valo2 = [];
  String va = "primero";
  List<int>? anterior;
  final directions = [
    [-1, 0],
    [1, 0],
    [0, -1],
    [0, 1],
  ];
  final dire1 = [
    [-1, 0],
    [1, 0],
  ];
  final dire2 = [
    [0, -1],
    [0, 1],
  ];
  int contador = 0;
  copiarMatriz(matrix, matriz);
  List<int> siguiente = startCell;

  do {
    print("va: $va");

    if (contador == 0) {
      cantB = false;
      c = 0;
      int auxi = startCell[0];
      int auxj = startCell[1];
      if (auxi + 1 < matrix.length && matrix[auxi + 1][auxj] > 0) c++;
      if (auxi - 1 >= 0 && matrix[auxi - 1][auxj] > 0) c++;
      if (auxj + 1 < matrix[0].length && matrix[auxi][auxj + 1] > 0) c++;
      if (auxj - 1 >= 0 && matrix[auxi][auxj - 1] > 0) c++;
      if (c < 2) {
        cantB = true;
        break;
      }
      anterior = null;
      siguiente = startCell;
      valor1 = [];
      valo2 = [];
      copiarMatriz(matrix, matriz);
      contador++;
    }

    if (va == "primero") {
      matriz[siguiente[0]][siguiente[1]] = 0;
      anterior = siguiente;
      siguiente = buscarPrimero(anterior, matriz, dire1);
      valor1.add(anterior);
      va = "segundo";
      continue;
    }

    if (va == "segundo") {
      matriz[siguiente[0]][siguiente[1]] = 0;
      anterior = siguiente;
      siguiente = buscarPrimero(anterior, matriz, dire2);
      valo2.add(anterior);
      if (siguiente[0] == startCell[0] && siguiente[1] == startCell[1]) {
        print("anterior: $anterior");
        print("startCell: $startCell");
        valor1.add(anterior);
        valor1.add(startCell);
        va = "encontrado";
        break;
      }
      va = "primero";
      continue;
    }
  } while (contador <= 10000);

  if (va != "encontrado" || cantB) return null;

  for (var i = 0; i < valor1.length; i++) {
    d.add(valor1[i]);
  }
  for (var i = valo2.length - 1; i >= 0; i--) {
    d.add(valo2[i]);
  }

  return d;
}

void copiarMatriz(List<List<int>> original, List<List<int>> copia) {
  copia.clear();
  for (var fila in original) {
    copia.add(List.from(fila));
  }
}

List<int> buscarPrimero(List<int>? anterior, List<List<int>> matriz, List<List<int>> direccion) {
  List<int> siguiente = [];
  if (anterior != null) {
    for (var dir in direccion) {
      int nuevaFila = anterior[0] + dir[0];
      int nuevaColumna = anterior[1] + dir[1];
      if (nuevaFila >= 0 && nuevaFila < matriz.length && nuevaColumna >= 0 && nuevaColumna < matriz[0].length && matriz[nuevaFila][nuevaColumna] != 0) {
        siguiente = [nuevaFila, nuevaColumna];
        break;
      }
    }
  }
  return siguiente;
}

  void _applyAssignmentToSchedule(List<List<int>> assignmentMatrix, List<Movie> movies, List<Room> rooms) {
    int numMovies = movies.length;
    int numRooms = rooms.length;
    int numSlots = 6; // Asumiendo 6 slots por sala como ejemplo

    // Inicializar el horario
    _schedule.clear();

    // Crear una lista de todas las combinaciones de salas y horarios posibles
    List<RoomSlot> roomSlots = [];
    for (Room room in rooms) {
      for (int slot = 0; slot < numSlots; slot++) {
        roomSlots.add(RoomSlot(room: room, slot: slot));
      }
    }

    // Aplicar la matriz de asignación al horario con rotación de películas
    int currentRotation = 0;

    for (int slot = 0; slot < numSlots; slot++) {
      for (int roomIndex = 0; roomIndex < numRooms; roomIndex++) {
        int assignmentIndex = (slot * numRooms + roomIndex + currentRotation) % numMovies;
        RoomSlot roomSlot = roomSlots[slot * numRooms + roomIndex];
        Movie movie = movies[assignmentIndex];
        
        _schedule[roomSlot.room.id] ??= [];
        DateTime startTime = _getStartTime(roomSlot.slot);
        DateTime endTime = startTime.add(Duration(minutes: movie.durationInMinutes));

        _schedule[roomSlot.room.id]!.add(
          FunctionCine(
            id: '', // Se generará un nuevo ID al guardar
            movieId: movie.id,
            startTime: startTime,
            endTime: endTime,
            roomId: roomSlot.room.id,
            price: roomSlot.room.name=='normal'? 30.0 : 50.0, // Precio fijo según tu especificación
            type: roomSlot.room.type,
            createdBy: 'Admin',
          ),
        );
      }
      currentRotation = (currentRotation + 1) % numMovies;
    }

    setState(() {});
  }

  DateTime _getStartTime(int slot) {
    final startTime = TimeOfDay(hour: 10, minute: 0);
    DateTime currentTime = DateTime(2024, 5, 26, startTime.hour, startTime.minute);
    currentTime = currentTime.add(Duration(hours: slot * 2));
    return currentTime;
  }

  void _mostrarCalculos() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CalculosPage(
          costsMatrix: costsMatrix,
          assignmentMatrix: assignmentMatrix,
        ),
      ),
    );
  }

  Widget _buildMoviesList(AsyncValue<List<Movie>> movieListAsyncValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Películas en Cartelera',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Expanded(
          child: movieListAsyncValue.when(
            data: (movies) {
              final nowPlayingMovies = movies
                  .where((movie) => movie.status == "en cartelera")
                  .toList();
              return ListView.builder(
                itemCount: nowPlayingMovies.length,
                itemBuilder: (context, index) {
                  final movie = nowPlayingMovies[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedMovieId = movie.id;
                      });
                    },
                    child: Draggable<Movie>(
                      data: movie,
                      feedback: Material(
                        child: _buildMovieImage(movie.poster_path),
                      ),
                      childWhenDragging: Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Opacity(
                          opacity: 0.5,
                          child: _buildMovieImage(movie.poster_path),
                        ),
                      ),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: _buildMovieImage(movie.poster_path),
                      ),
                    ),
                  );
                },
              );
            },
            loading: () => Center(child: CircularProgressIndicator()),
            error: (error, stackTrace) => Center(child: Text('Error: $error')),
          ),
        ),
      ],
    );
  }

  Widget _buildMovieImage(String? posterPath) {
    return Container(
      width: 120,
      height: 180,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
      ),
      child: posterPath != null && posterPath.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: Image.network(
                posterPath,
                fit: BoxFit.cover,
                width: 120,
                height: 180,
              ),
            )
          : Container(
              color: Colors.grey,
              width: 120,
              height: 180,
            ),
    );
  }

  Widget _buildRoomHeaders(AsyncValue<List<Room>> roomListAsyncValue) {
    return roomListAsyncValue.when(
      data: (rooms) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: rooms.map((room) {
            return Container(
              width: 120,
              child: Column(
                children: [
                  Text(room.name,
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Asientos: ${room.totalSeats}',
                      style: TextStyle(color: Colors.grey)),
                  Text('Tipo: ${room.type}',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            );
          }).toList(),
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildScheduleMatrix(AsyncValue<List<Room>> roomListAsyncValue) {
    return roomListAsyncValue.when(
      data: (rooms) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: _buildTimeSlots(rooms),
          ),
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) => Center(child: Text('Error: $error')),
    );
  }

  List<Widget> _buildTimeSlots(List<Room> rooms) {
    final startTime = TimeOfDay(hour: 10, minute: 0);
    List<DateTime> timeSlots = [];

    DateTime currentTime =
        DateTime(2024, 5, 26, startTime.hour, startTime.minute);

    while (currentTime.hour < 22) {
      timeSlots.add(currentTime);
      currentTime = currentTime.add(Duration(hours: 2));
    }

    return timeSlots.map((time) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: rooms.map((room) {
          return Flexible(
            child: Container(
              width: 120,
              height: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4.0),
                child: DragTarget<Object>(
                  onWillAccept: (data) => data is Movie || data is FunctionCine,
                  onAccept: (data) {
                    setState(() {
                      if (data is Movie) {
                        _schedule[room.id] ??= [];
                        final startTime =
                            DateTime(2024, 5, 26, time.hour, time.minute);
                        final endTime = startTime
                            .add(Duration(minutes: data.durationInMinutes));
                        _schedule[room.id]!.add(
                          FunctionCine(
                            id: '',
                            movieId: data.id,
                            startTime: startTime,
                            endTime: endTime,
                            roomId: room.id,
                            price: 10.0,
                            type: 'Regular',
                            createdBy: 'Admin',
                          ),
                        );
                      } else if (data is FunctionCine) {
                        _schedule[data.roomId]?.remove(data);
                        _schedule[room.id] ??= [];
                        final startTime =
                            DateTime(2024, 5, 26, time.hour, time.minute);
                        final endTime = startTime.add(Duration(
                            minutes: _getMovieById(data.movieId)!
                                .durationInMinutes));
                        _schedule[room.id]!.add(
                          data.copyWith(
                            roomId: room.id,
                            startTime: startTime,
                            endTime: endTime,
                          ),
                        );
                      }
                    });
                  },
                  builder: (context, candidateData, rejectedData) {
                    final function = _schedule[room.id]?.firstWhereOrNull(
                      (func) =>
                          func.startTime.hour == time.hour &&
                          func.startTime.minute == time.minute,
                    );

                    return LongPressDraggable<FunctionCine>(
                      data: function,
                      feedback: function != null
                          ? Material(
                              child: _buildMovieImage(
                                  _getMovieById(function.movieId)?.poster_path),
                            )
                          : Container(),
                      childWhenDragging: Container(
                        margin: EdgeInsets.all(4),
                        width: 120,
                        height: 180,
                        color: Colors.transparent,
                      ),
                      onDragEnd: (details) {
                        if (!details.wasAccepted) {
                          setState(() {
                            _schedule[room.id]?.remove(function);
                          });
                        }
                      },
                      child: Container(
                        width: 120,
                        height: 180,
                        margin: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: function != null
                              ? Colors.blue[200]
                              : Theme.of(context).scaffoldBackgroundColor,
                          border: Border.all(
                            color: Colors.grey.shade700,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                                '${time.hour}:${time.minute.toString().padLeft(2, '0')}'),
                            if (function != null)
                              Expanded(
                                  child: _buildMovieImage(
                                      _getMovieById(function.movieId)
                                          ?.poster_path)),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        }).toList(),
      );
    }).toList();
  }

  Movie? _getMovieById(String id) {
    final movies = ref.read(allMoviesProviderFuture).valueOrNull;
    if (movies == null) {
      return null;
    }
    return movies.firstWhereOrNull((movie) => movie.id == id);
  }

  void _clearSchedule() {
    setState(() {
      _schedule.clear();
    });
  }

  void _saveSchedule() async {
    try {
      // Guarda cada FunctionCine en Firestore y obtiene sus IDs
      List<String> functionIds = [];
      for (var entry in _schedule.entries) {
        for (var function in entry.value) {
          // Genera un ID único para cada función si no lo tiene
          String functionId = function.id.isEmpty
              ? FirebaseFirestore.instance.collection('functions').doc().id
              : function.id;
          function = function.copyWith(id: functionId);

          // Convierte las fechas a Timestamp
          Map<String, dynamic> functionData = function.toJson();
          functionData['startTime'] = Timestamp.fromDate(function.startTime);
          functionData['endTime'] = Timestamp.fromDate(function.endTime);

          // Guarda la función en Firestore
          await FirebaseFirestore.instance
              .collection('functions')
              .doc(functionId)
              .set(functionData);
          functionIds.add(functionId);
        }
      }

      // Crea el objeto BillBoard con los IDs de las funciones
      final billboard = BillBoard(
        id: '',
        functionIds: functionIds,
        isActive: true,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: 7)),
        createdBy: 'Admin',
      );

      // Convierte las fechas a Timestamp
      Map<String, dynamic> billboardData = billboard.toJson();
      billboardData['startDate'] = Timestamp.fromDate(billboard.startDate);
      billboardData['endDate'] = Timestamp.fromDate(billboard.endDate);

      // Guarda el BillBoard en Firestore
      await FirebaseFirestore.instance
          .collection('billboards')
          .add(billboardData);

      // Muestra la confirmación y limpia el horario
      _showConfirmation();
      _clearSchedule();
    } catch (error) {
      _showError(error.toString());
    }
  }

  void _showConfirmation() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('¡Cartelera guardada exitosamente!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $error'),
        backgroundColor: Colors.red,
      ),
    );
  }
}
