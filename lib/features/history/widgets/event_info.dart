import 'package:flutter/material.dart';
import 'package:voluntariapp/models/event.dart';

class EventInfo extends StatelessWidget {
  final Event event;

  const EventInfo({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(event.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(event.organization, style: const TextStyle(color: Colors.black54)),
          if (event.category.isNotEmpty) ...[
            const SizedBox(height: 8),
            Chip(label: Text(event.category)),
          ],
          const SizedBox(height: 20),
          if (event.imageUrl.trim().isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                event.imageUrl,
                width: double.infinity,
                height: 170,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          const SizedBox(height: 16),
          _InfoBox(title: 'Descrição', child: Text(event.description)),
          const SizedBox(height: 16),
          _InfoBox(
            title: 'Data e horário',
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDate(event.date), style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(_formatTime(event.date), style: const TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _InfoBox(
            title: 'Local',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.location.isEmpty ? 'Local não informado' : event.location),
                const SizedBox(height: 12),
                Image.asset(
                  'assets/images/map.png',
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: double.infinity,
                    height: 180,
                    color: Colors.white,
                    child: const Center(child: Icon(Icons.map_outlined, size: 72)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

class _InfoBox extends StatelessWidget {
  const _InfoBox({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: const Color(0xFFDDE9FF), borderRadius: BorderRadius.circular(10)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
