import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class EmailVerificationPage extends StatelessWidget {
  final String email;
  const EmailVerificationPage({Key? key, required this.email}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendVerificationEmail(context);
    });

    bool isDesktop = MediaQuery.of(context).size.width > 800;

    Widget verificationForm = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Verificar Email",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
          ),
          const SizedBox(height: 20),
          Text(
            "Email: $email",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text(
            "Por favor verifica tu correo electrónico para continuar.",
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 60),
          // ElevatedButton(
          //   onPressed: () => _sendVerificationEmail(context),
          //   style: ElevatedButton.styleFrom(
          //     padding: const EdgeInsets.symmetric(horizontal: 90, vertical: 14),
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(16),
          //     ),
          //   ),
          //   child: const Text(
          //     "Reenviar Email",
          //     style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          //   ),
          // ),
        ],
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: isDesktop
            ? Center(child: SizedBox(width: 400, child: verificationForm))
            : ListView(children: [verificationForm]),
      ),

      drawer: !isDesktop
          ? Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: BoxDecoration(color: Colors.blue),
                    child: Text(
                      'Menú',
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  ListTile(
                    title: const Text('Inicio'),
                    onTap: () {
                      GoRouter.of(context).go('/home');
                    },
                  ),
                  ListTile(
                    title: const Text('Nosotros'),
                    onTap: () {
                      GoRouter.of(context).go('/aboutUs');
                    },
                  ),
                  ListTile(
                    title: const Text('Contáctanos'),
                    onTap: () {
                      GoRouter.of(context).go('/contact');
                    },
                  ),
                ],
              ),
            )
          : null,
    );
  }

  void _sendVerificationEmail(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        showTopSnackBar(
          Overlay.of(context)!,
          const CustomSnackBar.success(
            message: "Email de verificación enviado con éxito.",
          ),
        );
        FirebaseAuth.instance.signOut();
      } else {
        showTopSnackBar(
          Overlay.of(context)!,
          const CustomSnackBar.info(
            message: "El email ya ha sido verificado o el usuario no está logueado.",
          ),
        );
      }
    } catch (e) {
      showTopSnackBar(
        Overlay.of(context)!,
        CustomSnackBar.error(
          message: "Error al enviar el email de verificación: ${e.toString()}",
        ),
      );
    }
  }
}
