import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:voluntariapp/firebase_options.dart';
import 'features/cadastro/pages/tipo_perfil_page.dart';

import 'features/login/pages/login_page.dart';

void main()  async{
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VoluntariAPP',
      theme:
          ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)),
      home: const LoginPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
