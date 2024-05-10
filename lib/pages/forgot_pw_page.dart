import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:is_dpelicula/widgets/custom_app_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../cubit/money_cubit.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();

  void resetPassword() {
    final email = emailController.text.trim();
    if (email.isEmpty) {
      showTopSnackBar(
        Overlay.of(context)!,
        CustomSnackBar.error(
          message: "Por favor, ingrese un correo electrónico válido.",
        ),
      );
      return;
    }

    FirebaseAuth.instance.sendPasswordResetEmail(email: email).then((_) {
      showTopSnackBar(
        Overlay.of(context)!,
        CustomSnackBar.success(
          message:
              "Se ha enviado un enlace de restablecimiento a su correo electrónico.",
        ),
      );
      // Añade un pequeño retraso para asegurar que el usuario pueda leer el mensaje
      Future.delayed(const Duration(seconds: 2), () {
        // Verifica si la navegación es correcta según la configuración de tus rutas
        GoRouter.of(context).go('/login');
      });
    }).catchError((e) {
      showTopSnackBar(
        Overlay.of(context)!,
        CustomSnackBar.error(
          message: "Ocurrio un error inesperado",
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;

    Widget resetForm = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Restablecer contraseña",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: 'Correo electrónico',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) => value != null && value.isEmpty
                  ? 'Ingrese su correo electrónico'
                  : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: resetPassword,
              child: const Text('Restablecer Contraseña'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: isDesktop
            ? Center(child: SizedBox(width: 400, child: resetForm))
            : ListView(children: [resetForm]),
      ),
      appBar: CustomAppBar(isDesktop: isDesktop),
      drawer: !isDesktop
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: Colors.blue),
                    child: Text('Menú',
                        style: TextStyle(color: Colors.white, fontSize: 24)),
                  ),
                  ListTile(
                    title: const Text('Inicio'),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.goNamed('home');
                    },
                  ),
                  ListTile(
                    title: const Text('Nosotros'),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.goNamed('aboutUs');
                    },
                  ),
                  ListTile(
                    title: const Text('Contáctanos'),
                    onTap: () {
                      Navigator.of(context).pop();
                      context.goNamed('contact');
                    },
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
