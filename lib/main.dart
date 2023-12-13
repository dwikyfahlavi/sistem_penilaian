import 'package:flutter/material.dart';
import 'package:sistem_penilaian/ui/login_activity.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: Colors.black,
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 30, color: Colors.black),
          titleSmall: TextStyle(fontSize: 20, color: Colors.black),
          bodyMedium: TextStyle(fontSize: 15, color: Colors.black),
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return const LoginActivity();
  }
}
