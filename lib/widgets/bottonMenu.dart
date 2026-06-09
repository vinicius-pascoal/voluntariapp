import 'package:flutter/material.dart';
import 'package:voluntariapp/features/agenda/pages/agenda.dart';
import 'package:voluntariapp/features/history/pages/history_page.dart';
import 'package:voluntariapp/features/home/pages/home.dart';
import 'package:voluntariapp/features/login/pages/login_page.dart';
import 'package:voluntariapp/services/auth_service.dart';

class BottomMenu extends StatefulWidget {
  const BottomMenu({super.key});

  @override
  State<BottomMenu> createState() => _BottomMenuState();
}

class _BottomMenuState extends State<BottomMenu> {
  bool _isLoggingOut = false;

  Future<void> _logout() async {
    if (_isLoggingOut) return;

    setState(() => _isLoggingOut = true);

    try {
      await AuthService().signOut();

      if (!mounted) return;

      Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (_) => false,
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível sair do sistema. Tente novamente.'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoggingOut = false);
      }
    }
  }

  void _goTo(Widget page) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
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
              onPressed: () => _goTo(const Home()),
              icon: const Icon(Icons.home, color: Colors.white, size: 32),
            ),
            IconButton(
              onPressed: () => _goTo(const Agenda()),
              icon: const Icon(
                Icons.calendar_month_outlined,
                color: Colors.white,
                size: 32,
              ),
            ),
            IconButton(
              onPressed: () => _goTo(const HistoryPage()),
              icon: const Icon(Icons.history, color: Colors.white, size: 36),
            ),
            IconButton(
              onPressed: _isLoggingOut ? null : _logout,
              icon: _isLoggingOut
                  ? const SizedBox(
                      width: 26,
                      height: 26,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.logout, color: Colors.white, size: 34),
            ),
          ],
        ),
      ),
    );
  }
}
