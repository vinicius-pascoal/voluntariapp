import 'package:flutter/material.dart';

class HistoryBottomNavigation extends StatelessWidget {
  const HistoryBottomNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,

      child: BottomNavigationBar(
        backgroundColor: const Color(0xFFFFA500),
        currentIndex: 2,
        type: BottomNavigationBarType.fixed,

        showSelectedLabels: false,
        showUnselectedLabels: false,

        iconSize: 30,

        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,

        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled),
            label: 'Início',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            label: 'Agenda',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Histórico',
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Sair',
          ),
        ],
      ),
    );
  }
}