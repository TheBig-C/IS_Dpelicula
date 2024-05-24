import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:is_dpelicula/pages/register_employee.dart';
import 'package:is_dpelicula/widgets/custom_app_bar.dart';
import 'control_employee.dart'; // Asegúrate de que esta importación sea correcta
import 'control_client.dart'; 
import 'register_movie_page.dart';

class OptionsPage extends StatefulWidget {
  @override
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  bool isAdmin = false;
  Widget mainContent = Center(child: Text('Contenido principal aquí'));

  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  Future<void> _checkRole() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var docSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (docSnapshot.exists && docSnapshot.data()?['role'] == 'admin') {
        setState(() {
          isAdmin = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;
    return Scaffold(
      appBar: CustomAppBar(isDesktop: isDesktop),
      body: Row(
        children: [
          Container(
            width: isDesktop ? 300 : 0,
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
                  if (isAdmin) _buildDrawerItem(Icons.person_add, 'Registrar Empleado', () => _updateMainContent(RegisterEmployee())),
                  if (isAdmin) _buildDrawerItem(Icons.movie, 'Registrar Película', () => _updateMainContent(RegisterMovie())),
                  if (isAdmin) _buildDrawerItem(Icons.people, 'Control de empleados', () => _updateMainContent(ControlEmployee())),
                  if (isAdmin) _buildDrawerItem(Icons.people, 'Control de clientes', () => _updateMainContent(ControlClient())),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              child: mainContent,
            ),
          ),
        ],
      ),
    );
  }

  void _updateMainContent(Widget content) {
    setState(() {
      mainContent = content;
    });
  }

  Widget _buildDrawerItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(title),
      onTap: onTap,
    );
  }
}
