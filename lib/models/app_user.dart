import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String uid;
  final String type;
  final String name;
  final String surname;
  final String cnpj;
  final String email;
  final String photoUrl;
  final DateTime? birthDate;
  final String about;
  final String experiences;
  final String occupation;
  final DateTime? createdAt;

  const AppUser({
    required this.uid,
    required this.type,
    required this.name,
    required this.surname,
    required this.cnpj,
    required this.email,
    required this.photoUrl,
    required this.birthDate,
    required this.about,
    required this.experiences,
    required this.occupation,
    required this.createdAt,
  });

  bool get isOng => type == 'ong';
  bool get isVolunteer => type == 'voluntario';

  String get displayName {
    final fullName = '$name $surname'.trim();
    if (fullName.isNotEmpty) return fullName;
    if (email.isNotEmpty) return email;
    return isOng ? 'Organização' : 'Voluntário';
  }

  factory AppUser.empty(String uid) {
    return AppUser(
      uid: uid,
      type: 'voluntario',
      name: '',
      surname: '',
      cnpj: '',
      email: '',
      photoUrl: '',
      birthDate: null,
      about: '',
      experiences: '',
      occupation: '',
      createdAt: null,
    );
  }

  factory AppUser.fromMap(String uid, Map<String, dynamic>? data) {
    final map = data ?? <String, dynamic>{};
    return AppUser(
      uid: uid,
      type: (map['type'] ?? 'voluntario').toString(),
      name: (map['name'] ?? '').toString(),
      surname: (map['surname'] ?? '').toString(),
      cnpj: (map['cnpj'] ?? '').toString(),
      email: (map['email'] ?? '').toString(),
      photoUrl: (map['photoUrl'] ?? '').toString(),
      birthDate: _toDateTime(map['birthDate']),
      about: (map['about'] ?? '').toString(),
      experiences: (map['experiences'] ?? '').toString(),
      occupation: (map['occupation'] ?? '').toString(),
      createdAt: _toDateTime(map['createdAt']),
    );
  }

  factory AppUser.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    return AppUser.fromMap(doc.id, doc.data());
  }

  static DateTime? _toDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }
}
