import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voluntariapp/models/event.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Event>> getEvents() {
    return _firestore.collection('events').snapshots().map((snapshot) {
      final events = snapshot.docs.map((doc) => Event.fromFirestore(doc)).toList();
      events.sort((a, b) => a.date.compareTo(b.date));
      return events;
    });
  }

  Future<Event> getEventById(String eventId) async {
    final doc = await _firestore.collection('events').doc(eventId).get();
    return Event.fromFirestore(doc);
  }

  Future<void> createEvent({
    required String title,
    required String organization,
    required String description,
    required String location,
    required DateTime date,
    required String category,
    required int availableSlots,
    String imageUrl = '',
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado.');
    }

    await _firestore.collection('events').add({
      'title': title.trim(),
      'organization': organization.trim(),
      'description': description.trim(),
      'location': location.trim(),
      'date': Timestamp.fromDate(date),
      'category': category.trim(),
      'availableSlots': availableSlots,
      'imageUrl': imageUrl.trim(),
      'createdBy': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}
