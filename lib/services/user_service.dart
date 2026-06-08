import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:voluntariapp/models/app_user.dart';

class UserService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<AppUser?> currentUserStream() {
    final user = _auth.currentUser;
    if (user == null) return Stream<AppUser?>.value(null);

    return _firestore.collection('users').doc(user.uid).snapshots().map((doc) {
      if (!doc.exists) {
        return AppUser.fromMap(user.uid, {
          'email': user.email ?? '',
          'name': user.displayName ?? '',
          'photoUrl': user.photoURL ?? '',
        });
      }
      return AppUser.fromDocument(doc);
    });
  }

  Future<AppUser?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) {
      return AppUser.fromMap(user.uid, {
        'email': user.email ?? '',
        'name': user.displayName ?? '',
        'photoUrl': user.photoURL ?? '',
      });
    }
    return AppUser.fromDocument(doc);
  }

  Future<void> updateCurrentUser({
    required String name,
    required String surname,
    required String occupation,
    required DateTime? birthDate,
    required String about,
    required String experiences,
    required String photoUrl,
    String? cnpj,
  }) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw Exception('Usuário não autenticado.');
    }

    final fullName = '$name $surname'.trim();
    if (fullName.isNotEmpty) {
      await user.updateDisplayName(fullName);
    }
    if (photoUrl.trim().isNotEmpty) {
      await user.updatePhotoURL(photoUrl.trim());
    }

    await _firestore.collection('users').doc(user.uid).set({
      'name': name.trim(),
      'surname': surname.trim(),
      'occupation': occupation.trim(),
      'birthDate': birthDate == null ? null : Timestamp.fromDate(birthDate),
      'about': about.trim(),
      'experiences': experiences.trim(),
      'photoUrl': photoUrl.trim(),
      if (cnpj != null) 'cnpj': cnpj.trim(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
