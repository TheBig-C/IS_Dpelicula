import 'package:flutter/material.dart';
import 'package:is_dpelicula/widgets/custom_app_bar.dart';
import 'package:is_dpelicula/widgets/desktop_footer.dart';
import 'package:url_launcher/url_launcher.dart';  // Asegúrate de tener esta importación

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  // Función para lanzar la URL de Google Maps
  void _launchMapsUrl(double latitude, double longitude) async {
    var url = Uri.parse('https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(isDesktop: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildContactCard(
                title: 'Contáctanos',
                content: '¿Tienes preguntas o comentarios? No dudes en contactarnos a través de los siguientes medios:',
              ),
              ElevatedButton(
                onPressed: () => _launchMapsUrl(-16.500000, -68.150000), // Coordenadas de ejemplo, cambia según tu necesidad
                child: const Text('Ver Ubicación en Mapa'),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.deepPurple, // Color del texto
                ),
              ),
              const DesktopFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard({required String title, required String content}) {
    return Card(
      elevation: 4,
      child: Container(
        width: 800,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 20),
            _buildContactDetail(icon: Icons.email, text: 'Email: contacto@dpelicula.com'),
            _buildContactDetail(icon: Icons.phone, text: 'Teléfono: +1 234 567 8900'),
            _buildContactDetail(icon: Icons.location_on, text: 'Dirección: Calle Falsa 123, Ciudad, País'),
            _buildContactDetail(icon: Icons.web, text: 'Sitio Web: www.dpelicula.com'),
            _buildContactDetail(icon: Icons.facebook, text: 'Facebook: @DpeliculaOfficial'),
            _buildContactDetail(icon: Icons.linked_camera, text: 'Instagram: @Dpelicula'),
          ],
        ),
      ),
    );
  }

  Widget _buildContactDetail({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 24, color: Colors.deepPurple),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.left,
            ),
          ),
        ],
      ),
    );
  }
}
