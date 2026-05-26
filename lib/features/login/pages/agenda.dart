import 'package:flutter/material.dart';
import 'package:voluntariapp/features/login/pages/home.dart';
import 'package:voluntariapp/features/login/widgets/agenda_calendar_card.dart';
import 'package:voluntariapp/features/login/pages/notificacoes.dart';

class Agenda extends StatefulWidget {
  const Agenda({super.key});

  @override
  State<Agenda> createState() => _AgendaState();
}

class _AgendaState extends State<Agenda> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedDate = DateTime(now.year, now.month, now.day);
  }

  void _updateSelectedDate(DateTime date) {
    setState(() {
      _selectedDate = DateTime(date.year, date.month, date.day);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE9FF),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            const SizedBox(height: 53),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 17),
              child: _AgendaHeader(
                onBackPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
            const SizedBox(height: 84),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: AgendaCalendarCard(onDateChanged: _updateSelectedDate),
            ),
            const SizedBox(height: 71),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: _EventReminder(selectedDate: _selectedDate),
            ),
            const Spacer(),
          ],
        ),
      ),
      bottomNavigationBar: const _BottomMenu(),
    );
  }
}

class _AgendaHeader extends StatelessWidget {
  const _AgendaHeader({required this.onBackPressed});

  final VoidCallback onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          onTap: onBackPressed,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 39,
            height: 39,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFFFA500), width: 2),
            ),
            child: const Icon(
              Icons.arrow_back,
              color: Color(0xFFFFA500),
              size: 29,
            ),
          ),
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Notificacoes()),
            );
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(
              color: Color(0xFFFFA500),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.notifications_none_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        const AppAvatar(size: 40),
      ],
    );
  }
}

class _EventReminder extends StatelessWidget {
  const _EventReminder({required this.selectedDate});

  final DateTime selectedDate;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Evento em ${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}',
            style: const TextStyle(
              color: Color(0xFF202124),
              fontSize: 23,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 11),
          const Text(
            'Lembrete do evento selecionado se aproximando,\ndata de início na hora YY:YY.',
            style: TextStyle(
              color: Color(0xFF808080),
              fontSize: 16,
              fontWeight: FontWeight.w400,
              height: 1.35,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class AppAvatar extends StatelessWidget {
  const AppAvatar({super.key, this.size = 40});

  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Image.asset(
        'assets/avatar.png',
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          return Container(
            width: size,
            height: size,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFD9D9D9),
            ),
            child: Icon(Icons.person, color: Colors.white, size: size * 0.65),
          );
        },
      ),
    );
  }
}

class _BottomMenu extends StatelessWidget {
  const _BottomMenu();

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
            const Icon(Icons.history, color: Colors.white, size: 36),
            const Icon(Icons.logout, color: Colors.white, size: 34),
          ],
        ),
      ),
    );
  }
}
