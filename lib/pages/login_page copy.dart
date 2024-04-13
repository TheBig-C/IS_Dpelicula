import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

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
              "Let's sign you in.",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
            ),
            const SizedBox(height: 20),
            const Text(
              "Welcome back.",
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
                  ? 'Please enter an email'
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
                  ? 'Enter min 6 characters'
                  : null,
              // obscuringCharacter: '*',
              decoration: InputDecoration(
                  labelText: "Password",
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                TextButton(
                  onPressed: () {
                    context.goNamed('register');
                  },
                  child: Text(
                    "Register",
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
                      onPressed: () {
                        final isValid = formKey.currentState!.validate();

                        if (!isValid) return;

                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => Center(
                                    child: CircularProgressIndicator(
                                  color: Theme.of(context).primaryColor,
                                )));

                        FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: emailController.text.trim(),
                                password: passwordController.text.trim())
                            .then((value) {
                          users.doc(value.user?.uid).get().then((value) {
                            final data = value.data() as Map<String, dynamic>;
                            BlocProvider.of<MoneyCubit>(context)
                                .getSelectedMoney(data['money']);
                          }).then((_) {
                            Navigator.of(context, rootNavigator: true).pop();
                            context.goNamed('home');
                          });
                        }).catchError((e) {
                          Navigator.of(context, rootNavigator: true).pop();

                          showTopSnackBar(Overlay.of(context) as OverlayState,
                              CustomSnackBar.error(message: e.message));
                        });
                      },
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 100, vertical: 14),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16))),
                      child: const Text(
                        "Login",
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
      appBar: AppBar(
        backgroundColor: const Color(0xff1C1C27),
        title: Text(
          "Dpelicula",
          style: TextStyle(color: Colors.white),
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
              onPressed: () => context.goNamed('aboutUs'),
              child: Text("Nosotros", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () => context.goNamed('contact'),
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
        ],
      ),
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
