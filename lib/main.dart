import 'package:flutter/material.dart';
import 'package:voluntariapp/features/detalhesEvento/detalhes_evento.dart';
import 'package:voluntariapp/features/perfil/perfil_page.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoluntariAPP',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.blue)),
      home: const DetalhesEvento(),
    );
  }
}