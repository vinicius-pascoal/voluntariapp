import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voluntariapp/models/event.dart';
import 'package:voluntariapp/models/participation.dart';
import 'package:voluntariapp/services/notification_service.dart';

class ParticipationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _participationId(String userId, String eventId) => '${userId}_$eventId';

  Future<bool> participate(Event event) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuário não autenticado.');

    final docRef = _firestore
        .collection('participations')
        .doc(_participationId(user.uid, event.id));

    final existing = await docRef.get();
    if (existing.exists) return false;

    await docRef.set({
      'userId': user.uid,
      'eventId': event.id,
      'eventTitle': event.title,
      'organization': event.organization,
      'description': event.description,
      'location': event.location,
      'eventDate': Timestamp.fromDate(event.date),
      'imageUrl': event.imageUrl,
      'status': 'confirmed',
      'joinedAt': FieldValue.serverTimestamp(),
    });

    await NotificationService().createReminderForEvent(event);
    return true;
  }

  Future<void> cancelParticipation(String eventId) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Usuário não autenticado.');

    await _firestore
        .collection('participations')
        .doc(_participationId(user.uid, eventId))
        .delete();

    await NotificationService().deleteReminderForEvent(eventId);
  }

  Stream<bool> isParticipating(String eventId) {
    final user = _auth.currentUser;
    if (user == null) return Stream<bool>.value(false);

    return _firestore
        .collection('participations')
        .doc(_participationId(user.uid, eventId))
        .snapshots()
        .map((doc) => doc.exists);
  }

  Stream<List<Participation>> getUserParticipations() {
    final user = _auth.currentUser;
    if (user == null) return Stream<List<Participation>>.value([]);

    return _firestore
        .collection('participations')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
      final participations = snapshot.docs
          .map((doc) => Participation.fromFirestore(doc))
          .toList();
      participations.sort((a, b) => b.joinedAt.compareTo(a.joinedAt));
      return participations;
    });
  }

  Stream<List<Participation>> getParticipationsByDate(DateTime selectedDate) {
    return getUserParticipations().map((items) {
      return items.where((item) {
        final date = item.eventDate;
        return date.year == selectedDate.year &&
            date.month == selectedDate.month &&
            date.day == selectedDate.day;
      }).toList()
        ..sort((a, b) => a.eventDate.compareTo(b.eventDate));
    });
  }
}
