import 'package:flutter/material.dart';
import 'package:voluntariapp/features/agenda/pages/agenda.dart';
import 'package:voluntariapp/features/home/pages/home.dart';
import 'package:voluntariapp/features/notificacoes/pages/notificacoes.dart';
import 'package:voluntariapp/features/history/pages/history_page.dart';

class BottomMenu extends StatelessWidget {
  const BottomMenu();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      color: const Color(0xFFFFA500),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
              },
              icon: const Icon(Icons.home, color: Colors.white, size: 32),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Agenda()),
                );
              },
              icon: const Icon(
                Icons.calendar_month_outlined,
                color: Colors.white,
                size: 32,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryPage()),
                );
              },
              icon: const Icon(Icons.history, color: Colors.white, size: 36),
            ),
            const Icon(Icons.logout, color: Colors.white, size: 34),
          ],
        ),
      ),
    );
  }
}
