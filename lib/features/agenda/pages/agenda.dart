import 'package:flutter/material.dart';
import 'package:voluntariapp/features/home/pages/home.dart';
import 'package:voluntariapp/features/agenda/widgets/agenda_calendar_card.dart';
import 'package:voluntariapp/features/notificacoes/pages/notificacoes.dart';
import 'package:voluntariapp/features/perfil/perfil_page.dart';
import 'package:voluntariapp/features/history/pages/history_page.dart';
import 'package:voluntariapp/widgets/bottonMenu.dart';

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
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 17),
                child: _AgendaHeader(
                  onBackPressed: () => Navigator.of(context).maybePop(),
                ),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 42),
                child: AgendaCalendarCard(onDateChanged: _updateSelectedDate),
              ),
              const SizedBox(height: 32),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 42),
                child: _EventReminder(selectedDate: _selectedDate),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const BottomMenu(),
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

  //adicionar onclick para ir para a página de perfil do usuário
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const PerfilPage()),
        );
      },
      borderRadius: BorderRadius.circular(size / 2),
      child: ClipOval(
        child: Image.network(
          'https://picsum.photos/200',
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
      ),
    );
  }
}
