import 'package:flutter/material.dart';
import 'package:voluntariapp/features/history/pages/event_detail_page.dart';

class HistoryCard extends StatelessWidget {
  final String title;

  final String organization;

  final String eventId;

  const HistoryCard({
    super.key,
    required this.title,
    required this.organization,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      width: 384,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                     'Participou do evento organizado por $organization',
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.expand_more,
                    color: Color(0xFFFFA500),
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>  EventDetailPage(
                          eventId: eventId,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
