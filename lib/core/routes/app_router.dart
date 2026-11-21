import 'package:flutter/material.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String books = '/books';
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void redirectToLogin() {
  navigatorKey.currentState?.pushNamedAndRemoveUntil(
    AppRoutes.login,
    (_) => false,
  );
}
