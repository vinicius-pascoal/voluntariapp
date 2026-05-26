import 'package:flutter/material.dart';

class Navigationis extends StatelessWidget {
  const Navigationis({super.key});

  @override
  Widget build(BuildContext context) {
    return  BottomNavigationBar(
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
      );
  }
}
