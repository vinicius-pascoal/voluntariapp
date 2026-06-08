import 'package:flutter/material.dart';
import 'package:voluntariapp/features/agenda/widgets/agenda_calendar_card.dart';
import 'package:voluntariapp/features/notificacoes/pages/notificacoes.dart';
import 'package:voluntariapp/models/participation.dart';
import 'package:voluntariapp/services/participation_service.dart';
import 'package:voluntariapp/widgets/app_avatar.dart';
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
    setState(() => _selectedDate = DateTime(date.year, date.month, date.day));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE9FF),
      body: SafeArea(
        bottom: false,
        child: StreamBuilder<List<Participation>>(
          stream: ParticipationService().getUserParticipations(),
          builder: (context, snapshot) {
            final participations = snapshot.data ?? [];
            final eventDays = participations.map((item) => item.eventDate).toList();
            final selectedEvents = participations.where((item) {
              final date = item.eventDate;
              return date.year == _selectedDate.year && date.month == _selectedDate.month && date.day == _selectedDate.day;
            }).toList()
              ..sort((a, b) => a.eventDate.compareTo(b.eventDate));

            return SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 17),
                    child: _AgendaHeader(onBackPressed: () => Navigator.of(context).maybePop()),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 42),
                    child: AgendaCalendarCard(
                      onDateChanged: _updateSelectedDate,
                      eventDays: eventDays,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 42),
                    child: _EventReminder(
                      selectedDate: _selectedDate,
                      events: selectedEvents,
                      loading: snapshot.connectionState == ConnectionState.waiting,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            );
          },
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
          child: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFFFA500), size: 29),
        ),
        const Spacer(),
        InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Notificacoes()));
          },
          borderRadius: BorderRadius.circular(14),
          child: Container(
            width: 28,
            height: 28,
            decoration: const BoxDecoration(color: Color(0xFFFFA500), shape: BoxShape.circle),
            child: const Center(
              child: Icon(Icons.notifications_none_rounded, color: Colors.white, size: 22),
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
  const _EventReminder({required this.selectedDate, required this.events, required this.loading});

  final DateTime selectedDate;
  final List<Participation> events;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final dateText = '${selectedDate.day.toString().padLeft(2, '0')}/${selectedDate.month.toString().padLeft(2, '0')}/${selectedDate.year}';
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Evento em $dateText',
            style: const TextStyle(color: Color(0xFF202124), fontSize: 23, fontWeight: FontWeight.w700, height: 1.1),
          ),
          const SizedBox(height: 11),
          if (loading)
            const Center(child: CircularProgressIndicator())
          else if (events.isEmpty)
            const Text(
              'Nenhum evento confirmado para essa data.',
              style: TextStyle(color: Color(0xFF808080), fontSize: 16, fontWeight: FontWeight.w400, height: 1.35, letterSpacing: 0.2),
            )
          else
            ...events.map((event) => _AgendaEventTile(event: event)),
        ],
      ),
    );
  }
}

class _AgendaEventTile extends StatelessWidget {
  const _AgendaEventTile({required this.event});

  final Participation event;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        leading: const Icon(Icons.event_available, color: Color(0xFFFFA500)),
        title: Text(event.eventTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('${event.organization}\n${event.location}\nInício: ${_formatTime(event.eventDate)}'),
        isThreeLine: true,
      ),
    );
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
