import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:go_router/go_router.dart';
import 'package:is_dpelicula/cubit/money_cubit.dart';
import 'package:is_dpelicula/cubit/movies_cubit.dart';
import 'package:is_dpelicula/firebase_options.dart';
import 'package:is_dpelicula/models/utils.dart';
import 'package:is_dpelicula/pages/home_page.dart';
import 'package:is_dpelicula/pages/login_page.dart';
import 'package:is_dpelicula/pages/register_page.dart'; // Asegúrate de usar la ruta correcta al archivo

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Utiliza las opciones configuradas
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final GoRouter router = GoRouter(routes: [
    GoRoute(
      path: '/home',
      name: 'home',
      pageBuilder: (context, state) {
        return CustomTransitionPage(
          key: state.pageKey,
          child: const HomePage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity:
                  CurveTween(curve: Curves.easeInOutCirc).animate(animation),
              child: child,
            );
          },
        );
      },
    ),
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) {
        return const LoginPage();
      },
    ),
    GoRoute(
      path: '/register',
      name: 'register',
      builder: (context, state) {
        return const RegisterPage();
      },
    ),
  ], initialLocation: '/home');

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MoviesCubit>(
          create: (context) => MoviesCubit(),
        ),
        BlocProvider<MoneyCubit>(
          create: (context) => MoneyCubit(),
        )
      ],
      child: MaterialApp.router(
        theme: ThemeData(
            primaryColor: const Color(0xfff4b33c),
            scaffoldBackgroundColor: const Color(0xff1C1C27),
            iconTheme: const IconThemeData(color: Color(0xffa6a6a6), size: 36),
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(const Color(0xfff4b33c)),
                    foregroundColor:
                        MaterialStateProperty.all(const Color(0xff222222)),
                    shape: MaterialStateProperty.all(const StadiumBorder()))),
            textTheme: Theme.of(context)
                .textTheme
                .apply(bodyColor: Colors.white, fontFamily: 'Inter')),
        debugShowCheckedModeBanner: false,
        routeInformationParser: router.routeInformationParser,
        routeInformationProvider: router.routeInformationProvider,
        routerDelegate: router.routerDelegate,
        scaffoldMessengerKey: Utils.messengerKey,
      ),
    );
  }
}
