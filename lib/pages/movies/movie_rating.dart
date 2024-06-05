import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MovieSatisfaction extends StatefulWidget {
  const MovieSatisfaction({super.key});

  @override
  State<MovieSatisfaction> createState() => _MovieSatisfactionState();
}

class _MovieSatisfactionState extends State<MovieSatisfaction> {
  final TextEditingController movieFilterController = TextEditingController();
  final TextEditingController ratingFilterController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference satisfaction = firestore.collection('Satisfaccion');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Satisfacción de Películas',
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[700],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: movieFilterController,
                      decoration: InputDecoration(
                        labelText: 'Buscar por título de película',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: ratingFilterController,
                      decoration: InputDecoration(
                        labelText: 'Buscar por rating',
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                  SizedBox(width: 8),
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      movieFilterController.clear();
                      ratingFilterController.clear();
                      setState(() {});
                    },
                  ),
                ],
              ),
            ),
            Expanded(child: _buildMovieList(satisfaction)),
          ],
        ),
      ),
    );
  }

  Widget _buildMovieList(CollectionReference satisfaction) {
    String movieQuery = movieFilterController.text.toLowerCase();
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
          bool matchesMovie = movieQuery.isEmpty ||
              data['movieTitle'].toString().toLowerCase().contains(movieQuery);
          bool matchesRating = ratingQuery.isEmpty ||
              data['rating'].toString().toLowerCase().contains(ratingQuery);
          return matchesMovie && matchesRating;
        }).toList();

        return ListView(
          children: filteredDocs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
            DateTime timestamp = (data['timestamp'] as Timestamp).toDate();
            String formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(timestamp);
            return Card(
              margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['movieTitle'] ?? 'N/A',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text('Satisfación: ${data['rating']?.toString() ?? 'N/A'}',
                        style: TextStyle(color: Colors.black)),
                    Text('Fecha: $formattedDate',
                        style: TextStyle(color: Colors.black)),
                  ],
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }
}
