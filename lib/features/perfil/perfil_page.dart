import 'package:flutter/material.dart';
import 'package:voluntariapp/features/perfil/widgets/dies_nativitates.dart';
import 'package:voluntariapp/features/perfil/widgets/scripturam_arca.dart';
class PerfilPage extends StatelessWidget{
    const PerfilPage({super.key});

    //TODO: mudar quando implementar estado.
    final String teste = "Escreva aqui.";

    @override
    Widget build(BuildContext context){
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 24, right: 24, top: 56, bottom: 28),
                child: Column(
                  children: [
                    Icon(Icons.account_box, size: 96,),
                    DiesNativitates(),
                    SizedBox(height: 49),
                    ScripturamArca(
                      label: "Sobre Mim",
                      content: teste,
                    ),
                    SizedBox(height: 49),
                    ScripturamArca(
                      label: "Experiências",
                      content: teste,
                    )
                  ],
                )
              ),
            )
          ),
        );
    }
}
