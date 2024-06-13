import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:is_dpelicula/models/movie.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class RegisterMovie extends StatefulWidget {
  const RegisterMovie({Key? key}) : super(key: key);

  @override
  _RegisterMovieState createState() => _RegisterMovieState();
}

class _RegisterMovieState extends State<RegisterMovie> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController overviewController = TextEditingController();
  final TextEditingController voteAverageController = TextEditingController();
  final TextEditingController statusController = TextEditingController();
  final TextEditingController genresController = TextEditingController();
  final TextEditingController directorNamesController = TextEditingController();
  final TextEditingController leadActorsController = TextEditingController();
  final TextEditingController registeredByController = TextEditingController();
  final TextEditingController durationInMinutesController =
      TextEditingController();
  final TextEditingController usBoxOfficeController =
      TextEditingController(text: '0');
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final CollectionReference movies =
      FirebaseFirestore.instance.collection('movies');

  String? _posterUploadConfirmation;
  String? _backdropUploadConfirmation;
  String? _posterFileName;
  String? _backdropFileName;
  Uint8List? _posterFile;
  Uint8List? _backdropFile;
  int _currentStep = 0;

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
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.image, withData: true);
    if (result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        if (type == 'poster') {
          _posterFile = file.bytes;
          _posterFileName = file.name;
        } else {
          _backdropFile = file.bytes;
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
        if (docSnapshot.exists) {
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.success(
              message: "Película registrada exitosamente",
            ),
          );
        } else {
          showTopSnackBar(
            Overlay.of(context),
            const CustomSnackBar.error(
              message: "Error: Documento no encontrado después de registro",
            ),
          );
        }
        _clearFormFields();
      }
    } catch (e) {
      if (mounted) {
        showTopSnackBar(
          Overlay.of(context),
          CustomSnackBar.error(
            message: "Error registrando película: $e",
          ),
        );
      }
    }
  }

  void _clearFormFields() {
    titleController.clear();
    overviewController.clear();
    voteAverageController.clear();
    statusController.clear();
    genresController.clear();
    directorNamesController.clear();
    leadActorsController.clear();
    registeredByController.clear();
    durationInMinutesController.clear();
    usBoxOfficeController.clear();
  }

  bool _isStepValid(int step) {
    switch (step) {
      case 0:
        return titleController.text.isNotEmpty &&
            titleController.text.length <= 50 &&
            overviewController.text.isNotEmpty &&
            overviewController.text.length <= 250;
      case 1:
        final voteAverage = double.tryParse(voteAverageController.text);
        return voteAverageController.text.isNotEmpty &&
            voteAverage != null &&
            voteAverage >= 1 &&
            voteAverage <= 10 &&
            statusController.text.isNotEmpty &&
            genresController.text.isNotEmpty &&
            genresController.text.length <= 30;
      case 2:
        return _posterFile != null && _backdropFile != null;
      case 3:
        return directorNamesController.text.isNotEmpty &&
            directorNamesController.text.length <= 30 &&
            leadActorsController.text.isNotEmpty &&
            leadActorsController.text.length <= 50 &&
            durationInMinutesController.text.isNotEmpty &&
            int.tryParse(durationInMinutesController.text) != null &&
            usBoxOfficeController.text.isNotEmpty &&
            int.tryParse(usBoxOfficeController.text) != null;
      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                'Registrar Película',
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
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Stepper(
              type: StepperType.vertical,
              currentStep: _currentStep,
              onStepTapped: (step) {
                if (_isStepValid(_currentStep)) {
                  setState(() => _currentStep = step);
                } else {
                  showTopSnackBar(
                    Overlay.of(context),
                    CustomSnackBar.error(
                      message:
                          "Por favor, complete todos los campos antes de continuar.",
                    ),
                  );
                }
              },
              onStepContinue: () {
                if (_isStepValid(_currentStep)) {
                  if (_currentStep < 3) {
                    setState(() => _currentStep += 1);
                  } else {
                    _submitForm();
                  }
                } else {
                  showTopSnackBar(
                    Overlay.of(context),
                    CustomSnackBar.error(
                      message:
                          "Por favor, complete todos los campos antes de continuar.",
                    ),
                  );
                }
              },
              onStepCancel: _currentStep > 0
                  ? () => setState(() => _currentStep -= 1)
                  : null,
              steps: <Step>[
                Step(
                  title: Text('Detalles Básicos'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputField(titleController, "Título",
                          maxLength: 50,
                          validators: [
                            (value) => value == null || value.isEmpty
                                ? 'Campo requerido'
                                : null,
                            (value) => value != null && value.length > 50
                                ? 'Máximo 50 caracteres'
                                : null,
                          ]),
                      SizedBox(height: 20),
                      _buildInputField(overviewController, "Descripción",
                          maxLines: 10,
                          maxLength: 250,
                          validators: [
                            (value) => value == null || value.isEmpty
                                ? 'Campo requerido'
                                : null,
                            (value) => value != null && value.length > 250
                                ? 'Máximo 250 caracteres'
                                : null,
                          ]),
                    ],
                  ),
                  isActive: _currentStep >= 0,
                  state:
                      _currentStep > 0 ? StepState.complete : StepState.editing,
                ),
                Step(
                  title: Text('Calificación y Estado'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputField(
                          voteAverageController, "Calificación Promedio",
                          validators: [
                            (value) => value == null || value.isEmpty
                                ? 'Campo requerido'
                                : null,
                            (value) {
                              final number = double.tryParse(value ?? '');
                              if (number == null || number < 1 || number > 10) {
                                return 'Debe ser un número entre 1 y 10';
                              }
                              return null;
                            },
                          ]),
                      SizedBox(height: 20),
                      _buildDropdownField(),
                      SizedBox(height: 20),
                      _buildInputField(genresController, "Géneros",
                          maxLength: 30,
                          validators: [
                            (value) => value == null || value.isEmpty
                                ? 'Campo requerido'
                                : null,
                            (value) => value != null && value.length > 30
                                ? 'Máximo 30 caracteres'
                                : null,
                          ]),
                    ],
                  ),
                  isActive: _currentStep >= 1,
                  state:
                      _currentStep > 1 ? StepState.complete : StepState.editing,
                ),
                Step(
                  title: Text('Subir Imágenes'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ElevatedButton(
                        onPressed: () => _pickImage('poster'),
                        child: Text("Cargar Póster"),
                      ),
                      if (_posterFile != null) _buildImagePreview(_posterFile),
                      if (_posterUploadConfirmation != null)
                        Padding(
                          key: ValueKey(_posterUploadConfirmation),
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(_posterUploadConfirmation!),
                        ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () => _pickImage('backdrop'),
                        child: Text("Cargar Imagen de Fondo"),
                      ),
                      if (_backdropFile != null)
                        _buildImagePreview(_backdropFile),
                      if (_backdropUploadConfirmation != null)
                        Padding(
                          key: ValueKey(_backdropUploadConfirmation),
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          child: Text(_backdropUploadConfirmation!),
                        ),
                    ],
                  ),
                  isActive: _currentStep >= 2,
                  state:
                      _currentStep > 2 ? StepState.complete : StepState.editing,
                ),
                Step(
                  title: Text('Detalles de Producción'),
                  content: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInputField(
                          directorNamesController, "Nombres de los Directores",
                          maxLength: 30,
                          validators: [
                            (value) => value == null || value.isEmpty
                                ? 'Campo requerido'
                                : null,
                            (value) => value != null && value.length > 30
                                ? 'Máximo 30 caracteres'
                                : null,
                          ]),
                      SizedBox(height: 20),
                      _buildInputField(
                          leadActorsController, "Actores Principales",
                          maxLength: 50,
                          validators: [
                            (value) => value == null || value.isEmpty
                                ? 'Campo requerido'
                                : null,
                            (value) => value != null && value.length > 50
                                ? 'Máximo 50 caracteres'
                                : null,
                          ]),
                      SizedBox(height: 20),
                      _buildInputField(
                          durationInMinutesController, "Duración en Minutos",
                          validators: [
                            (value) => value == null || value.isEmpty
                                ? 'Campo requerido'
                                : null,
                            (value) =>
                                value != null && int.tryParse(value) == null
                                    ? 'Debe ser un número'
                                    : null,
                          ]),
                      SizedBox(height: 20),
                      _buildInputField(usBoxOfficeController,
                          "Taquilla Provisional (EE.UU.)",
                          validators: [
                            (value) => value == null || value.isEmpty
                                ? 'Campo requerido'
                                : null,
                            (value) =>
                                value != null && int.tryParse(value) == null
                                    ? 'Debe ser un número'
                                    : null,
                          ]),
                    ],
                  ),
                  isActive: _currentStep >= 3,
                  state: _currentStep == 3
                      ? StepState.editing
                      : StepState.complete,
                ),
              ],
              controlsBuilder: (BuildContext context, ControlsDetails details) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentStep != 0)
                        ElevatedButton(
                          onPressed: details.onStepCancel,
                          child: const Text('Anterior'),
                          style: ElevatedButton.styleFrom(
                            foregroundColor: const Color(0xff222222),
                            backgroundColor: const Color(0xfff4b33c),
                            shape: const StadiumBorder(),
                          ),
                        ),
                      ElevatedButton(
                        onPressed: details.onStepContinue,
                        child: _currentStep == 3
                            ? const Text('Registrar')
                            : const Text('Siguiente'),
                        style: ElevatedButton.styleFrom(
                          foregroundColor: const Color(0xff222222),
                          backgroundColor: const Color(0xfff4b33c),
                          shape: const StadiumBorder(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label,
      {int maxLines = 1,
      int? maxLength,
      List<String? Function(String?)>? validators}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: controller,
        decoration: _inputDecoration(context, label),
        maxLines: maxLines,
        maxLength: maxLength,
        style: TextStyle(
          color: const Color(0xfff4b33c).withOpacity(0.7),
          fontSize: 18,
        ),
        validator: (value) {
          if (validators != null) {
            for (var validator in validators) {
              final result = validator(value);
              if (result != null) {
                return result;
              }
            }
          }
          return null;
        },
        onChanged: (value) {
          if (formKey.currentState != null) {
            formKey.currentState!.validate();
          }
        },
      ),
    );
  }

  Widget _buildDropdownField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: DropdownButtonFormField<String>(
        value: statusController.text.isNotEmpty ? statusController.text : null,
        onChanged: (value) {
          setState(() {
            statusController.text = value!;
          });
          if (formKey.currentState != null) {
            formKey.currentState!.validate();
          }
        },
        items: [
          DropdownMenuItem(
            child: Text('Muy Pronto',
                style: TextStyle(color: const Color(0xfff4b33c))),
            value: 'muy pronto',
          ),
          DropdownMenuItem(
            child: Text('En Cartelera',
                style: TextStyle(color: const Color(0xfff4b33c))),
            value: 'en cartelera',
          ),
          DropdownMenuItem(
            child: Text('Ya no disponible',
                style: TextStyle(color: const Color(0xfff4b33c))),
            value: 'ya no disponible',
          ),
        ],
        dropdownColor: const Color(0xff1C1C27),
        decoration: _inputDecoration(context, "Estado"),
        validator: (value) =>
            value == null || value.isEmpty ? 'Campo requerido' : null,
      ),
    );
  }

  Widget _buildImagePreview(Uint8List? fileBytes) {
    return fileBytes != null
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Image.memory(
              fileBytes,
              height: 200,
            ),
          )
        : Container();
  }

  void _submitForm() async {
    if (formKey.currentState!.validate()) {
      String? posterUrl;
      String? backdropUrl;

      if (_posterFile != null) {
        posterUrl = await _uploadImageToFirebase(_posterFile!, 'poster');
      }

      if (_backdropFile != null) {
        backdropUrl = await _uploadImageToFirebase(_backdropFile!, 'backdrop');
      }

      Movie movie = Movie(
        id: '',
        title: titleController.text.trim(),
        overview: overviewController.text.trim(),
        posterPath: posterUrl ?? '',
        backdropPath: backdropUrl,
        voteAverage: double.tryParse(voteAverageController.text.trim()) ?? 0,
        status: statusController.text.trim(),
        genres: [genresController.text.trim()],
        directorNames: [directorNamesController.text.trim()],
        leadActors: [leadActorsController.text.trim()],
        registeredBy: registeredByController.text.trim(),
        durationInMinutes:
            int.tryParse(durationInMinutesController.text.trim()) ?? 0,
        usBoxOffice: int.tryParse(usBoxOfficeController.text.trim()) ?? 0,
      );

      await addMovie(movie, context);
    }
  }

  InputDecoration _inputDecoration(BuildContext context, String label) {
    return InputDecoration(
      labelText: label,
      floatingLabelStyle: TextStyle(
        color: const Color(0xfff4b33c).withOpacity(0.7),
        fontSize: 22,
      ),
      labelStyle: TextStyle(
        color: const Color(0xfff4b33c).withOpacity(0.7),
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: const Color(0xfff4b33c).withOpacity(0.4)),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: const Color(0xfff4b33c).withOpacity(0.7)),
        borderRadius: BorderRadius.circular(16),
      ),
      border: OutlineInputBorder(
        borderSide: BorderSide(color: const Color(0xfff4b33c).withOpacity(0.7)),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
