import 'package:flutter/material.dart';
import 'package:voluntariapp/features/perfil/widgets/navigationis.dart';
import 'package:voluntariapp/features/perfil/widgets/scripturam_arca.dart';

class DetalhesEvento extends StatelessWidget {
  const DetalhesEvento({super.key});

  //TODO: mudar quando implementar estado.
  final String teste = "Escreva aqui.";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Container(
            color: Color(0xFFF9F9F9),
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 24, right: 24, top: 56, bottom: 28),
            child: Column(
              children: [Text("NOME DO EVENTO"), Text("ONG organizadora")],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const SafeArea(
        child: Navigationis(),
      ),
    );
  }
}
