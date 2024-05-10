import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DesktopFooter extends StatefulWidget {
  const DesktopFooter({super.key});

  @override
  _DesktopFooterState createState() => _DesktopFooterState();
}

class _DesktopFooterState extends State<DesktopFooter> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(-16.5107348, -68.1231924); // Coordenadas del centro del mapa

  // Conjunto de marcadores
  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {
      // Agregar marcador en las coordenadas especificadas
      _markers.add(
        Marker(
          markerId: MarkerId('mainLocation'),
          position: _center,  // Posición del marcador
          infoWindow: InfoWindow(
            title: 'Dpelicula Headquarters',  // Título del marcador
            snippet: 'Avenida Arce 2631, La Paz',  // Descripción pequeña
          ),
          icon: BitmapDescriptor.defaultMarker,  // Ícono del marcador
        )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 350,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      decoration: const BoxDecoration(
        color: Colors.blueGrey,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
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
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: _center,
                zoom: 16.0,  // Ajustado para una mejor visualización del lugar
              ),
              markers: _markers,  // Agrega los marcadores al mapa
            ),
          ),
        ],
      ),
    );
  }
}
