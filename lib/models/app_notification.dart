import 'package:cloud_firestore/cloud_firestore.dart';

class AppNotification {
  final String id;
  final String userId;
  final String eventId;
  final String title;
  final String description;
  final bool read;
  final DateTime eventDate;
  final DateTime createdAt;

  const AppNotification({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.title,
    required this.description,
    required this.read,
    required this.eventDate,
    required this.createdAt,
  });

  factory AppNotification.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return AppNotification(
      id: doc.id,
      userId: (data['userId'] ?? '').toString(),
      eventId: (data['eventId'] ?? '').toString(),
      title: (data['title'] ?? 'Lembrete').toString(),
      description: (data['description'] ?? '').toString(),
      read: data['read'] == true,
      eventDate: _toDateTime(data['eventDate']) ?? DateTime.now(),
      createdAt: _toDateTime(data['createdAt']) ?? DateTime.now(),
    );
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
