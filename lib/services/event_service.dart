import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event.dart';

class EventService {

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Event>> getEvents() {

    return _firestore
      .collection('events')
      .snapshots()
      .map((snapshot) => snapshot.docs
        .map((doc) => Event.fromFirestore(doc))
        .toList(),

      );

  }

}