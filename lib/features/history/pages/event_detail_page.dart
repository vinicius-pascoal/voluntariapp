import 'package:flutter/material.dart';
import 'package:voluntariapp/features/history/widgets/event_info.dart';

import '../widgets/bottom_navigation.dart';

class EventDetailPage extends StatefulWidget {
  const EventDetailPage({super.key});

  @override
  State<EventDetailPage> createState() => _EventDetailState();
}

class _EventDetailState extends State<EventDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDE9FF),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Color(0xFFFFA500),
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            const EventInfo()
          ],
        ),
      ),
      bottomNavigationBar: const BottomMenu(),
    );
  }
}
