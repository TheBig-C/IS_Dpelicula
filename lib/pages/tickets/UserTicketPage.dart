import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:is_dpelicula/controllers/movie_controllers.dart';
import 'package:is_dpelicula/controllers/ticket_controller.dart';
import 'package:is_dpelicula/models/ticket.dart';

class UserTicketsPage extends ConsumerStatefulWidget {
   var user = FirebaseAuth.instance.currentUser;


  @override
  _UserTicketsPageState createState() => _UserTicketsPageState();
}

class _UserTicketsPageState extends ConsumerState<UserTicketsPage> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final userTicketListAsyncValue = ref.watch(userTicketsProvider(widget.user!.uid));

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
            bottomRight: Radius.circular(50.0),
          ),
          child: AppBar(
            backgroundColor: const Color(0xff1C1C27), // Azul oscuro
            centerTitle: true,
            title: Container(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Mis Tickets',
                style: TextStyle(
                  color: const Color(0xfff4b33c), // Naranja
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: MediaQuery.of(context).size.width > 800
            ? Center(
                child: SizedBox(
                    width: 800, child: _buildContent(userTicketListAsyncValue)),
              )
            : ListView(children: [_buildContent(userTicketListAsyncValue)]),
      ),
    );
  }

  Widget _buildContent(AsyncValue<List<Ticket>> ticketListAsyncValue) {
    return Column(
      children: [
        Expanded(child: _buildTicketList(ticketListAsyncValue)),
      ],
    );
  }

  Widget _buildTicketList(AsyncValue<List<Ticket>> ticketListAsyncValue) {
    return ticketListAsyncValue.when(
      data: (tickets) {
        return ListView.builder(
          itemCount: tickets.length,
          itemBuilder: (context, index) {
            final ticket = tickets[index];
            final movieTitleAsyncValue = ref.watch(movieTitleProvider(ticket.functionId));

            return Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    movieTitleAsyncValue.when(
                      data: (title) => Text('Película: $title',
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                      loading: () => CircularProgressIndicator(),
                      error: (err, stack) => Text('Error: $err'),
                    ),
                    SizedBox(height: 8),
                    Text('Fila: ${ticket.row}',
                        style: TextStyle(color: Colors.black)),
                    Text('Asiento: ${ticket.seat}',
                        style: TextStyle(color: Colors.black)),
                    Text(
                        'Fecha y hora de la función: ${DateFormat('yyyy-MM-dd HH:mm').format(ticket.functionDateTime.toDate())}',
                        style: TextStyle(color: Colors.black)),
                    Text('Precio: \$${ticket.price}',
                        style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            );
          },
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }
}

// Provider para obtener los tickets de un usuario específico
final userTicketsProvider = FutureProvider.family<List<Ticket>, String>((ref, userId) async {
  final querySnapshot = await FirebaseFirestore.instance
      .collection('tickets')
      .where('userId', isEqualTo: userId)
      .get();

  return querySnapshot.docs
      .map((doc) => Ticket.fromMap(doc.data(), ticketId: doc.id))
      .toList();
});
