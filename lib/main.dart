import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:is_dpelicula/controllers/function_controller.dart';
import 'package:is_dpelicula/controllers/movie_controllers.dart';
import 'package:is_dpelicula/pages/auth/forgot_pw_page.dart';
import 'package:is_dpelicula/pages/auth/login_page%20copy.dart';
import 'package:is_dpelicula/pages/auth/register_employee.dart';
import 'package:is_dpelicula/pages/auth/register_page.dart';
import 'package:is_dpelicula/pages/auth/verify_email.dart';
import 'package:is_dpelicula/pages/movies/movie_detail_page.dart';
import 'package:is_dpelicula/pages/movies/register_movie_page.dart';
import 'package:is_dpelicula/pages/options_page.dart';
import 'package:is_dpelicula/pages/tickets/FunctionDatailsPage.dart';
import 'package:is_dpelicula/pages/tickets/TicketPurchasePage.dart';

import 'package:go_router/go_router.dart';
import 'package:is_dpelicula/cubit/money_cubit.dart';
import 'package:is_dpelicula/cubit/movies_cubit.dart';
import 'package:is_dpelicula/firebase_options.dart';
import 'package:is_dpelicula/models/utils.dart';
import 'package:is_dpelicula/pages/contact_page.dart';
import 'package:is_dpelicula/pages/home_page.dart';

import 'package:is_dpelicula/pages/about_us.dart';
import 'package:is_dpelicula/pages/room/RegisteredRoomsPage.dart';
import 'package:is_dpelicula/pages/room/roomCreationPage.dart';
import 'package:is_dpelicula/pages/users/control_client.dart';
import 'package:is_dpelicula/pages/users/control_employee.dart';
import 'package:is_dpelicula/pages/users/profile_edit_page.dart';
import 'package:is_dpelicula/pages/users/profile_page.dart';
import 'package:is_dpelicula/widgets/loading_spinner.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(
          child: MyApp()) // Asegúrate de envolver MyApp con ProviderScope
      );
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
    GoRoute(
      path: '/aboutUs',
      name: 'aboutUs',
      builder: (context, state) {
        return AboutUsPage();
      },
    ),
    GoRoute(
      path: '/contact',
      name: 'contact',
      builder: (context, state) {
        return const ContactPage();
      },
    ),
    GoRoute(
      path: '/options',
      name: 'optionsPage',
      builder: (context, state) {
        return OptionsPage();
      },
    ),
    GoRoute(
      path: '/register_employee',
      name: 'registerEmployee',
      builder: (context, state) {
        return const RegisterEmployee();
      },
    ),
    GoRoute(
      path: '/register_movie',
      name: 'registerMovie',
      builder: (context, state) {
        return RegisterMovie();
      },
    ),
    GoRoute(
      path: '/movie/:id',
      builder: (BuildContext context, GoRouterState state) {
        final String id = state.pathParameters['id']!;
        return MovieDetailPage(movieId: id);
      },
    ),
    GoRoute(
      path: '/verify_email',
      name: 'verifyEmail',
      builder: (context, state) {
        final email = state.extra as String?;
        if (email == null) {
          return const LoadingSpinner();
        }
        return EmailVerificationPage(email: email);
      },
    ),
    GoRoute(
      path: '/reset_password',
      name: 'resetPassword',
      builder: (context, state) {
        return ForgotPasswordPage();
      },
    ),
    GoRoute(
      path: '/control_employee',
      name: 'controlEmployee',
      builder: (context, state) {
        return ControlEmployee();
      },
    ),
    GoRoute(
      path: '/control_client',
      name: 'controlClient',
      builder: (context, state) {
        return ControlClient();
      },
    ),
    GoRoute(
        path: '/profile',
        name: 'profile',
        pageBuilder: (context, state) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: ProfilePage(),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity:
                    CurveTween(curve: Curves.easeInOutCirc).animate(animation),
                child: child,
              );
            },
          );
        },
        routes: [
          GoRoute(
            path: 'edit',
            name: 'edit',
            builder: (context, state) {
              return const ProfileEditPage();
            },
          ),
        ]),
    GoRoute(
      path: '/create-room',
      name: 'createRoom',
      builder: (context, state) {
        return const RoomCreationPage();
      },
    ),
    GoRoute(
      path: '/registered_rooms',
      name: 'registeredRooms',
      builder: (context, state) {
        return RegisteredRoomsPage();
      },
    ),
    GoRoute(
      path: '/function/:id',
      builder: (BuildContext context, GoRouterState state) {
        final String id = state.pathParameters['id']!;
        return Consumer(
          builder: (context, ref, child) {
            final functionCineFuture = ref.watch(functionCineProvider(id));
            return functionCineFuture.when(
              data: (functionCine) {
                final movieFuture = ref.watch(movieProviderFamily(functionCine.movieId));
                return movieFuture.when(
                  data: (movie) => FunctionDetailsPage(function: functionCine, movie: movie),
                  loading: () => const LoadingSpinner(),
                  error: (error, stackTrace) => Center(child: Text('Error: $error')),
                );
              },
              loading: () => const LoadingSpinner(),
              error: (error, stackTrace) => Center(child: Text('Error: $error')),
            );
          },
        );
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
