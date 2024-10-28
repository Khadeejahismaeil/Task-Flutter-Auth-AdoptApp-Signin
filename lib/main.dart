import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './providers/auth_provider.dart';
import './providers/pets_provider.dart';
import './pages/signin_page.dart';
import './pages/home_page.dart';
import './pages/add_page.dart';
import './pages/signup_page.dart';
import './pages/update_page.dart';
import 'package:go_router/go_router.dart';

void main() async {
  AuthProvider authProvider = AuthProvider();
  await authProvider.loadToken();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authProvider),
        ChangeNotifierProvider(create: (_) => PetsProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  final GoRouter _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/signin',
        builder: (context, state) => SigninPage(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => SignupPage(),
      ),
      GoRoute(
        path: '/add',
        builder: (context, state) => AddPage(),
      ),
      GoRoute(
        path: '/update/:petId',
        builder: (context, state) {
          final pet = Provider.of<PetsProvider>(context, listen: false)
              .pets
              .firstWhere((pet) => pet.id.toString() == state.params['petId']);
          return UpdatePage(pet: pet);
        },
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerDelegate: _router.routerDelegate,
      routeInformationParser: _router.routeInformationParser,
      title: 'Pets Adoption App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}
