import 'package:flutter/material.dart';
import 'package:voluntariapp/features/history/pages/event_detail_page.dart';
import 'package:voluntariapp/models/participation.dart';

class HistoryCard extends StatelessWidget {
  final Participation participation;

  const HistoryCard({super.key, required this.participation});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 116,
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
                      participation.eventTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Participou do evento organizado por ${participation.organization}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      _formatDate(participation.eventDate),
                      style: const TextStyle(fontSize: 12, color: Colors.black45, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.expand_more, color: Color(0xFFFFA500), size: 28),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => EventDetailPage(eventId: participation.eventId)),
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

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year} às ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
