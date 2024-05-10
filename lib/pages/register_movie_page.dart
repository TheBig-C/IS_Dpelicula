import 'package:flutter/material.dart';
import 'package:is_dpelicula/models/movie.dart';
import 'package:is_dpelicula/widgets/custom_app_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class RegisterMovie extends StatefulWidget {
  const RegisterMovie({Key? key}) : super(key: key);

  @override
  _RegisterMovieState createState() => _RegisterMovieState();
}

class _RegisterMovieState extends State<RegisterMovie> {
  final formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController overviewController = TextEditingController();
  TextEditingController posterPathController = TextEditingController();
  TextEditingController backdropPathController = TextEditingController();
  TextEditingController voteAverageController = TextEditingController();
  TextEditingController statusController = TextEditingController();

  // Agrega estos controladores
  TextEditingController genresController = TextEditingController();
  TextEditingController directorNamesController = TextEditingController();
  TextEditingController leadActorsController = TextEditingController();
  TextEditingController registeredByController = TextEditingController();

  // Agrega una instancia de FirebaseFirestore
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Agrega una referencia a la colección 'movies'
  final CollectionReference movies = FirebaseFirestore.instance.collection('movies');

  // Método para agregar una película
 // Método para agregar una película
Future<void> addMovie(Movie movie) async {
  try {
    // Mostrar un mensaje de carga o indicador de progreso
    // setState(() {
    //   isLoading = true;
    // });

    // Agregar la película a Firestore
    final DocumentReference docRef = await movies.add(movie.toJson());

    // Obtener el snapshot del documento recién agregado
    final DocumentSnapshot docSnapshot = await docRef.get();

    // Mostrar un mensaje de éxito
    showTopSnackBar(
      context as OverlayState,
      const CustomSnackBar.success(
        message: "Película registrada exitosamente",
      ),
    );

    // Limpiar los campos del formulario
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

    // Navegar de regreso a la página de inicio
    Navigator.of(context).pop(); // Esto cierra la pantalla actual y vuelve a la anterior

    // setState(() {
    //   isLoading = false;
    // });
  } catch (e) {
    // Manejar el error
    showTopSnackBar(
      context as OverlayState,
      CustomSnackBar.error(
        message: "Error registrando película: $e",
      ),
    );

    // setState(() {
    //   isLoading = false;
    // });
  }
}


  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;

    // Definir un ancho máximo para los campos
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
                      child: TextFormField(
                        controller: posterPathController,
                        decoration: _inputDecoration(context, "Ruta del Póster"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: fieldWidth,
                      child: TextFormField(
                        controller: backdropPathController,
                        decoration: _inputDecoration(context, "Ruta del Fondo"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: fieldWidth,
                      child: TextFormField(
                        controller: voteAverageController,
                        decoration: _inputDecoration(context, "Calificación Promedio"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
      width: fieldWidth,
      child: DropdownButtonFormField<String>(
        value: statusController.text.isNotEmpty ? statusController.text : null,
        onChanged: (value) {
          setState(() {
            statusController.text = value!;
          });
        },
        items: [
          DropdownMenuItem(
            child: Text('Muy Pronto', style: TextStyle(color: Colors.black)),
            value: 'muy pronto',
          ),
          DropdownMenuItem(
            child: Text('En Cartelera', style: TextStyle(color: Colors.black)),
            value: 'en cartelera',
          ),
          DropdownMenuItem(
            child: Text('Acabado', style: TextStyle(color: Colors.black)),
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
                        decoration: _inputDecoration(context, "Nombres de los Directores"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: fieldWidth,
                      child: TextFormField(
                        controller: leadActorsController,
                        decoration: _inputDecoration(context, "Actores Principales"),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // No necesitamos un campo de texto para 'registeredBy' ya que se llenará automáticamente
                    // pero puedes mostrar el nombre de usuario registrado si lo deseas
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          // Crear la instancia de la película utilizando los controladores
                          Movie movie = Movie(
                            id: '', // Esto se llenará automáticamente al agregar la película
                            title: titleController.text.trim(),
                            overview: overviewController.text.trim(),
                            posterPath: posterPathController.text.trim(),
                            backdropPath: backdropPathController.text.trim(),
                            voteAverage: double.parse(voteAverageController.text.trim() ?? "0"),
                            status: statusController.text.trim(),
                            genres: [genresController.text.trim()],
                            directorNames: [directorNamesController.text.trim()],
                            leadActors: [leadActorsController.text.trim()],
                            registeredBy: registeredByController.text.trim(), // Aunque se llenará automáticamente, aquí lo mantenemos por completitud
                          );

                          // Llamar al método addMovie
                          await addMovie(movie);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 160, vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text("Registrar", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
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
      labelStyle: const TextStyle(color: Colors.white38, fontSize: 16, fontWeight: FontWeight.w500),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white24), borderRadius: BorderRadius.circular(16)),
      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Theme.of(context).primaryColor), borderRadius: BorderRadius.circular(16)),
      border: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white70), borderRadius: BorderRadius.circular(16)),
    );
  }
}