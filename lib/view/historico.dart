import 'package:flutter/material.dart';

class Historico extends StatefulWidget {
  const Historico({super.key});

  @override
  State<Historico> createState() => _HistoricoState();
}

class _HistoricoState extends State<Historico> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(
          Icons.arrow_circle_left_outlined,
          color: Color(0xFFFFA500),
          size: 40,
        ),
        //DDE9FF cor background
        backgroundColor: Colors.transparent,
        title: const Text(
          'Histórico',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        centerTitle: true,

        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_outlined,
              color: Color(0xFFFFA500),
              size: 28,
            ),
            tooltip: 'Ver notificações',
            onPressed: () {
              // lógica do botão
            },
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Color(0xFFFFA500), size: 40),
            tooltip: 'Página de Perfil',
            onPressed: () {
              // lógica do botão
            },
          ),
        ],
      ),
      body: Container(),

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
              icon: Icon(Icons.calendar_today_outlined, color: Colors.white, size: 40),
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
