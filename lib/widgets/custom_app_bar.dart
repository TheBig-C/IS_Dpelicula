import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';  // Asegúrate de importar FirebaseAuth

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isDesktop;

  const CustomAppBar({Key? key, required this.isDesktop}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtiene el usuario actualmente autenticado
    final user = FirebaseAuth.instance.currentUser;

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
        if (user != null) ...[  // Verifica si el usuario está autenticado
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              context.goNamed('optionsPage');
            },
          ),
        ] else ...[  // Si no hay usuario autenticado, muestra el botón de Login
          TextButton(
            onPressed: () => context.goNamed('login'),
            child: Text("Login", style: TextStyle(color: Colors.white)),
          ),
        ],
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}