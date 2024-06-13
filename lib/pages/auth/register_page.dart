import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:is_dpelicula/widgets/custom_app_bar.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool passwordVisible = false;

  @override
  Widget build(BuildContext context) {
    bool isDesktop = MediaQuery.of(context).size.width > 800;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');

    Widget registerForm = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Vamos a Registrarte",
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
              cursorColor: const Color(0xfff4b33c),
              style: const TextStyle(color: Colors.white70, fontSize: 18),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (email) => email != null && email.isEmpty
                  ? 'Por favor introduzca un email'
                  : null,
              decoration: _inputDecoration("Email"),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: passwordController,
              textInputAction: TextInputAction.next,
              cursorColor: const Color(0xfff4b33c),
              style: const TextStyle(color: Colors.white70, fontSize: 18),
              obscureText:
                  !passwordVisible, // Usar el estado para controlar la visibilidad
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, introduzca una contraseña';
                } else if (value.length < 6) {
                  return 'La contraseña debe tener al menos 6 caracteres';
                } else if (!RegExp(r'[A-Z]').hasMatch(value)) {
                  return 'La contraseña debe contener al menos \nuna letra mayúscula';
                } else if (!RegExp(r'[a-z]').hasMatch(value)) {
                  return 'La contraseña debe contener al menos \nuna letra minúscula';
                } else if (!RegExp(r'[0-9]').hasMatch(value)) {
                  return 'La contraseña debe contener al menos un número';
                } else if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
                  return 'La contraseña debe contener al menos \nun carácter especial (!@#\$&*~)';
                }
                return null; // si todos los chequeos pasan, retorna null que significa que el input es válido
              },
              decoration: _inputDecoration("Contraseña").copyWith(
                suffixIcon: IconButton(
                  icon: Icon(
                    passwordVisible ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xfff4b33c),
                  ),
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: confirmPasswordController,
              textInputAction: TextInputAction.done,
              cursorColor: const Color(0xfff4b33c),
              style: const TextStyle(color: Colors.white70, fontSize: 18),
              obscureText:
                  !passwordVisible, // Usar el estado para controlar la visibilidad
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) =>
                  value != null && value != passwordController.text
                      ? 'Las contraseñas no coinciden'
                      : null,
              decoration: _inputDecoration("Confirmar contraseña").copyWith(
                suffixIcon: IconButton(
                  icon: Icon(
                    passwordVisible ? Icons.visibility_off : Icons.visibility,
                    color: const Color(0xfff4b33c),
                  ),
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Tienes una cuenta?",
                  style: TextStyle(color: Colors.white70, fontSize: 16),
                ),
                TextButton(
                  onPressed: () {
                    context.goNamed('login');
                  },
                  child: Text(
                    "Iniciar Sesión",
                    style:
                        TextStyle(color: const Color(0xfff4b33c), fontSize: 16),
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    final isValid = formKey.currentState!.validate();
                    if (!isValid) return;
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => Center(
                            child: CircularProgressIndicator(
                                color: const Color(0xfff4b33c))));

                    FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: emailController.text.trim(),
                            password: passwordController.text.trim())
                        .then((userCredential) {
                      // Almacenar información del usuario en Firestore
                      return users.doc(userCredential.user!.uid).set({
                        'money': 0,
                        'name': null,
                        'CI': null,
                        'email': userCredential.user!.email,
                        'phone': null,
                        'address': null,
                        'role': 'client',
                      }).then((_) => userCredential
                          .user!.email); // Pasar el email al siguiente then
                    }).then((email) {
                      // Cierre del diálogo de progreso
                      Navigator.of(context, rootNavigator: true).pop();
                      // Mostrar notificación de éxito
                      showTopSnackBar(
                          Overlay.of(context) as OverlayState,
                          const CustomSnackBar.success(
                              message: 'Su cuenta se creó correctamente'));
                      // Redireccionar a la página de verificación de email
                      GoRouter.of(context).push('/verify_email', extra: email);
                    }).catchError((e) {
                      // Cierre del diálogo de progreso en caso de error
                      Navigator.of(context, rootNavigator: true).pop();
                      // Mostrar notificación de error
                      showTopSnackBar(
                          Overlay.of(context) as OverlayState,
                          CustomSnackBar.error(
                              message: "Ocurrió un error al registrarse"));
                    });
                  },
                  style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 90, vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16))),
                  child: const Text(
                    "Registrarse",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: isDesktop
            ? Center(child: SizedBox(width: 400, child: registerForm))
            : ListView(children: [registerForm]),
      ),
      appBar: CustomAppBar(
        isDesktop: isDesktop,
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

  InputDecoration _inputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      floatingLabelStyle:
          const TextStyle(color: Color(0xfff4b33c), fontSize: 22),
      labelStyle: const TextStyle(
          color: Color(0xfff4b33c), fontSize: 16, fontWeight: FontWeight.w500),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xfff4b33c)),
        borderRadius: BorderRadius.circular(16),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xfff4b33c)),
        borderRadius: BorderRadius.circular(16),
      ),
      border: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xfff4b33c)),
        borderRadius: BorderRadius.circular(16),
      ),
    );
  }
}
