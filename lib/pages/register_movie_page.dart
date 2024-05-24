import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:is_dpelicula/models/movie.dart';
import 'package:is_dpelicula/widgets/custom_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:file_picker/file_picker.dart';

class RegisterMovie extends StatefulWidget {
  const RegisterMovie({Key? key}) : super(key: key);

  @override
  _RegisterMovieState createState() => _RegisterMovieState();
}

class _RegisterMovieState extends State<RegisterMovie> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController overviewController = TextEditingController();
  final TextEditingController posterPathController = TextEditingController();
  final TextEditingController backdropPathController = TextEditingController();
  final TextEditingController voteAverageController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController genresController = TextEditingController();
  final TextEditingController directorNamesController = TextEditingController();
  final TextEditingController leadActorsController = TextEditingController();
  final TextEditingController registeredByController = TextEditingController();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference movies =
      FirebaseFirestore.instance.collection('movies');
  String? _posterUploadConfirmation;
  String? _backdropUploadConfirmation;

  String? _posterFileName;
  String? _backdropFileName;

  Uint8List? _posterFile;
  Uint8List? _backdropFile;

  // Función para subir imágenes a Firebase Storage
  Future<String> _uploadImageToFirebase(
      Uint8List fileBytes, String type) async {
    String fileName = '$type-${DateTime.now().millisecondsSinceEpoch}';
    Reference ref =
        FirebaseStorage.instance.ref().child('movies_image/$fileName');
    UploadTask uploadTask = ref.putData(fileBytes);
    TaskSnapshot taskSnapshot = await uploadTask;
    String imageUrl = await taskSnapshot.ref.getDownloadURL();

    setState(() {
      if (type == 'poster') {
        _posterUploadConfirmation = 'Póster subido: $fileName';
      } else {
        _backdropUploadConfirmation = 'Imagen de fondo subida: $fileName';
      }
    });

    return imageUrl;
  }

  Future<void> _pickImage(String type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      withData: true,
    );

    if (result != null) {
      PlatformFile file = result.files.first;

      setState(() {
        if (type == 'poster') {
          _posterFile = file.bytes; // Almacena los bytes directamente
          _posterFileName = file.name;
        } else {
          _backdropFile = file.bytes; // Almacena los bytes directamente
          _backdropFileName = file.name;
        }
      });
    }
  }

