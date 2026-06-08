import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voluntariapp/models/app_notification.dart';
import 'package:voluntariapp/models/event.dart';

class NotificationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<List<AppNotification>> getUserNotifications() {
    final user = _auth.currentUser;
    if (user == null) return Stream<List<AppNotification>>.value([]);

    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
      final notifications = snapshot.docs
          .map((doc) => AppNotification.fromFirestore(doc))
          .toList();
      notifications.sort((a, b) => a.eventDate.compareTo(b.eventDate));
      return notifications;
    });
  }

  Stream<int> getUnreadCount() {
    return getUserNotifications().map((items) => items.where((item) => !item.read).length);
  }

  Future<void> createReminderForEvent(Event event) async {
    final user = _auth.currentUser;
    if (user == null) return;

    final eventDate = event.date;
    final description =
        'Lembrete do evento ${event.title} se aproximando, data ${_formatDate(eventDate)} com início às ${_formatTime(eventDate)}.';

    await _firestore.collection('notifications').doc('${user.uid}_${event.id}').set({
      'userId': user.uid,
      'eventId': event.id,
      'title': 'Lembrete',
      'description': description,
      'eventDate': Timestamp.fromDate(eventDate),
      'read': false,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> deleteReminderForEvent(String eventId) async {
    final user = _auth.currentUser;
    if (user == null) return;
    await _firestore.collection('notifications').doc('${user.uid}_$eventId').delete();
  }

  Future<void> markAsRead(String notificationId) async {
    await _firestore.collection('notifications').doc(notificationId).set({
      'read': true,
      'readAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
