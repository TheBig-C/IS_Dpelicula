import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff1C1C27), // Azul oscuro
        centerTitle: true,
        title: Container(
          padding: const EdgeInsets.all(20),
          child: Text(
            'Dashboard',
            style: TextStyle(
              color: const Color(0xfff4b33c), // Naranja
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            ActivityCharts(),
          ],
        ),
      ),
      backgroundColor: const Color(0xff1C1C27), // Azul oscuro de fondo
    );
  }
}

class ActivityCharts extends StatelessWidget {
  const ActivityCharts({Key? key}) : super(key: key);
  Widget buildCard(String title, Widget content) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(height: 200, child: content),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('activity').snapshots(),
      builder: (context, activitySnapshot) {
        if (activitySnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (activitySnapshot.hasError) {
          return const Center(child: Text('Error cargando datos'));
        }

        final activityDocs = activitySnapshot.data!.docs;

        return StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance.collection('functions').snapshots(),
          builder: (context, functionSnapshot) {
            if (functionSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (functionSnapshot.hasError) {
              return const Center(child: Text('Error cargando datos'));
            }

            final functionDocs = functionSnapshot.data!.docs;

            return StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('billboards')
                  .snapshots(),
              builder: (context, billboardSnapshot) {
                if (billboardSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (billboardSnapshot.hasError) {
                  return const Center(child: Text('Error cargando datos'));
                }

                final billboardDocs = billboardSnapshot.data!.docs;

                return StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('movies')
                      .snapshots(),
                  builder: (context, movieSnapshot) {
                    if (movieSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (movieSnapshot.hasError) {
                      return const Center(child: Text('Error cargando datos'));
                    }

                    final movieDocs = movieSnapshot.data!.docs;

                    int successfulLogins = 0;
                    int failedLogins = 0;
                    Map<String, int> userLoginAttempts = {};
                    Map<String, int> dailyLoginAttempts = {};
                    Map<String, int> hourlyLoginDistribution = {};
                    Map<String, int> movieTicketSales = {};
                    Map<String, double> genreAverageRatings = {};
                    Map<String, int> moviesByGenre = {};

                    // Process activity data
                    for (var doc in activityDocs) {
                      final data = doc.data() as Map<String, dynamic>;
                      final user = data['user'];
                      final date = data['date'];
                      final hour = data['hour'];

                      if (data['activity'] == 'Inicio de sesión exitoso') {
                        successfulLogins++;
                      } else if (data['activity'] ==
                          'Intento de Inicio de sesión fallido') {
                        failedLogins++;
                      }

                      userLoginAttempts[user] =
                          (userLoginAttempts[user] ?? 0) + 1;

                      // Daily login attempts
                      dailyLoginAttempts[date] =
                          (dailyLoginAttempts[date] ?? 0) + 1;

                      // Hourly login distribution
                      final hourOnly = hour.split(':')[0];
                      hourlyLoginDistribution[hourOnly] =
                          (hourlyLoginDistribution[hourOnly] ?? 0) + 1;
                    }

                    // Process function and billboard data
                    for (var functionDoc in functionDocs) {
                      final functionData =
                          functionDoc.data() as Map<String, dynamic>;
                      final movieId = functionData['movieId'];
                      movieTicketSales[movieId] =
                          (movieTicketSales[movieId] ?? 0) + 1;
                    }

                    // Process movie data
                    for (var movieDoc in movieDocs) {
                      final movieData = movieDoc.data() as Map<String, dynamic>;
                      final genres = List<String>.from(movieData['genres']);
                      final rating = movieData['vote_average'].toDouble();

                      for (var genre in genres) {
                        genreAverageRatings[genre] =
                            (genreAverageRatings[genre] ?? 0) + rating;
                        moviesByGenre[genre] = (moviesByGenre[genre] ?? 0) + 1;
                      }
                    }

                    // Calculate average ratings per genre
                    genreAverageRatings
                        .updateAll((key, value) => value / moviesByGenre[key]!);

                    // Sorting dailyLoginAttempts by date
                    var sortedDailyLogins = dailyLoginAttempts.entries.toList()
                      ..sort((a, b) => DateFormat('yyyy-MM-dd')
                          .parse(a.key)
                          .compareTo(DateFormat('yyyy-MM-dd').parse(b.key)));

                    Widget buildChartWidgets(
                        BuildContext context, BoxConstraints constraints) {
                      final isDesktop = constraints.maxWidth > 600;
                      final charts = [
                        buildCard(
                          'Distribución de Actividades',
                          PieChart(
                            PieChartData(
                              sections: [
                                PieChartSectionData(
                                  color: Colors.green,
                                  value: successfulLogins.toDouble(),
                                  title: 'Éxito',
                                  radius: 50,
                                  titleStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                PieChartSectionData(
                                  color: Colors.red,
                                  value: failedLogins.toDouble(),
                                  title: 'Fallido',
                                  radius: 50,
                                  titleStyle: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        buildCard(
                          'Intentos de Inicio de Sesión por Usuario',
                          ListView.builder(
                            itemCount: userLoginAttempts.length,
                            itemBuilder: (context, index) {
                              String user =
                                  userLoginAttempts.keys.elementAt(index);
                              int attempts = userLoginAttempts[user]!;
                              return ListTile(
                                title: Text(user),
                                subtitle: Text('Intentos: $attempts'),
                              );
                            },
                          ),
                        ),
                        buildCard(
                          'Intentos Diarios de Inicio de Sesión',
                          LineChart(
                            LineChartData(
                              lineBarsData: [
                                LineChartBarData(
                                  spots: sortedDailyLogins
                                      .asMap()
                                      .entries
                                      .map((e) => FlSpot(e.key.toDouble(),
                                          e.value.value.toDouble()))
                                      .toList(),
                                  isCurved: true,
                                  barWidth: 2,
                                  color: Colors.deepPurple,
                                ),
                              ],
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 35,
                                    interval: 10,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 10,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toString(),
                                        style: TextStyle(
                                          color: Colors
                                              .transparent, // Mismo color del fondo
                                          fontSize: 10,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toString(),
                                        style: TextStyle(
                                          color: Colors
                                              .transparent, // Mismo color del fondo
                                          fontSize: 10,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 30,
                                    interval: 0.5,
                                    getTitlesWidget: (value, meta) {
                                      int interval =
                                          (sortedDailyLogins.length / 5).ceil();
                                      if (value.toInt() % interval == 0 &&
                                          value.toInt() <
                                              sortedDailyLogins.length) {
                                        return Text(
                                          DateFormat('yyyy-MM-dd').format(
                                              DateFormat('yyyy-MM-dd').parse(
                                                  sortedDailyLogins[
                                                          value.toInt()]
                                                      .key)),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 10),
                                        );
                                      }
                                      return const SizedBox.shrink();
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        buildCard(
                          'Distribución Horaria de Inicios de Sesión',
                          BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              barGroups: hourlyLoginDistribution.entries
                                  .map((e) => BarChartGroupData(
                                        x: int.parse(e.key),
                                        barRods: [
                                          BarChartRodData(
                                            toY: e.value.toDouble(),
                                            color: Colors.orange,
                                            width: 16,
                                          ),
                                        ],
                                      ))
                                  .toList(),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 30,
                                    interval: 2,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toString(),
                                        style: TextStyle(
                                          color: Colors
                                              .transparent, // Mismo color del fondo
                                          fontSize: 10,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toString(),
                                        style: TextStyle(
                                          color: Colors
                                              .transparent, // Mismo color del fondo
                                          fontSize: 10,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        '${value.toInt()}:00',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 10),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        buildCard(
                          'Ventas de Entradas por Película',
                          BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              barGroups: movieTicketSales.entries
                                  .map((e) => BarChartGroupData(
                                        x: e.key.hashCode,
                                        barRods: [
                                          BarChartRodData(
                                            toY: e.value.toDouble(),
                                            color: Colors.orange,
                                            width: 16,
                                          ),
                                        ],
                                      ))
                                  .toList(),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 20,
                                    interval: 2,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toString(),
                                        style: TextStyle(
                                          color: Colors
                                              .transparent, // Mismo color del fondo
                                          fontSize: 10,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toString(),
                                        style: TextStyle(
                                          color: Colors
                                              .transparent, // Mismo color del fondo
                                          fontSize: 10,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 50,
                                    getTitlesWidget: (value, meta) {
                                      final movie = movieDocs.firstWhere(
                                          (doc) =>
                                              doc.id.hashCode == value.toInt());
                                      return movie != null
                                          ? Container(
                                              width: 50,
                                              child: Text(
                                                movie['title'],
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10),
                                                maxLines:
                                                    3, // Permite hasta 2 líneas
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                                textAlign: TextAlign.center,
                                              ),
                                            )
                                          : Text('');
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        buildCard(
                          'Calificación Promedio por Género',
                          BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              barGroups: genreAverageRatings.entries
                                  .map((e) => BarChartGroupData(
                                        x: e.key.hashCode,
                                        barRods: [
                                          BarChartRodData(
                                            toY: e.value,
                                            color: Colors.deepPurple,
                                            width: 16,
                                          ),
                                        ],
                                      ))
                                  .toList(),
                              titlesData: FlTitlesData(
                                leftTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 20,
                                    interval: 3,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toString(),
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                rightTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toString(),
                                        style: TextStyle(
                                          color: Colors
                                              .transparent, // Mismo color del fondo
                                          fontSize: 10,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                topTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      return Text(
                                        value.toString(),
                                        style: TextStyle(
                                          color: Colors
                                              .transparent, // Mismo color del fondo
                                          fontSize: 10,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (value, meta) {
                                      final genre = genreAverageRatings.keys
                                          .firstWhere((key) =>
                                              key.hashCode == value.toInt());
                                      return genre != null
                                          ? Text(
                                              genre,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12),
                                            )
                                          : Text('');
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        buildCard(
                          'Películas por Género',
                          Container(
                            width: 600,
                            child: Row(
                              children: [
                                Expanded(
                                  child: PieChart(
                                    PieChartData(
                                      sections: moviesByGenre.entries
                                          .map((e) => PieChartSectionData(
                                                color: Colors.primaries[
                                                    moviesByGenre.keys
                                                            .toList()
                                                            .indexOf(e.key) %
                                                        Colors
                                                            .primaries.length],
                                                value: e.value.toDouble(),
                                                title: '',
                                                radius: 50,
                                                titleStyle: TextStyle(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black,
                                                ),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 16),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: moviesByGenre.entries
                                      .map((e) => Row(
                                            children: [
                                              Container(
                                                width: 16,
                                                height: 16,
                                                color: Colors.primaries[
                                                    moviesByGenre.keys
                                                            .toList()
                                                            .indexOf(e.key) %
                                                        Colors
                                                            .primaries.length],
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                '${e.key} (${e.value})',
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black),
                                              ),
                                            ],
                                          ))
                                      .toList(),
                                ),
                              ],
                            ),
                          ),
                        )
                      ];

                      if (isDesktop) {
                        return Column(
                          children: [
                            Row(
                              children: charts
                                  .sublist(0, 2)
                                  .map((chart) => Expanded(child: chart))
                                  .toList(),
                            ),
                            Row(
                              children: charts
                                  .sublist(2, 4)
                                  .map((chart) => Expanded(child: chart))
                                  .toList(),
                            ),
                            Row(
                              children: charts
                                  .sublist(4, 6)
                                  .map((chart) => Expanded(child: chart))
                                  .toList(),
                            ),
                            charts.last,
                          ],
                        );
                      } else {
                        return Column(
                          children: charts,
                        );
                      }
                    }

                    return LayoutBuilder(
                      builder: buildChartWidgets,
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}