import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

class InactivityHandler extends StatefulWidget {
  final Widget child;
  final int inactivityTimeoutInSeconds;

  const InactivityHandler({
    Key? key,
    required this.child,
    this.inactivityTimeoutInSeconds = 3600, // tiempo por defecto de 1 hora
  }) : super(key: key);

  @override
  _InactivityHandlerState createState() => _InactivityHandlerState();
}

class _InactivityHandlerState extends State<InactivityHandler> {
  Timer? _inactivityTimer;

  @override
  void initState() {
    super.initState();
    resetInactivityTimer();
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    super.dispose();
  }

  void resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _inactivityTimer = Timer(Duration(seconds: widget.inactivityTimeoutInSeconds), logOutUser);
  }

  void logOutUser() {
    if (FirebaseAuth.instance.currentUser != null) {
      FirebaseAuth.instance.signOut();
      GoRouter.of(context).go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: resetInactivityTimer,
      onPanDown: (_) => resetInactivityTimer(),
      child: widget.child,
    );
  }
}
