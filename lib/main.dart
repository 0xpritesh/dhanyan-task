// lib/main.dart
import 'package:dhanyan/bloc/product_bloc.dart';
import 'package:dhanyan/data/repositories/product_repository.dart';

import 'package:dhanyan/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => PropertyRepository(),
      child: BlocProvider(
        create: (context) => PropertyBloc(context.read<PropertyRepository>()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Properties',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const SplashScreen(),
        ),
      ),
    );
  }
}
