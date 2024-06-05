import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:is_dpelicula/controllers/ticket_controller.dart';
import 'package:is_dpelicula/models/functionCine.dart';
import 'package:is_dpelicula/models/movie.dart';
import 'package:is_dpelicula/models/ticket.dart';

class TicketPurchasePage extends ConsumerStatefulWidget {
  final FunctionCine function;
  final Movie movie;

  TicketPurchasePage({required this.function, required this.movie});

  @override
  _TicketPurchasePageState createState() => _TicketPurchasePageState();
}

class _TicketPurchasePageState extends ConsumerState<TicketPurchasePage> {
  final _formKey = GlobalKey<FormState>();
  String? _row;
  String? _seat;
  final int rows = 10; // Número de filas
  final int columns = 10; // Número de columnas
  late List<List<bool>> seatStatus;
  late List<List<bool>> selectedSeat;

  @override
  void initState() {
    super.initState();
    seatStatus = List.generate(rows, (_) => List.generate(columns, (_) => false));
    selectedSeat = List.generate(rows, (_) => List.generate(columns, (_) => false));
    _fetchSoldTickets();
  }

  Future<void> _fetchSoldTickets() async {
    final soldTickets = await ref.read(ticketControllerProvider.notifier).getSoldTicketsByFunctionId(widget.function.id);
    setState(() {
      for (var ticket in soldTickets) {
        int row = int.parse(ticket.row) - 1;
        int seat = int.parse(ticket.seat) - 1;
        seatStatus[row][seat] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comprar Ticket - ${widget.movie.title}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildRoomPreview(),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Fila'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese la fila';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _row = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Asiento'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese el asiento';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _seat = value;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final newTicket = Ticket(
                        id: '',
                        userId: 'someUserId', // Replace with actual user ID
                        row: _row!,
                        seat: _seat!,
                        functionDateTime: Timestamp.fromDate(widget.function.startTime),
                        functionId: widget.function.id,
                        price: widget.function.price,
                      );
                      ref.read(ticketControllerProvider.notifier).addTicket(newTicket);
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Confirmar Compra'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoomPreview() {
    return Column(
      children: [
        const Text('Previsualización de la Sala', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              Row(
                children: List.generate(columns + 1, (index) {
                  if (index == 0) return const SizedBox(width: 20);
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      '$index',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }),
              ),
              Column(
                children: List.generate(rows, (rowIndex) {
                  return Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          '${rowIndex + 1}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      ...List.generate(columns, (colIndex) {
                        return GestureDetector(
                          onTap: () {
                            if (!seatStatus[rowIndex][colIndex]) {
                              setState(() {
                                selectedSeat = List.generate(rows, (_) => List.generate(columns, (_) => false));
                                selectedSeat[rowIndex][colIndex] = true;
                                _row = (rowIndex + 1).toString();
                                _seat = (colIndex + 1).toString();
                              });
                            }
                          },
                          child: Container(
                            margin: EdgeInsets.all(4),
                            child: Icon(
                              Icons.event_seat,
                              color: seatStatus[rowIndex][colIndex]
                                  ? Colors.red
                                  : (selectedSeat[rowIndex][colIndex] ? Colors.green : Colors.grey),
                            ),
                          ),
                        );
                      }),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

final ticketControllerProvider = StateNotifierProvider<TicketController, List<Ticket>>((ref) {
  return TicketController(ref);
});

class TicketController extends StateNotifier<List<Ticket>> {
  TicketController(this.ref) : super([]);

  final Ref ref;

  Future<List<Ticket>> getSoldTicketsByFunctionId(String functionId) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('tickets')
        .where('functionId', isEqualTo: functionId)
        .get();
    return querySnapshot.docs.map((doc) => Ticket.fromMap(doc.data(), ticketId: doc.id)).toList();
  }

  Future<void> addTicket(Ticket ticket) async {
    await FirebaseFirestore.instance.collection('tickets').add(ticket.toJson());
  }
}
