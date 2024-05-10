import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart'; // Importa foundation

class DesktopFooter extends StatefulWidget {
  const DesktopFooter({super.key});

  @override
  _DesktopFooterState createState() => _DesktopFooterState();
}

class _DesktopFooterState extends State<DesktopFooter> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(-16.5000, -68.1500); // Coordenadas ejemplo

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300, // Ajusta la altura del footer según sea necesario
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      decoration: const BoxDecoration(
        color: Colors.blueGrey, // Ajusta el color según sea necesario
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
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
          ),
          Expanded(
            flex: 2, // Da más espacio al mapa
            child: kIsWeb ? Image.network('URL_DE_UNA_IMAGEN_ESTÁTICA_DEL_MAPA')
                         : GoogleMap(
                             onMapCreated: _onMapCreated,
                             initialCameraPosition: CameraPosition(
                               target: _center,
                               zoom: 14.0,
                             ),
                           ),
          ),
        ],
      ),
    );
  }
}
