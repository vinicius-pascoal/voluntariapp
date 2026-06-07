import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/event.dart';

class ParticipationService {

  Future<void> participate(
    Event event,
  ) async {

    final user =
        FirebaseAuth.instance.currentUser;

    if (user == null) return;

    final existing =
        await FirebaseFirestore.instance
            .collection('participations')
            .where(
              'userId',
              isEqualTo: user.uid,
            )
            .where(
              'eventId',
              isEqualTo: event.id,
            )
            .get();

    if (existing.docs.isNotEmpty) {
      return;
    }

    await FirebaseFirestore.instance
        .collection('participations')
        .add({

          'userId': user.uid,

          'eventId': event.id,

          'eventTitle': event.title,

          'organization':
              event.organization,

          'joinedAt':
              Timestamp.now(),
        });
  }
}