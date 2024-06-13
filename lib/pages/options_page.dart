import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:is_dpelicula/pages/Dashboard/dashboard.dart';
import 'package:is_dpelicula/pages/auth/register_employee.dart';
import 'package:is_dpelicula/pages/billBoard/active_schedule_page.dart';
import 'package:is_dpelicula/pages/billBoard/create_billboard_page.dart';
import 'package:is_dpelicula/pages/movies/movie_rating.dart';
import 'package:is_dpelicula/pages/movies/register_movie_page.dart';
import 'package:is_dpelicula/pages/movies/registered_movies.dart';
import 'package:is_dpelicula/pages/room/RegisteredRoomsPage.dart';
import 'package:is_dpelicula/pages/room/roomCreationPage.dart';
import 'package:is_dpelicula/pages/tickets/registered_tickets.dart';
import 'package:is_dpelicula/pages/users/control_client.dart';
import 'package:is_dpelicula/pages/users/control_employee.dart';
import 'package:is_dpelicula/pages/users/profile_edit_page.dart';
import 'package:is_dpelicula/pages/users/profile_page.dart';
import 'package:is_dpelicula/widgets/custom_app_bar.dart';

class OptionsPage extends StatefulWidget {
  @override
  _OptionsPageState createState() => _OptionsPageState();
}

class _OptionsPageState extends State<OptionsPage> {
  bool isAdmin = false;
  Widget mainContent = ProfilePage();
  String selectedOption = '';

  @override
  void initState() {
    super.initState();
    _checkRole();
  }

  Future<void> _checkRole() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (docSnapshot.exists && docSnapshot.data()?['role'] == 'admin') {
        setState(() {
          isAdmin = true;
          mainContent = DashboardPage();
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
                  _buildDrawerItem(Icons.home, 'Inicio', 'home',
                      () => context.goNamed('home')),
                  _buildDrawerItem(Icons.account_circle, 'Perfil', 'profile',
                      () => _updateMainContent(ProfilePage())),
                  _buildDrawerItem(
                      Icons.manage_accounts_rounded,
                      'Editar Perfil',
                      'edit_profile',
                      () => _updateMainContent(ProfileEditPage())),
                  if (isAdmin)
                    _buildDrawerItem(Icons.dashboard, 'Panel de control',
                        'dashboard', () => _updateMainContent(DashboardPage())),
                  if (isAdmin)
                    _buildDrawerItem(
                        Icons.person_add,
                        'Registrar Empleado',
                        'register_employee',
                        () => _updateMainContent(RegisterEmployee())),
                  if (isAdmin)
                    _buildDrawerItem(
                        Icons.movie,
                        'Registrar Película',
                        'register_movie',
                        () => _updateMainContent(RegisterMovie())),
                  if (isAdmin)
                    _buildDrawerItem(
                        Icons.people_alt,
                        'Control de empleados',
                        'control_employee',
                        () => _updateMainContent(ControlEmployee())),
                  if (isAdmin)
                    _buildDrawerItem(
                        Icons.local_movies_rounded,
                        'Satisfación del cliente',
                        'movie_satisfaction',
                        () => _updateMainContent(MovieSatisfaction())),
                  if (isAdmin)
                    _buildDrawerItem(
                        Icons.group,
                        'Control de clientes',
                        'control_client',
                        () => _updateMainContent(ControlClient())),
                  if (isAdmin)
                    _buildDrawerItem(
                        Icons.movie_filter,
                        'Ver Películas',
                        'registered_movies',
                        () => _updateMainContent(RegisteredMoviesPage())),
                  if (isAdmin)
                    _buildDrawerItem(
                        Icons.add_business,
                        'Agregar Sala',
                        'room_creation',
                        () => _updateMainContent(RoomCreationPage())),
                  if (isAdmin)
                    _buildDrawerItem(
                        Icons.room_preferences,
                        'Control Salas',
                        'registered_rooms',
                        () => _updateMainContent(RegisteredRoomsPage())),
                  if (isAdmin)
                    _buildDrawerItem(
                        Icons.add_to_photos,
                        'Crear Cartelera',
                        'create_billboard',
                        () => _updateMainContent(CreateBillboardPage())),
                  if (isAdmin)
                    _buildDrawerItem(
                        Icons.schedule,
                        'Cartelera Actual',
                        'active_schedule',
                        () => _updateMainContent(ActiveSchedulePage())),
                  if (isAdmin)
                    _buildDrawerItem(
                        Icons.airplane_ticket,
                        'Tickets Registrados',
                        'registered_tickets',
                        () => _updateMainContent(RegisteredTicketsPage())),
                  _buildDrawerItem(Icons.exit_to_app, 'Cerrar sesión', 'logout',
                      () {
                    FirebaseAuth.instance
                        .signOut()
                        .then((_) => context.goNamed('login'));
                  }),
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

  Widget _buildDrawerItem(
      IconData icon, String title, String optionKey, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.orange),
      title: Text(title),
      onTap: () {
        setState(() {
          selectedOption = optionKey;
        });
        onTap();
      },
      selected: selectedOption == optionKey,
      selectedTileColor: Colors.orange.withOpacity(0.2),
    );
  }
}
