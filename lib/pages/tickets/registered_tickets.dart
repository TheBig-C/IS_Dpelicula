import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:is_dpelicula/controllers/movie_controllers.dart';
import 'package:is_dpelicula/controllers/ticket_controller.dart';
import 'package:is_dpelicula/models/ticket.dart';

class RegisteredTicketsPage extends ConsumerStatefulWidget {
  @override
  _RegisteredTicketsPageState createState() => _RegisteredTicketsPageState();
}

class _RegisteredTicketsPageState extends ConsumerState<RegisteredTicketsPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController userIdFilterController = TextEditingController();
  final TextEditingController rowFilterController = TextEditingController();
  final TextEditingController seatFilterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final ticketListAsyncValue = ref.watch(getAllTicketsProvider);

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
                'Tickets Registrados',
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
                    width: 800, child: _buildContent(ticketListAsyncValue)),
              )
            : ListView(children: [_buildContent(ticketListAsyncValue)]),
      ),
    );
  }

  Widget _buildContent(AsyncValue<List<Ticket>> ticketListAsyncValue) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: rowFilterController,
                  decoration: _inputDecoration('Buscar por Fila'),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: seatFilterController,
                  decoration: _inputDecoration('Buscar por Asiento'),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  userIdFilterController.clear();
                  rowFilterController.clear();
                  seatFilterController.clear();
                  setState(() {});
                },
              ),
            ],
          ),
        ),
        Expanded(child: _buildTicketList(ticketListAsyncValue)),
      ],
    );
  }

  InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      border: OutlineInputBorder(),
      floatingLabelStyle: TextStyle(color: Color(0xfff4b33c), fontSize: 22),
      labelStyle: TextStyle(
        color: Color(0xfff4b33c).withOpacity(0.7),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xfff4b33c).withOpacity(0.7)),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xfff4b33c)),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  Widget _buildTicketList(AsyncValue<List<Ticket>> ticketListAsyncValue) {
    return ticketListAsyncValue.when(
      data: (tickets) {
        final filteredTickets = tickets.where((ticket) {
          bool matchesUserId = userIdFilterController.text.isEmpty ||
              ticket.userId
                  .toLowerCase()
                  .contains(userIdFilterController.text.toLowerCase());
          bool matchesRow = rowFilterController.text.isEmpty ||
              ticket.row
                  .toLowerCase()
                  .contains(rowFilterController.text.toLowerCase());
          bool matchesSeat = seatFilterController.text.isEmpty ||
              ticket.seat
                  .toLowerCase()
                  .contains(seatFilterController.text.toLowerCase());
          return matchesUserId && matchesRow && matchesSeat;
        }).toList();

        return ListView.builder(
          itemCount: filteredTickets.length,
          itemBuilder: (context, index) {
            final ticket = filteredTickets[index];
            final movieTitleAsyncValue = ref.watch(movieTitleProvider(ticket.functionId));

            return FutureBuilder<String>(
              future: _getUserName(ticket.userId),
              builder: (context, snapshot) {
                final userName = snapshot.data ?? 'Cargando...';

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
                        Text('Usuario: $userName',
                            style: TextStyle(color: Colors.black)),
                        Text('Fila: ${ticket.row}',
                            style: TextStyle(color: Colors.black)),
                        Text('Asiento: ${ticket.seat}',
                            style: TextStyle(color: Colors.black)),
                        Text(
                            'Fecha y hora de la función: ${DateFormat('yyyy-MM-dd HH:mm').format(ticket.functionDateTime.toDate())}',
                            style: TextStyle(color: Colors.black)),
                        Text('Precio: \$${ticket.price}',
                            style: TextStyle(color: Colors.black)),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                _showEditTicketDialog(ticket.id, ticket);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                _showDeleteConfirmationDialog(
                                    ticket.id, ticket.userId);
                              },
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
        );
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Future<String> _getUserName(String userId) async {
    try {
      var docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      if (docSnapshot.exists) {
        return docSnapshot.data()?['name'] ?? 'Sin nombre';
      } else {
        return 'Usuario no encontrado';
      }
    } catch (e) {
      return 'Error: $e';
    }
  }

  void _showEditTicketDialog(String ticketId, Ticket ticketData) {
    final rowController = TextEditingController(text: ticketData.row);
    final seatController = TextEditingController(text: ticketData.seat);
    final priceController =
        TextEditingController(text: ticketData.price.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar ticket', style: TextStyle(color: Colors.black)),
          content: Container(
            width: 400, // Define un ancho fijo para la ventana de edición
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: rowController,
                      decoration: InputDecoration(
                          labelText: 'Fila',
                          labelStyle: TextStyle(color: Colors.black)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese una fila';
                        }
                        return null;
                      },
                      style: TextStyle(color: Colors.black),
                    ),
                    TextFormField(
                      controller: seatController,
                      decoration: InputDecoration(
                          labelText: 'Asiento',
                          labelStyle: TextStyle(color: Colors.black)),
                      style: TextStyle(color: Colors.black),
                    ),
                    TextFormField(
                      controller: priceController,
                      decoration: InputDecoration(
                          labelText: 'Precio',
                          labelStyle: TextStyle(color: Colors.black)),
                      style: TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancelar', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Guardar', style: TextStyle(color: Colors.black)),
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  _updateTicket(ticketId, rowController.text,
                      seatController.text, double.parse(priceController.text));
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateTicket(
      String ticketId, String row, String seat, double price) async {
    try {
      await FirebaseFirestore.instance
          .collection('tickets')
          .doc(ticketId)
          .update({
        'row': row,
        'seat': seat,
        'price': price,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ticket actualizado con éxito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar el ticket: $e')),
      );
    }
  }

  void _showDeleteConfirmationDialog(String ticketId, String userId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación',
              style: TextStyle(color: Colors.black)),
          content: Text('¿Estás seguro de que deseas eliminar este ticket?',
              style: TextStyle(color: Colors.black)),
          actions: [
            TextButton(
              child: Text('Cancelar', style: TextStyle(color: Colors.black)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar', style: TextStyle(color: Colors.black)),
              onPressed: () {
                _deleteTicket(ticketId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTicket(String ticketId) async {
    try {
      await FirebaseFirestore.instance
          .collection('tickets')
          .doc(ticketId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ticket eliminado con éxito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar el ticket: $e')),
      );
    }
  }
}
