import 'package:flutter/material.dart';
import 'package:voluntariapp/features/perfil/widgets/bullam_retro.dart';
import 'package:voluntariapp/features/perfil/widgets/dies_nativitates.dart';
import 'package:voluntariapp/features/perfil/widgets/imago_profili.dart';
import 'package:voluntariapp/features/perfil/widgets/navigationis.dart';
import 'package:voluntariapp/features/perfil/widgets/scripturam_arca.dart';
class PerfilPage extends StatelessWidget{
    const PerfilPage({super.key});

    //TODO: mudar quando implementar estado.
    final String teste = "Escreva aqui.";

    @override
    Widget build(BuildContext context){
        return Scaffold(
          backgroundColor: Color(0xFFDDE9FF),
          body: SafeArea(
            child: Center(
              child: Container(
                width: 550,
                height: 850,
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
                    Row(children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          shape:BoxShape.circle,
                        ),
                        child: BullamRetro(),
                      )
                    ],),
                    ImagoProfili(),
                    SizedBox(height: 49),
                    ScripturamArca(
                      label: "Nome",
                      content: "Ocupação",
                    ),
                    SizedBox(height: 25),
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
           bottomNavigationBar: SafeArea(
            child: Navigationis(),
          ),
        );
    }
}