Future<void> addMovie(Movie movie, BuildContext context) async {
    try {
      final DocumentReference docRef = await movies.add(movie.toJson());
      final DocumentSnapshot docSnapshot = await docRef.get();

      if (mounted) {
        // Verifica que el widget sigue montado.
        if (docSnapshot.exists) {
          showTopSnackBar(
            Overlay.of(
                context), // Utiliza 'context' directamente.
            const CustomSnackBar.success(
              message: "Película registrada exitosamente",
            ),
          );
        } else {
          showTopSnackBar(
            Overlay.of(context ),
            const CustomSnackBar.error(
              message: "Error: Documento no encontrado después de registro",
            ),
          );
        }

        // Limpiar campos y navegar de regreso solo si el widget sigue montado.
        titleController.clear();
        overviewController.clear();
        posterPathController.clear();
        backdropPathController.clear();
        voteAverageController.clear();
        statusController.clear();
        genresController.clear();
        directorNamesController.clear();
        leadActorsController.clear();
        registeredByController.clear();

        //   Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        showTopSnackBar(
          Overlay.of(context ),
          CustomSnackBar.error(
            message: "Error registrando película: $e",
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
    double fieldWidth = isDesktop ? 400 : double.infinity;

    return Scaffold(
      appBar: CustomAppBar(isDesktop: isDesktop),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: isDesktop ? 500 : double.infinity,
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: fieldWidth,
                      child: TextFormField(
                        controller: titleController,
                        decoration: _inputDecoration(context, "Título"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: fieldWidth,
                      child: TextFormField(
                        controller: overviewController,
                        decoration: _inputDecoration(context, "Descripción"),
                        maxLines: null,
                        keyboardType: TextInputType.multiline,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: fieldWidth,
                      child: ElevatedButton(
                        onPressed: () => _pickImage('poster'),
                        child: Text("Cargar Póster"),
                      ),
                    ),
                    if (_posterUploadConfirmation != null)
                      Padding(
                        key: ValueKey(
                            _posterUploadConfirmation), // Forzar reconstrucción
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(_posterUploadConfirmation!),
                      ),

                    Container(
                      width: fieldWidth,
                      child: ElevatedButton(
                        onPressed: () => _pickImage('backdrop'),
                        child: Text("Cargar Imagen de Fondo"),
                      ),
                    ),
                    if (_backdropUploadConfirmation != null)
                      Padding(
                        key: ValueKey(
                            _backdropUploadConfirmation), // Forzar reconstrucción
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Text(_backdropUploadConfirmation!),
                      ),

                    const SizedBox(height: 20),
                    Container(
                      width: fieldWidth,
                      child: TextFormField(
                        controller: voteAverageController,
                        decoration:
                            _inputDecoration(context, "Calificación Promedio"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: fieldWidth,
                      child: DropdownButtonFormField<String>(
                        value: statusController.text.isNotEmpty
                            ? statusController.text
                            : null,
                        onChanged: (value) {
                          setState(() {
                            statusController.text = value!;
                          });
                        },
                        items: [
                          DropdownMenuItem(
                            child: Text('Muy Pronto',
                                style: TextStyle(color: Colors.black)),
                            value: 'muy pronto',
                          ),
                          DropdownMenuItem(
                            child: Text('En Cartelera',
                                style: TextStyle(color: Colors.black)),
                            value: 'en cartelera',
                          ),
                          DropdownMenuItem(
                            child: Text('Acabado',
                                style: TextStyle(color: Colors.black)),
                            value: 'acabado',
                          ),
                        ],
                        decoration: _inputDecoration(context, "Estado"),
                        style: TextStyle(color: Colors.black),
                        dropdownColor: Colors.white,
                        icon: Icon(Icons.arrow_drop_down),
                        iconEnabledColor: Colors.black,
                        elevation: 2,
                        isExpanded: true,
                        hint: Text('Seleccione un estado'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Agrega los nuevos campos
                    Container(
                      width: fieldWidth,
                      child: TextFormField(
                        controller: genresController,
                        decoration: _inputDecoration(context, "Géneros"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: fieldWidth,
                      child: TextFormField(
                        controller: directorNamesController,
                        decoration: _inputDecoration(
                            context, "Nombres de los Directores"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: fieldWidth,
                      child: TextFormField(
                        controller: leadActorsController,
                        decoration:
                            _inputDecoration(context, "Actores Principales"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // No necesitamos un campo de texto para 'registeredBy' ya que se llenará automáticamente
                    // pero puedes mostrar el nombre de usuario registrado si lo deseas
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          if (_posterFile == null || _backdropFile == null) {
                            showTopSnackBar(
                              Overlay.of(context ),
                              const CustomSnackBar.error(
                                message:
                                    "Por favor, seleccione ambos archivos de imagen antes de registrar.",
                              ),
                            );
                            return;
                          }
                          try {
                            String posterUrl = await _uploadImageToFirebase(
                                _posterFile!, 'poster');
                            String backdropUrl = await _uploadImageToFirebase(
                                _backdropFile!, 'backdrop');

                            Movie movie = Movie(
                              title: titleController.text.trim(),
                              overview: overviewController.text.trim(),
                              posterPath: posterUrl,
                              backdropPath: backdropUrl,
                              voteAverage: double.tryParse(
                                      voteAverageController.text.trim()) ??
                                  0,
                              status: statusController.text.trim(),
                              genres: [genresController.text.trim()],
                              directorNames: [
                                directorNamesController.text.trim()
                              ],
                              leadActors: [leadActorsController.text.trim()],
                              registeredBy: registeredByController.text.trim(),
                              id: '',
                            );

      await addMovie(movie, context);  // Pasar 'context' aquí
                          } catch (e) {
                            showTopSnackBar(
                              Overlay.of(context ),
                              CustomSnackBar.error(
                                message: "Error registrando película: $e",
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 160, vertical: 14),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text("Registrar",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(BuildContext context, String label) {
    return InputDecoration(
      labelText: label,
      floatingLabelStyle: const TextStyle(color: Colors.white54, fontSize: 22),
      labelStyle: const TextStyle(
          color: Colors.white38, fontSize: 16, fontWeight: FontWeight.w500),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white24),
          borderRadius: BorderRadius.circular(16)),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor),
          borderRadius: BorderRadius.circular(16)),
      border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white70),
          borderRadius: BorderRadius.circular(16)),
    );
  }
}
