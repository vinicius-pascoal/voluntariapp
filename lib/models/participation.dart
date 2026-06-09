import 'package:cloud_firestore/cloud_firestore.dart';

class Participation {
  final String id;
  final String userId;
  final String eventId;
  final String eventTitle;
  final String organization;
  final String description;
  final String location;
  final DateTime eventDate;
  final DateTime joinedAt;
  final String status;
  final String imageUrl;

  const Participation({
    required this.id,
    required this.userId,
    required this.eventId,
    required this.eventTitle,
    required this.organization,
    required this.description,
    required this.location,
    required this.eventDate,
    required this.joinedAt,
    required this.status,
    required this.imageUrl,
  });

  factory Participation.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? <String, dynamic>{};
    return Participation(
      id: doc.id,
      userId: (data['userId'] ?? '').toString(),
      eventId: (data['eventId'] ?? '').toString(),
      eventTitle: (data['eventTitle'] ?? '').toString(),
      organization: (data['organization'] ?? '').toString(),
      description: (data['description'] ?? '').toString(),
      location: (data['location'] ?? '').toString(),
      eventDate: _toDateTime(data['eventDate']) ?? DateTime.now(),
      joinedAt: _toDateTime(data['joinedAt']) ?? DateTime.now(),
      status: (data['status'] ?? 'confirmed').toString(),
      imageUrl: (data['imageUrl'] ?? '').toString(),
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
