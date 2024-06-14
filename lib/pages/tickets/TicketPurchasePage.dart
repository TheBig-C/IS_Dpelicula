import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:is_dpelicula/controllers/ticket_controller.dart';
import 'package:is_dpelicula/models/functionCine.dart';
import 'package:is_dpelicula/models/movie.dart';
import 'package:is_dpelicula/models/ticket.dart';
import 'package:is_dpelicula/widgets/custom_app_bar.dart';
import 'package:is_dpelicula/widgets/desktop_footer.dart';

class TicketPurchasePage extends ConsumerStatefulWidget {
  final FunctionCine function;
  final Movie movie;

  TicketPurchasePage({required this.function, required this.movie});

  @override
  _TicketPurchasePageState createState() => _TicketPurchasePageState();
}

class _TicketPurchasePageState extends ConsumerState<TicketPurchasePage> {
  final _formKey = GlobalKey<FormState>();
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

  void _toggleSeatSelection(int rowIndex, int colIndex) {
    setState(() {
      selectedSeat[rowIndex][colIndex] = !selectedSeat[rowIndex][colIndex];
    });
  }

  void _confirmSelection() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            bool isLoading = false;

            void _purchaseTickets() async {
              setState(() {
                isLoading = true;
              });

              var user = FirebaseAuth.instance.currentUser;
              final selectedTickets = <Ticket>[];
              for (int i = 0; i < rows; i++) {
                for (int j = 0; j < columns; j++) {
                  if (selectedSeat[i][j]) {
                    final newTicket = Ticket(
                      id: '',
                      userId: user!.uid,
                      row: (i + 1).toString(),
                      seat: (j + 1).toString(),
                      functionDateTime: Timestamp.fromDate(widget.function.startTime),
                      functionId: widget.function.id,
                      price: widget.function.price,
                    );
                    selectedTickets.add(newTicket);
                  }
                }
              }
              if (selectedTickets.isNotEmpty) {
                await ref.read(ticketControllerProvider.notifier).addTickets(selectedTickets);
                setState(() {
                  isLoading = false;
                });
                Navigator.pop(context);
                Navigator.pop(context);
              } else {
                setState(() {
                  isLoading = false;
                });
                Navigator.pop(context);
              }
            }

            return AlertDialog(
              title: Text('Confirmar Compra', style: TextStyle(color: Colors.black)),
              content: isLoading
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(),
                        SizedBox(height: 20),
                        Text('Procesando tu compra...', style: TextStyle(color: Colors.black)),
                      ],
                    )
                  : Text('¿Estás seguro de que deseas realizar la compra de los tickets seleccionados?', style: TextStyle(color: Colors.black)),
              actions: <Widget>[
                TextButton(
                  child: Text('Cancelar', style: TextStyle(color: Colors.black)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: Text('Confirmar', style: TextStyle(color: Colors.black)),
                  onPressed: _purchaseTickets,
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: CustomAppBar(isDesktop: isDesktop),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildRoomPreview(),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _confirmSelection,
                  child: Text('Confirmar Compra'),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.amber, // Color del texto
                    textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                ),
                const SizedBox(height: 30),
                if (isDesktop) const DesktopFooter(),
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
                  if (index == 0) return const SizedBox(width: 24);
                  return SizedBox(
                    width: 43, // Ajusta este tamaño según sea necesario
                    child: Center(
                      child: Text(
                        '$index',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }),
              ),
              Column(
                children: List.generate(rows, (rowIndex) {
                  return Row(
                    children: [
                      SizedBox(
                        width: 45, // Ajusta este tamaño según sea necesario
                        child: Center(
                          child: Text(
                            '${rowIndex + 1}',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      ...List.generate(columns, (colIndex) {
                        return GestureDetector(
                          onTap: () {
                            if (!seatStatus[rowIndex][colIndex]) {
                              _toggleSeatSelection(rowIndex, colIndex);
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

  Future<void> addTickets(List<Ticket> tickets) async {
    final batch = FirebaseFirestore.instance.batch();
    for (final ticket in tickets) {
      final docRef = FirebaseFirestore.instance.collection('tickets').doc();
      batch.set(docRef, ticket.toJson());
    }
    await batch.commit();
  }
}
