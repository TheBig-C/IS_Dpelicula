import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:is_dpelicula/widgets/custom_app_bar.dart';  // Asegúrate de que la ruta del import sea correcta

class OptionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    return Scaffold(
      appBar: CustomAppBar(isDesktop: isDesktop),
      body: Row(
        children: [
          // Ajusta el ancho del drawer aquí según tus necesidades
          Container(
            width: isDesktop ? 300 : 0, // 300px de ancho si es escritorio, 0 si no
            child: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: <Widget>[
                 
                  _buildDrawerItem(Icons.home, 'Inicio', () => context.goNamed('home')),
                  _buildDrawerItem(Icons.history, 'Historial', () => context.goNamed('history')),
                  _buildDrawerItem(Icons.account_circle, 'Perfil', () => context.goNamed('profile')),
                  _buildDrawerItem(Icons.exit_to_app, 'Cerrar sesión', () {
                    FirebaseAuth.instance.signOut().then((_) => context.goNamed('login'));
                  }),
                  _buildDrawerItem(Icons.person_add, 'Registrar Empleado', () => context.goNamed('registerEmployee')),
                  _buildDrawerItem(Icons.movie, 'Registrar Película', () => context.goNamed('registerMovie')),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: Center(
                child: Text('Contenido principal aquí'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(title),
      onTap: onTap,
    );
  }
}
