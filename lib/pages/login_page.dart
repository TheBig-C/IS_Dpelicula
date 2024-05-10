import 'dart:async';

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
  bool passwordVisible = false;
  bool isButtonEnabled = true;
  int? remainingTime;
  Timer? countdownTimer;

  @override
  void dispose() {
    countdownTimer?.cancel();
    super.dispose();
  }

  void startTimer() {
    countdownTimer?.cancel();
    const oneSec = Duration(seconds: 1);
    remainingTime = 10;

    countdownTimer = Timer.periodic(oneSec, (Timer timer) {
      if (remainingTime == 0) {
        setState(() {
          timer.cancel();
          isButtonEnabled = true;
          remainingTime = null;
        });
      } else {
        setState(() {
          remainingTime = remainingTime! - 1;
        });
      }
    });
  }

  String?
      _verificationId; // Agrega esta variable a nivel de clase para almacenar el verificationId

  void sendVerificationCode(String phoneNumber) {
    FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          await FirebaseAuth.instance.signInWithCredential(credential);
          if (!mounted) {
            Navigator.of(context)
                .pop(); // Asegúrate de usar el Navigator correcto
            // Navegar a la página principal
          }
        } catch (e) {
          if (!mounted) {
            showTopSnackBar(
              Overlay.of(context)!,
              CustomSnackBar.error(
                  message: "Error al iniciar sesión: ${e.toString()}"),
            );
          }
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        if (!mounted) {
          Navigator.of(context).pop();
          showTopSnackBar(
            Overlay.of(context)!,
            CustomSnackBar.error(
                message: "Falló la verificación: ${e.message}"),
          );
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        if (!mounted) {
          showVerificationCodeDialog(context, verificationId);
        }
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  void showVerificationCodeDialog(BuildContext context, String verificationId) {
    TextEditingController codeController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Introduce el código de verificación'),
          content: TextField(
            controller: codeController,
            decoration: InputDecoration(
              labelText: 'Código SMS',
              hintText: '123456',
            ),
            keyboardType: TextInputType.number,
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(dialogContext)
                    .pop(); // Asegúrate de usar el context del diálogo aquí
              },
            ),
            TextButton(
              child: Text('Verificar'),
              onPressed: () async {
                final String smsCode = codeController.text.trim();
                await signInWithPhoneNumber(verificationId, smsCode);
                Navigator.of(dialogContext)
                    .pop(); // Cierra el diálogo antes de cualquier navegación o actualización de estado
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> signInWithPhoneNumber(
      String verificationId, String smsCode) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      if (!mounted) {
        Navigator.of(context).pushReplacementNamed('/home');
      }
    } catch (e) {
      if (!mounted) {
        showTopSnackBar(
          Overlay.of(context)!,
          CustomSnackBar.error(
              message: "Error verificando el código SMS: ${e.toString()}"),
        );
      }
    }
  }

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
              obscureText:
                  !passwordVisible, // Usar el estado para controlar la visibilidad
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) => value != null && value.length < 6
                  ? 'Introduzca mínimo 6 caracteres'
                  : null,
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
                    borderRadius: BorderRadius.circular(16)),
                suffixIcon: IconButton(
                  icon: Icon(
                    // Ícono cambia según el estado de visibilidad
                    passwordVisible ? Icons.visibility_off : Icons.visibility,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () {
                    // Cambiar el estado de visibilidad al presionar el ícono
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => GoRouter.of(context).push('/reset_password'),
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
            Text(
              remainingTime != null
                  ? 'Espera ${remainingTime! ~/ 60}:${(remainingTime! % 60).toString().padLeft(2, '0')} para volver a intentar'
                  : '',
              style: TextStyle(color: Colors.red, fontSize: 16),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BlocBuilder<MoneyCubit, MoneyState>(
                  builder: (context, state) {
                    return ElevatedButton(
                      onPressed: isButtonEnabled
                          ? () async {
                              final isValid = formKey.currentState!.validate();
                              if (!isValid) return;

                              final emailTrimmed = emailController.text.trim();
                              final passwordTrimmed =
                                  passwordController.text.trim();
                              final queryDate = DateFormat('yyyy-MM-dd')
                                  .format(DateTime.now());

                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => Center(
                                    child: CircularProgressIndicator(
                                        color: Theme.of(context).primaryColor)),
                              );

                              try {
                                // Obtener registros de intentos fallidos del día actual
                                final failedAttemptsQuery = await activities
                                    .where('user', isEqualTo: emailTrimmed)
                                    .where('activity',
                                        isEqualTo:
                                            'Intento de Inicio de sesión fallido')
                                    .where('date', isEqualTo: queryDate)
                                    .get();

                                // Definir y actualizar la cantidad de intentos fallidos
                                int failedAttempts =
                                    failedAttemptsQuery.docs.length;

                                if (failedAttempts >= 3) {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  showTopSnackBar(
                                    Overlay.of(context)!,
                                    CustomSnackBar.error(
                                      message:
                                          "Has excedido el número máximo de intentos de inicio de sesión para hoy. Inténtalo mañana.",
                                    ),
                                  );
                                  return;
                                }

                                UserCredential userCredential =
                                    await FirebaseAuth.instance
                                        .signInWithEmailAndPassword(
                                  email: emailTrimmed,
                                  password: passwordTrimmed,
                                );

                                if (!userCredential.user!.emailVerified) {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  GoRouter.of(context).push('/verify_email',
                                      extra: userCredential.user!.email);
                                  await activities.add({
                                    'user': userCredential.user!.email,
                                    'activity':
                                        'Inicio de sesión exitoso y redirigido a verificar email',
                                    'date': queryDate,
                                    'hour': DateFormat('HH:mm:ss')
                                        .format(DateTime.now()),
                                  });
                                  return;
                                }

                                if (!mounted) return;

                                // // Retrieving user data and casting to Map<String, dynamic>
                                // DocumentSnapshot userDoc =
                                //     await FirebaseFirestore.instance
                                //         .collection('users')
                                //         .doc(userCredential.user!.uid)
                                //         .get();
                                DocumentSnapshot userDoc =
                                    await FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(userCredential.user!.uid)
                                        .get();
                                Map<String, dynamic> userData =
                                    userDoc.data()! as Map<String, dynamic>;

                                // Comprobando si la contraseña es igual al CI del usuario, si existe el campo CI
                                if (userData.containsKey('CI') &&
                                    userData['CI'] != null &&
                                    passwordTrimmed == userData['CI']) {
                                  Navigator.of(context, rootNavigator: true)
                                      .pop();
                                  GoRouter.of(context).push('/reset_password');
                                  await activities.add({
                                    'user': userCredential.user!.email,
                                    'activity':
                                        'Inicio de sesión exitoso y redirigido a restablecer contraseña',
                                    'date': queryDate,
                                    'hour': DateFormat('HH:mm:ss')
                                        .format(DateTime.now()),
                                  });
                                  return;
                                }
                                // if (!mounted) return;
                                // if (userData.containsKey('phone') &&
                                //     userData['phone'] != null) {
                                //   sendVerificationCode(userData['phone']);
                                // } else {
                                //   // Error, no hay número de teléfono
                                //   showTopSnackBar(
                                //     Overlay.of(context)!,
                                //     CustomSnackBar.error(
                                //         message:
                                //             "No se encontró el número de teléfono asociado."),
                                //   );
                                // }

                                await activities.add({
                                  'user': userCredential.user!.email,
                                  'activity': 'Inicio de sesión exitoso',
                                  'date': queryDate,
                                  'hour': DateFormat('HH:mm:ss')
                                      .format(DateTime.now()),
                                });

                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                context.goNamed('home');
                              } catch (e) {
                                print(e.toString());
                                if (!mounted) return;
                                Navigator.of(context, rootNavigator: true)
                                    .pop();

                                // Debe volver a consultar el número de intentos fallidos en caso de excepción.
                                final currentFailedAttemptsQuery = await activities
                                    .where('user', isEqualTo: emailTrimmed)
                                    .where('activity',
                                        isEqualTo:
                                            'Intento de Inicio de sesión fallido')
                                    .where('date', isEqualTo: queryDate)
                                    .get();
                                int currentFailedAttempts =
                                    currentFailedAttemptsQuery.docs.length + 1;

                                await activities.add({
                                  'user': emailTrimmed,
                                  'activity':
                                      'Intento de Inicio de sesión fallido',
                                  'date': queryDate,
                                  'hour': DateFormat('HH:mm:ss')
                                      .format(DateTime.now()),
                                });

                                if (currentFailedAttempts == 2) {
                                  setState(() {
                                    isButtonEnabled = false;
                                    startTimer();
                                  });
                                  showTopSnackBar(
                                    Overlay.of(context)!,
                                    CustomSnackBar.error(
                                      message:
                                          "Tienes que esperar 15 minutos antes de intentar iniciar sesión nuevamente.",
                                    ),
                                  );
                                } else if (currentFailedAttempts >= 3) {
                                  showTopSnackBar(
                                    Overlay.of(context)!,
                                    CustomSnackBar.error(
                                      message:
                                          "Has excedido el número máximo de intentos de inicio de sesión para hoy. Inténtalo mañana.",
                                    ),
                                  );
                                } else {
                                  showTopSnackBar(
                                    Overlay.of(context)!,
                                    CustomSnackBar.error(
                                      message:
                                          "El correo o contraseña es incorrecto. Intentos restantes: ${3 - currentFailedAttempts}",
                                    ),
                                  );
                                }
                              }
                            }
                          : null,
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
