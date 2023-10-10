import 'package:flutter/material.dart';
import 'predict_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seedColor = Color.fromARGB(255, 255, 128, 132);
    return MaterialApp(
      title: 'Flutter PyTorch Sample',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        useMaterial3: true,
      ),
      home: const PredictPage(),
    );
  }
}
