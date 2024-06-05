import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:is_dpelicula/controllers/room_controllers.dart';
import 'package:is_dpelicula/models/room.dart';
import 'package:uuid/uuid.dart';

class RoomCreationPage extends ConsumerStatefulWidget {
  const RoomCreationPage({Key? key}) : super(key: key);

  @override
  _RoomCreationPageState createState() => _RoomCreationPageState();
}

class _RoomCreationPageState extends ConsumerState<RoomCreationPage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController typeController = TextEditingController();
  final TextEditingController rowsController = TextEditingController();
  final TextEditingController columnsController = TextEditingController();

  int rows = 0;
  int columns = 0;

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50.0),
            bottomRight: Radius.circular(50.0),
          ),
          child: AppBar(
            title: const Text(
              'Crear Sala de Cine',
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
        child: Center(
          child: SizedBox(
            width: isDesktop ? 800 : double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: ListView(
                  children: [
                    _buildInputField(nameController, 'Nombre de la Sala'),
                    const SizedBox(height: 16),
                    _buildInputField(typeController, 'Tipo de Sala'),
                    const SizedBox(height: 16),
                    _buildInputField(
                      rowsController,
                      'Número de Filas',
                      isNumber: true,
                      onChanged: (value) {
                        setState(() {
                          rows = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildInputField(
                      columnsController,
                      'Número de Columnas',
                      isNumber: true,
                      onChanged: (value) {
                        setState(() {
                          columns = int.tryParse(value) ?? 0;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => _createRoom(context),
                      child: const Text('Crear Sala'),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: const Color(0xff222222),
                        backgroundColor: const Color(0xfff4b33c),
                        shape: const StadiumBorder(),
                      ),
                    ),
                    const SizedBox(height: 32),
                    if (rows > 0 && columns > 0) _buildRoomPreview(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label,
      {bool isNumber = false, ValueChanged<String>? onChanged}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        floatingLabelStyle: TextStyle(
            color: const Color(0xfff4b33c).withOpacity(0.7), fontSize: 22),
        labelStyle: TextStyle(
            color: const Color(0xfff4b33c).withOpacity(0.7),
            fontSize: 16,
            fontWeight: FontWeight.w500),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: const Color(0xfff4b33c).withOpacity(0.4)),
            borderRadius: BorderRadius.circular(16)),
        focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: const Color(0xfff4b33c).withOpacity(0.7)),
            borderRadius: BorderRadius.circular(16)),
        border: OutlineInputBorder(
            borderSide:
                BorderSide(color: const Color(0xfff4b33c).withOpacity(0.7)),
            borderRadius: BorderRadius.circular(16)),
      ),
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : [],
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Por favor ingrese $label';
        }
        return null;
      },
      onChanged: onChanged,
      style: TextStyle(
        color: const Color(0xfff4b33c).withOpacity(0.7),
        fontSize: 18,
      ),
    );
  }

  void _createRoom(BuildContext context) {
    if (formKey.currentState!.validate()) {
      final newRoom = Room(
        id: Uuid().v4(),
        name: nameController.text.trim(),
        type: typeController.text.trim(),
        rows: rows,
        columns: columns,
        totalSeats: rows * columns,
      );

      ref.read(roomControllerProvider.notifier).addRoom(newRoom);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sala creada exitosamente')),
      );

      nameController.clear();
      typeController.clear();
      rowsController.clear();
      columnsController.clear();

      setState(() {
        rows = 0;
        columns = 0;
      });
    }
  }

  Widget _buildRoomPreview() {
    return Column(
      children: [
        const Text('Previsualización de la Sala',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
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
                  return const Icon(Icons.event_seat, color: Colors.grey);
                }),
              );
            }),
          ),
        ),
      ],
    );
  }
}
