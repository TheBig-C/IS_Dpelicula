import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MovieSatisfaction extends StatefulWidget {
  const MovieSatisfaction({super.key});

  @override
  State<MovieSatisfaction> createState() => _MovieSatisfactionState();
}

class _MovieSatisfactionState extends State<MovieSatisfaction> {
  final TextEditingController ratingFilterController = TextEditingController();
  String dateOrder = 'Más reciente';
  String selectedMovie = 'Mostrar todo';
  int totalRatings = 0;
  double averageRating = 0.0;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference satisfaction = firestore.collection('Satisfaccion');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1C1C27), // Azul oscuro
        centerTitle: true,
        title: Container(
          padding: const EdgeInsets.all(20),
          child: Text(
            'Satisfacción de Películas',
            style: TextStyle(
              color: const Color(0xfff4b33c), // Naranja
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: StreamBuilder<QuerySnapshot>(
                      stream: satisfaction.snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData)
                          return CircularProgressIndicator();
                        List<String> movieTitles = snapshot.data!.docs
                            .map((doc) => (doc.data()
                                    as Map<String, dynamic>)['movieTitle']
                                as String)
                            .toSet()
                            .toList();
                        movieTitles.insert(0, 'Mostrar todo');
                        return DropdownButtonFormField<String>(
                          dropdownColor: Color(0xff1C1C27),
                          value: selectedMovie,
                          items: movieTitles.map((title) {
                            return DropdownMenuItem<String>(
                              value: title,
                              child: Text(title,
                                  style: TextStyle(color: Color(0xfff4b33c))),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedMovie = value!;
                              if (selectedMovie != 'Mostrar todo') {
                                _updateMovieStatistics(selectedMovie);
                              } else {
                                totalRatings = 0;
                                averageRating = 0.0;
                              }
                            });
                          },
                          decoration: _inputDecoration(
                              'Selecciona una película', context),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: ratingFilterController,
                      decoration:
                          _inputDecoration('Buscar por rating', context),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  DropdownButton<String>(
                    dropdownColor: Color(0xff1C1C27),
                    value: dateOrder,
                    items: ['Más reciente', 'Más antiguo'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            style: TextStyle(color: Color(0xfff4b33c))),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        dateOrder = value!;
                      });
                    },
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      ratingFilterController.clear();
                      setState(() {
                        selectedMovie = 'Mostrar todo';
                        totalRatings = 0;
                        averageRating = 0.0;
                      });
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: _buildMovieList(satisfaction),
                  ),
                  if (MediaQuery.of(context).size.width > 800)
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Estadísticas de la Película',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 16),
                            Text(
                              'Total de Puntuaciones: $totalRatings',
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Promedio de Puntuaciones: ${averageRating.toStringAsFixed(2)}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateMovieStatistics(String movieTitle) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference satisfaction = firestore.collection('Satisfaccion');

    QuerySnapshot querySnapshot =
        await satisfaction.where('movieTitle', isEqualTo: movieTitle).get();

    int total = querySnapshot.docs.length;
    double sum = querySnapshot.docs.fold(0, (prev, element) {
      return prev + (element.data() as Map<String, dynamic>)['rating'];
    });

    setState(() {
      totalRatings = total;
      averageRating = total > 0 ? sum / total : 0.0;
    });
  }

  InputDecoration _inputDecoration(String labelText, BuildContext context) {
    return InputDecoration(
      labelText: labelText,
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
      border: OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xfff4b33c).withOpacity(0.7)),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }

  Widget _buildMovieList(CollectionReference satisfaction) {
    String ratingQuery = ratingFilterController.text.toLowerCase();

    return StreamBuilder<QuerySnapshot>(
      stream: satisfaction.snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text('Algo salió mal');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        var filteredDocs = snapshot.data!.docs.where((doc) {
          var data = doc.data() as Map<String, dynamic>;
          bool matchesMovie = selectedMovie == 'Mostrar todo' ||
              data['movieTitle']
                  .toString()
                  .toLowerCase()
                  .contains(selectedMovie.toLowerCase());
          bool matchesRating = ratingQuery.isEmpty ||
              data['rating'].toString().toLowerCase().contains(ratingQuery);
          return matchesMovie && matchesRating;
        }).toList();

        if (dateOrder == 'Más reciente') {
          filteredDocs.sort((a, b) {
            var aDate =
                (a.data() as Map<String, dynamic>)['timestamp'] as Timestamp;
            var bDate =
                (b.data() as Map<String, dynamic>)['timestamp'] as Timestamp;
            return bDate.compareTo(aDate);
          });
        } else {
          filteredDocs.sort((a, b) {
            var aDate =
                (a.data() as Map<String, dynamic>)['timestamp'] as Timestamp;
            var bDate =
                (b.data() as Map<String, dynamic>)['timestamp'] as Timestamp;
            return aDate.compareTo(bDate);
          });
        }

        return Container(
          color: Color(0xff1C1C27),
          child: ListView(
            children: filteredDocs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data()! as Map<String, dynamic>;
              DateTime timestamp = (data['timestamp'] as Timestamp).toDate();
              String formattedDate =
                  DateFormat('dd MMM yyyy, hh:mm a').format(timestamp);
              return Card(
                color: Color(0xff1C1C27),
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data['movieTitle'] ?? 'N/A',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                          'Satisfacción: ${data['rating']?.toString() ?? 'N/A'}',
                          style: TextStyle(color: Colors.white)),
                      Text('Fecha: $formattedDate',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }
}
