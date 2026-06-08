import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  final String id;
  final String title;
  final String organization;
  final String description;
  final String location;
  final DateTime date;
  final String imageUrl;
  final String category;
  final int availableSlots;
  final String createdBy;
  final DateTime? createdAt;

  Event({
    required this.id,
    required this.title,
    required this.organization,
    required this.description,
    required this.location,
    required this.date,
    this.imageUrl = '',
    this.category = '',
    this.availableSlots = 0,
    this.createdBy = '',
    this.createdAt,
  });

  factory Event.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?;

    if (data == null) {
      throw Exception('Evento não encontrado');
    }

    return Event(
      id: doc.id,
      title: (data['title'] ?? '').toString(),
      organization: (data['organization'] ?? '').toString(),
      description: (data['description'] ?? '').toString(),
      location: (data['location'] ?? '').toString(),
      date: _toDateTime(data['date']) ?? DateTime.now(),
      imageUrl: (data['imageUrl'] ?? '').toString(),
      category: (data['category'] ?? '').toString(),
      availableSlots: _toInt(data['availableSlots']),
      createdBy: (data['createdBy'] ?? '').toString(),
      createdAt: _toDateTime(data['createdAt']),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'organization': organization,
      'description': description,
      'location': location,
      'date': Timestamp.fromDate(date),
      'imageUrl': imageUrl,
      'category': category,
      'availableSlots': availableSlots,
      'createdBy': createdBy,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  static int _toInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString()) ?? 0;
  }
}
