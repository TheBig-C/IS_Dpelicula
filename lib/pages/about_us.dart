import 'package:flutter/material.dart';
import 'package:is_dpelicula/widgets/custom_app_bar.dart';
import 'package:is_dpelicula/widgets/desktop_footer.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(isDesktop: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center( // Envuelve en un Center para alinear las tarjetas al medio
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // Alinea el contenido de las columnas al centro
            children: [
              _buildSectionCard(
                title: 'Acerca de Dpelicula',
                content: 'Dpelicula es una plataforma líder en streaming de películas y series. Ofrecemos contenido de alta calidad para todos los gustos y edades. Conócenos y descubre más sobre nuestra misión y visión.',
                icon: Icons.movie_filter,
              ),
              _buildSectionCard(
                title: 'Descripción de la empresa',
                content: 'Multicine Bolivia es una empresa boliviana de entretenimiento cinematográfico fundada en el año 2009. Ofrece una experiencia de entretenimiento de calidad, con una amplia selección de películas de diversos géneros y formatos, así como comodidades para garantizar la satisfacción de sus clientes. Esta empresa opera en varias ciudades importantes del país, incluyendo La Paz, Santa Cruz y Cochabamba.',
                icon: Icons.business,
              ),
               const SizedBox(height: 20),
              Image.asset(
                'logo.png', // Cambia esto por el nombre de tu archivo local
                width: 300,
                height: 200,
                fit: BoxFit.cover,
              ),
              _buildSectionCard(
                title: 'Misión',
                content: 'Nuestra misión es brindar una experiencia cinematográfica inigualable para toda la familia. Nos esforzamos por ser mucho más que un lugar para ver películas; somos un espacio donde los sueños cobran vida, donde las risas, los susurros y los aplausos se entrelazan para crear recuerdos inolvidables. Ofrecemos ambientes confortables llenos de luz y color, con un personal capacitado y preparado para otorgar un servicio de calidad.',
                icon: Icons.local_movies,
              ),
              _buildSectionCard(
                title: 'Visión',
                content: 'Nos visualizamos como el líder en entretenimiento cinematográfico en Bolivia, reconocidos por nuestras instalaciones de vanguardia equipadas con la última tecnología audiovisual. Valoramos la importancia de la familia y la comunidad, por lo que nos esforzamos por crear un ambiente acogedor y seguro donde todos nuestros usuarios puedan disfrutar de nuevas experiencias de forma segura. En Multicine, no sólo proyectamos películas; creamos experiencias memorables que perduran en el corazón de quienes nos eligen.',
                icon: Icons.visibility,
              ),
               const DesktopFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required String title, required String content, required IconData icon}) {
    return Container(
      width: 800, // Ajusta este valor para hacer los recuadros menos angostos
      padding: const EdgeInsets.only(bottom: 10), // Espacio entre tarjetas
      child: Card(
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(icon, color: Colors.deepPurple),
                  const SizedBox(width: 10),
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.black),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                content,
                style: const TextStyle(fontSize: 16, color: Colors.black),
                textAlign: TextAlign.justify,
              ),
             
               
            ],
          ),
        ),
      ),
    );
  }
}
