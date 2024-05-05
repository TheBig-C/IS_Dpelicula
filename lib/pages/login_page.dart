import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:is_dpelicula/pages/forgot_pw_page.dart';
import 'package:is_dpelicula/widgets/custom_app_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:intl/intl.dart';

import '../cubit/money_cubit.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');
    CollectionReference activities = firestore.collection('activity');
    bool isDesktop = MediaQuery.of(context).size.width > 800;

    Widget loginForm = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Text(
              "Inicio de sesión",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            const SizedBox(height: 20),
            const Text(
              "Bienvenido",
              style: TextStyle(fontSize: 26),
            ),
            const SizedBox(height: 60),
            TextFormField(
              controller: emailController,
              textInputAction: TextInputAction.next,
              cursorColor: Theme.of(context).primaryColor,
              style: const TextStyle(color: Colors.white70, fontSize: 18),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) => email != null && email.isEmpty
                  ? 'Ingrese un email pofavor'
                  : null,
              decoration: InputDecoration(
                  labelText: "Email",
                  floatingLabelStyle:
                      const TextStyle(color: Colors.white54, fontSize: 22),
                  labelStyle: const TextStyle(
                      color: Colors.white38,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white24),
                      borderRadius: BorderRadius.circular(16)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(16)),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white70),
                      borderRadius: BorderRadius.circular(16))),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              textInputAction: TextInputAction.done,
              cursorColor: Theme.of(context).primaryColor,
              style: const TextStyle(color: Colors.white70, fontSize: 18),
              obscureText: true,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value != null && value.length < 6
                  ? 'Introduzca minimo 6 caracteres'
                  : null,
              // obscuringCharacter: '*',
              decoration: InputDecoration(
                  labelText: "Contraseña",
                  floatingLabelStyle:
                      const TextStyle(color: Colors.white54, fontSize: 22),
                  labelStyle: const TextStyle(
                      color: Colors.white38,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white24),
                      borderRadius: BorderRadius.circular(16)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(16)),
                  border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white70),
                      borderRadius: BorderRadius.circular(16))),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) {
                      return ForgotPasswordPage();
                    }),
                  ),
                ),
                child: Text(
                  "¿Olvidaste tu contraseña?",
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "No tienes una cuenta?",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                TextButton(
                  onPressed: () {
                    context.goNamed('register');
                  },
                  child: Text(
                    "Registrarse",
                    style: TextStyle(
                        color: Theme.of(context).primaryColor, fontSize: 16),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<MoneyCubit, MoneyState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: () async {
                        final isValid = formKey.currentState!.validate();
                        if (!isValid) return;

                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => Center(
                              child: CircularProgressIndicator(
                                  color: Theme.of(context).primaryColor)),
                        );

                        try {
                          UserCredential userCredential = await FirebaseAuth
                              .instance
                              .signInWithEmailAndPassword(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim(),
                          );

                          if (!mounted)
                            return; // Check if the widget is still in the tree
                          DocumentSnapshot userData =
                              await users.doc(userCredential.user!.uid).get();
                          Map<String, dynamic> userDataMap =
                              userData.data() as Map<String, dynamic>;
                          String userCI = userDataMap['CI'];

                          // Log the login activity
                          await activities.add({
                            'user': userCredential.user!.email,
                            'activity': 'Inicio de sesión',
                            'date':
                                DateFormat('yyyy-MM-dd').format(DateTime.now()),
                            'hour':
                                DateFormat('HH:mm:ss').format(DateTime.now()),
                          });

                          if (!mounted)
                            return; // Check again before interacting with the context
                          if (passwordController.text.trim() == userCI) {
                            Navigator.of(context)
                                .pop(); // Close the progress dialog
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ForgotPasswordPage()));
                          } else {
                            Navigator.of(context, rootNavigator: true)
                                .pop(); // Close the progress dialog
                            context.goNamed(
                                'home'); // Redirect to home if password is not CI
                          }
                        } catch (e) {
                          if (!mounted) return;
                          Navigator.of(context, rootNavigator: true)
                              .pop(); // Close the progress dialog
                          // Log failed login attempt
                          await activities.add({
                            'user': emailController.text
                                .trim(), // Using email here, adjust based on your privacy policy
                            'activity': 'Intento de Inicio de sesión fallido',
                            'date':
                                DateFormat('yyyy-MM-dd').format(DateTime.now()),
                            'hour':
                                DateFormat('HH:mm:ss').format(DateTime.now()),
                          });
                          if (e is FirebaseAuthException) {
                            showTopSnackBar(
                              Overlay.of(context)!,
                              CustomSnackBar.error(
                                message: e.message ?? "An error occurred",
                              ),
                            );
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 100, vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16))),
                      child: const Text(
                        "Iniciar Sesión",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: isDesktop
            ? Center(child: SizedBox(width: 400, child: loginForm))
            : ListView(children: [loginForm]),
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
