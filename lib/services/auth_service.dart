import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> login({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<UserCredential> registerVolunteer({
    required String name,
    required String surname,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    await credential.user?.updateDisplayName('$name $surname'.trim());

    await _saveUserProfile(
      uid: credential.user!.uid,
      type: 'voluntario',
      name: name,
      surname: surname,
      email: email,
    );

    return credential;
  }

  Future<UserCredential> registerOng({
    required String name,
    required String cnpj,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );

    await credential.user?.updateDisplayName(name.trim());

    await _saveUserProfile(
      uid: credential.user!.uid,
      type: 'ong',
      name: name,
      cnpj: cnpj,
      email: email,
    );

    return credential;
  }

  Future<UserCredential?> signInWithGoogle({required String defaultType}) async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return null;

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    final user = userCredential.user;
    if (user == null) return userCredential;

    final existingDoc = await _firestore.collection('users').doc(user.uid).get();
    final existingType = existingDoc.data()?['type']?.toString();

    await _saveUserProfile(
      uid: user.uid,
      type: existingType?.isNotEmpty == true ? existingType! : defaultType,
      name: user.displayName ?? googleUser.displayName ?? '',
      surname: '',
      email: user.email ?? googleUser.email,
      photoUrl: user.photoURL ?? googleUser.photoUrl ?? '',
      merge: true,
    );

    return userCredential;
  }

  Future<void> sendPasswordResetEmail(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }

  Future<void> _saveUserProfile({
    required String uid,
    required String type,
    required String name,
    required String email,
    String surname = '',
    String cnpj = '',
    String photoUrl = '',
    bool merge = false,
  }) async {
    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'type': type,
      'name': name.trim(),
      'surname': surname.trim(),
      'cnpj': cnpj.trim(),
      'email': email.trim(),
      'photoUrl': photoUrl.trim(),
      'occupation': type == 'ong' ? 'Organização' : 'Voluntário',
      'about': '',
      'experiences': '',
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: merge));
  }
}
