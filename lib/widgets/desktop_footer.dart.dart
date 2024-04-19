import 'package:flutter/material.dart';

class DesktopFooter extends StatelessWidget {
  const DesktopFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      decoration: const BoxDecoration(
        color: Colors.blueGrey, // Ajusta el color según sea necesario
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('Dpelicula © 2024', style: TextStyle(color: Colors.white, fontSize: 14)),
          SizedBox(height: 10),
          Text('Todos los derechos reservados', style: TextStyle(color: Colors.white, fontSize: 12)),
          SizedBox(height: 20),
          Text('Horario de atención: Lunes a Domingos - 9:00 a 18:00', style: TextStyle(color: Colors.white, fontSize: 12)),
          SizedBox(height: 5),
          Text('Teléfono: +555 567 8900', style: TextStyle(color: Colors.white, fontSize: 12)),
          SizedBox(height: 5),
          Text('Correo: contacto@dpelicula.com', style: TextStyle(color: Colors.white, fontSize: 12)),
          SizedBox(height: 5),
          Text('Avenida Arce 2631, La Paz, Departamento De La Paz', style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }
}
