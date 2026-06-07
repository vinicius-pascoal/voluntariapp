import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String organization;
  final String description;
  final String location;
  final DateTime date;

  Event({
    required this.id,
    required this.title,
    required this.organization,
    required this.description,
    required this.location,
    required this.date,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception(
        'Evento não encontrado',
      );
    }

    return Event(
      id: doc.id,
      title: data['title'] ?? '',
      organization: data['organization'] ?? '',
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      date: data['date'] != null
          ? (data['date'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}
