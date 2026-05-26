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
      backgroundColor: Color(0xFFDDE9FF),
      body: SafeArea(
        child: Center(
          child: Container(
            width: 500,
            height: 750,
            decoration: BoxDecoration(
              color: Color(0xFFF9F9F9),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: Offset(0, 4),
              )]
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 24, right: 24, top: 56, bottom: 28),
            child: Column(
              children: [
                Text("NOME DO EVENTO"), 
                Text("ONG organizadora"),
                
              ],
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
