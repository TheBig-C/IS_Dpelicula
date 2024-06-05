import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:is_dpelicula/controllers/room_controllers.dart';
import 'package:is_dpelicula/models/room.dart';

class RegisteredRoomsPage extends ConsumerStatefulWidget {
  @override
  _RegisteredRoomsPageState createState() => _RegisteredRoomsPageState();
}

class _RegisteredRoomsPageState extends ConsumerState<RegisteredRoomsPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameFilterController = TextEditingController();
  final TextEditingController typeFilterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final roomListAsyncValue = ref.watch(roomControllerProvider);

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
              'Salas Registradas',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            centerTitle: true,
            backgroundColor: Colors.grey[700],
          ),
        ),
      ),
      body: SafeArea(
        child: MediaQuery.of(context).size.width > 800
            ? Center(
                child: SizedBox(
                    width: 800, child: _buildContent(roomListAsyncValue)),
              )
            : ListView(children: [_buildContent(roomListAsyncValue)]),
      ),
    );
  }

  Widget _buildContent(AsyncValue<List<Room>> roomListAsyncValue) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: nameFilterController,
                  decoration: _inputDecoration('Buscar por nombre'),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: typeFilterController,
                  decoration: _inputDecoration('Buscar por tipo'),
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
              SizedBox(width: 8),
              IconButton(
                icon: Icon(Icons.clear),
                onPressed: () {
                  nameFilterController.clear();
                  typeFilterController.clear();
                  setState(() {});
                },
              ),
            ],
          ),
        ),
        Expanded(child: _buildRoomList(roomListAsyncValue)),
      ],
    );
  }

  InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: Color(0xfff4b33c)),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xfff4b33c)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xfff4b33c)),
      ),
    );
  }

  Widget _buildRoomList(AsyncValue<List<Room>> roomListAsyncValue) {
    return roomListAsyncValue.when(
      data: (rooms) {
        final filteredRooms = rooms.where((room) {
          bool matchesName = nameFilterController.text.isEmpty ||
              room.name
                  .toLowerCase()
                  .contains(nameFilterController.text.toLowerCase());
          bool matchesType = typeFilterController.text.isEmpty ||
              room.type
                  .toLowerCase()
                  .contains(typeFilterController.text.toLowerCase());
          return matchesName && matchesType;
        }).toList();

        return ListView.builder(
          itemCount: filteredRooms.length,
          itemBuilder: (context, index) {
            final room = filteredRooms[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildRoomPreview(room.rows, room.columns),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            room.name,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text('Tipo: ${room.type}',
                              style: TextStyle(color: Colors.black)),
                          Text('Filas: ${room.rows}',
                              style: TextStyle(color: Colors.black)),
                          Text('Columnas: ${room.columns}',
                              style: TextStyle(color: Colors.black)),
                          Text('Total de Asientos: ${room.totalSeats}',
                              style: TextStyle(color: Colors.black)),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _showEditRoomDialog(room.id, room);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _showDeleteConfirmationDialog(room.id, room.name);
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
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Error: $err')),
    );
  }

  Widget _buildRoomPreview(int rows, int columns) {
    return Column(
      children: [
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: List.generate(rows, (rowIndex) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(columns, (colIndex) {
                  return const Icon(Icons.event_seat,
                      color: Colors.grey, size: 20);
                }),
              );
            }),
          ),
        ),
      ],
    );
  }

  void _showEditRoomDialog(String roomId, Room roomData) {
    final nameController = TextEditingController(text: roomData.name);
    final typeController = TextEditingController(text: roomData.type);
    final rowsController =
        TextEditingController(text: roomData.rows.toString());
    final columnsController =
        TextEditingController(text: roomData.columns.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar sala', style: TextStyle(color: Colors.black)),
          content: Container(
            width: 400,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                          labelText: 'Nombre',
                          labelStyle: TextStyle(color: Colors.black)),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese un nombre';
                        }
                        return null;
                      },
                      style: TextStyle(color: Colors.black),
                    ),
                    TextFormField(
                      controller: typeController,
                      decoration: InputDecoration(
                          labelText: 'Tipo',
                          labelStyle: TextStyle(color: Colors.black)),
                      style: TextStyle(color: Colors.black),
                    ),
                    TextFormField(
                      controller: rowsController,
                      decoration: InputDecoration(
                          labelText: 'Filas',
                          labelStyle: TextStyle(color: Colors.black)),
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.number,
                    ),
                    TextFormField(
                      controller: columnsController,
                      decoration: InputDecoration(
                          labelText: 'Columnas',
                          labelStyle: TextStyle(color: Colors.black)),
                      style: TextStyle(color: Colors.black),
                      keyboardType: TextInputType.number,
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
                  _updateRoom(roomId, nameController.text, typeController.text,
                      rowsController.text, columnsController.text);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _updateRoom(String roomId, String name, String type, String rows,
      String columns) async {
    try {
      await FirebaseFirestore.instance.collection('rooms').doc(roomId).update({
        'name': name,
        'type': type,
        'rows': int.parse(rows),
        'columns': int.parse(columns),
        'totalSeats': int.parse(rows) * int.parse(columns),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sala actualizada con éxito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al actualizar la sala: $e')),
      );
    }
  }

  void _showDeleteConfirmationDialog(String roomId, String name) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar eliminación',
              style: TextStyle(color: Colors.black)),
          content: Text('¿Estás seguro de que deseas eliminar esta sala?',
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
                _deleteRoom(roomId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteRoom(String roomId) async {
    try {
      await FirebaseFirestore.instance.collection('rooms').doc(roomId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sala eliminada con éxito')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al eliminar la sala: $e')),
      );
    }
  }
}
