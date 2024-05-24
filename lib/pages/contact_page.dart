import 'package:flutter/material.dart';
import 'package:is_dpelicula/widgets/custom_app_bar.dart';
import 'package:is_dpelicula/widgets/desktop_footer.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  void _launchMapsUrl(double latitude, double longitude) async {
    var url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _launchUrl(String urlString) async {
    var url = Uri.parse(urlString);
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  Expanded(
                    child: ContactCard(),
                  ),
                  Expanded(
                    child: Image(
                      image: AssetImage(
                          'sala.png'), // Nombre del archivo de imagen
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 40), // Espacio antes del botón
              ElevatedButton(
                onPressed: () => _launchMapsUrl(-16.500000, -68.150000),
                child: const Text('Ver Ubicación en Mapa'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  textStyle: const TextStyle(fontSize: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
              const SizedBox(height: 40), // Espacio después del botón
              const IconSection(), // Sección de íconos más grandes y blancos
              const DesktopFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactCard extends StatelessWidget {
  const ContactCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 600, // Reduce el ancho del recuadro
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center, // Centra los elementos verticalmente
          crossAxisAlignment:
              CrossAxisAlignment.center, // Centra los elementos horizontalmente
          children: [
            Text(
              'Contáctanos',
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
            const SizedBox(height: 10),
            Text(
              '¿Tienes preguntas o comentarios? No dudes en contactarnos a través de los siguientes medios:',
              style: TextStyle(fontSize: 16, color: Colors.black54),
              textAlign: TextAlign.center, // Centra el texto
            ),
            const SizedBox(height: 20),
            const ContactDetails(),
          ],
        ),
      ),
    );
  }
}

class ContactDetails extends StatelessWidget {
  const ContactDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment:
          CrossAxisAlignment.center, // Centra los detalles horizontalmente
      children: const [
        ContactDetail(
            icon: Icons.email, label: 'Email', text: 'callcenterlp@multicine.com.bo'),
        ContactDetail(
            icon: Icons.phone, label: 'Teléfono', text: '+591 22113463'),
        ContactDetail(
            icon: Icons.location_on,
            label: 'Dirección',
            text: 'Av. Arce 2631, La Paz, Bolivia'),
        ContactDetail(
            icon: Icons.web, label: 'Sitio Web:', text: 'www.multicine.com.bo'),
        ContactDetail(
            icon: Icons.facebook,
            label: 'Facebook',
            text: 'MulticineBolivia'),
        ContactDetail(
            icon: Icons.camera_alt, label: 'Instagram', text: '@multicinebolivia'),
      ],
    );
  }
}

class ContactDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String text;

  const ContactDetail({
    Key? key,
    required this.icon,
    required this.label,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.center, // Centra el contenido de la fila
        children: [
          Icon(icon, size: 24, color: Colors.deepPurple),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: TextStyle(
                fontSize: 16,
                color: Colors.deepPurple,
                fontWeight: FontWeight.bold),
          ),
          Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.black),
          ),
        ],
      ),
    );
  }
}

class IconSection extends StatelessWidget {
  const IconSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () => ContactPage()
                  ._launchUrl('mailto:callcenterlp@multicine.com.bo'),
              child: const Icon(Icons.email, size: 36, color: Colors.white),
            ),
            GestureDetector(
              onTap: () => ContactPage()._launchUrl('tel:(591 2) 211 2463'),
              child: const Icon(Icons.phone, size: 36, color: Colors.white),
            ),
            GestureDetector(
              onTap: () =>
                  ContactPage()._launchUrl('https://www.multicine.com.bo'),
              child: const Icon(Icons.web, size: 36, color: Colors.white),
            ),
            GestureDetector(
              onTap: () => ContactPage()
                  ._launchUrl('https://www.facebook.com/MulticineBolivia'),
              child: const Icon(Icons.facebook, size: 36, color: Colors.white),
            ),
            GestureDetector(
              onTap: () => ContactPage()
                  ._launchUrl('https://www.instagram.com/multicinebolivia/'),
              child: const Icon(Icons.camera, size: 36, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 40), // Espacio después de los iconos
      ],
    );
  }
}
