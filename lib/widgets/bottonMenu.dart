import 'package:flutter/material.dart';
import 'package:voluntariapp/features/agenda/pages/agenda.dart';
import 'package:voluntariapp/features/history/pages/history_page.dart';
import 'package:voluntariapp/features/home/pages/home.dart';
import 'package:voluntariapp/features/login/pages/login_page.dart';
import 'package:voluntariapp/services/auth_service.dart';

class BottomMenu extends StatelessWidget {
  const BottomMenu({super.key});

  Future<void> _logout(BuildContext context) async {
    await AuthService().signOut();
    if (!context.mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
      (_) => false,
    );
  }

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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
              },
              icon: const Icon(Icons.home, color: Colors.white, size: 32),
            ),
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
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
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HistoryPage()),
                );
              },
              icon: const Icon(Icons.history, color: Colors.white, size: 36),
            ),
            IconButton(
              onPressed: () => _logout(context),
              icon: const Icon(Icons.logout, color: Colors.white, size: 34),
            ),
          ],
        ),
      ),
    );
  }
}
