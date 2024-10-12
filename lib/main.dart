import 'package:todo/core/cubit/cubit.dart';
import 'package:todo/task/task.dart';
import 'package:flutter/material.dart';
import 'package:todo/layouts/home_layout.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  // runApp(const MyTask());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: ThemeData.dark(),
      home: HomeScreen(),
    );
  }
}