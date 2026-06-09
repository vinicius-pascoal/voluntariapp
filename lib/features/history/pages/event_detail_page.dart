import 'package:flutter/material.dart';
import 'package:voluntariapp/features/history/widgets/event_info.dart';
import 'package:voluntariapp/models/event.dart';
import 'package:voluntariapp/services/event_service.dart';
import 'package:voluntariapp/widgets/bottonMenu.dart';

class EventDetailPage extends StatefulWidget {
  final String eventId;

  const EventDetailPage({super.key, required this.eventId});

  @override
  State<EventDetailPage> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetailPage> {
  late final Future<Event> eventFuture = EventService().getEventById(widget.eventId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE9FF),
      body: FutureBuilder<Event>(
        future: eventFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (!snapshot.hasData) {
            return const Center(child: Text('Evento não encontrado'));
          }

          final event = snapshot.data!;
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFFFFA500), size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  EventInfo(event: event),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const BottomMenu(),
    );
  }
}
