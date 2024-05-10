import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDesktop;

  const CustomAppBar({Key? key, required this.isDesktop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');

    return AppBar(
      backgroundColor: const Color(0xff1C1C27),
      title: Image.asset(
        'dp.png',
        height: kToolbarHeight - 20,
      ),
      leading: isDesktop
          ? null
          : Builder(
              builder: (context) => IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
      actions: <Widget>[
        if (isDesktop) ...[
          TextButton(
            onPressed: () => context.goNamed('home'),
            child: Text("Inicio", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => context.go('/aboutUs'),
            child: Text("Nosotros", style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => context.go('/contact'),
            child: Text("Contáctanos", style: TextStyle(color: Colors.white)),
          ),
        ],
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Implementar acción de búsqueda
            },
          ),
        ),
        if (user != null) ...[
          FutureBuilder<DocumentSnapshot>(
            future: users.doc(user.uid).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final data = snapshot.data!.data() as Map<String, dynamic>;
                return CircleAvatar(
                  backgroundImage: NetworkImage(
                      data['image_url'] ?? './assets/img/profile.png'),
                  radius: 24,
                );
              } else {
                return const CircleAvatar(
                  backgroundImage: AssetImage('./assets/img/profile.png'),
                  radius: 24,
                );
              }
            },
          ),
          FutureBuilder<DocumentSnapshot>(
            future: users.doc(user.uid).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done &&
                  snapshot.hasData) {
                final data = snapshot.data!.data() as Map<String, dynamic>;
                return PopupMenuButton<int>(
                  onSelected: (value) {
                    switch (value) {
                      case 0:
                        context.goNamed('home');
                        break;
                      case 1:
                        context.goNamed('history');
                        break;
                      case 2:
                        context.goNamed('profile');
                        break;
                      case 3:
                        FirebaseAuth.instance
                            .signOut()
                            .then((_) => context.goNamed('login'));
                        break;
                      case 4:
                        context.goNamed('registerEmployee');
                        break;
                      case 5:
                        context.goNamed('registerMovie');
                        break;
                    }
                  },
                  itemBuilder: (context) => <PopupMenuEntry<int>>[
                    const PopupMenuItem<int>(value: 0, child: Text('Inicio')),
                    const PopupMenuItem<int>(
                        value: 1, child: Text('Historial')),
                    const PopupMenuItem<int>(value: 2, child: Text('Perfil')),
                    const PopupMenuItem<int>(
                        value: 3, child: Text('Cerrar sesión')),
                    if (data['role'] == 'admin')
                      const PopupMenuItem<int>(
                          value: 4, child: Text('Registrar Empleado')),
                    if (data['role'] == 'admin')
                      const PopupMenuItem<int>(
                          value: 5, child: Text('Registrar Pelicula')),
                  ],
                );
              } else {
                return CircleAvatar(
                  backgroundImage: AssetImage('./assets/img/profile.png'),
                  radius: 24,
                );
              }
            },
          ),
        ] else ...[
          TextButton(
            onPressed: () => context.goNamed('login'),
            child: Text("Login", style: TextStyle(color: Colors.white)),
          )
        ],
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}