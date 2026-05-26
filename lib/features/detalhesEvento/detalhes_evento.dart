import 'package:flutter/material.dart';
import 'package:voluntariapp/features/perfil/widgets/dies_nativitates.dart';
import 'package:voluntariapp/features/perfil/widgets/scripturam_arca.dart';
class DetalhesEvento extends StatelessWidget{
    const DetalhesEvento({super.key});

    //TODO: mudar quando implementar estado.
    final String teste = "Escreva aqui.";

    @override
    Widget build(BuildContext context){
        return Scaffold(
          body: SafeArea(
            child: Center(
              child: Container(
                color: Color(0xFFF9F9F9),
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 24, right: 24, top: 56, bottom: 28),
                child: Column(
                  children: [
                    Text("NOME DO EVENTO"),
                    Text("ONG organizadora"),
                  ],
                )
              ),
            )
          ),
           bottomNavigationBar: SafeArea(
            child: BottomNavigationBar(
              backgroundColor: Color(0xFFFFA500),
              currentIndex: 0,
              type: BottomNavigationBarType.fixed,
              showSelectedLabels: false,
              showUnselectedLabels: false,

              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_filled, color: Colors.white, size: 40),
                  label: 'Início',
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.white,
                    size: 40,
                  ),
                  label: 'Agenda',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.history, color: Colors.white, size: 40),
                  label: 'Histórico',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.logout, color: Colors.white, size: 40),
                  label: 'Sair',
                ),
              ],
            ),
          ),
        );
    }
}
