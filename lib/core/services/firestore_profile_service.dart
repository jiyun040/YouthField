import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreProfileService {
  static const _collection = 'users';

  static FirebaseFirestore get _db => FirebaseFirestore.instance;

  static Future<void> saveProfile({
    required String uid,
    required String name,
    required String userType,
    String? staffRole,
    String? team,
    String? position,
    String? birthdate,
    String? resolve,
  }) async {
    final data = <String, dynamic>{
      'name': name,
      'userType': userType,
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (staffRole != null) data['staffRole'] = staffRole;
    if (team != null) data['team'] = team;
    if (position != null) data['position'] = position;
    if (birthdate != null) data['birthdate'] = birthdate;
    if (resolve != null) data['resolve'] = resolve;

    await _db.collection(_collection).doc(uid).set(data, SetOptions(merge: true));
  }

  static Future<Map<String, dynamic>?> loadProfile(String uid) async {
    final doc = await _db.collection(_collection).doc(uid).get();
    return doc.exists ? doc.data() : null;
  }

  static Future<void> deleteProfile(String uid) async {
    await _db.collection(_collection).doc(uid).delete();
  }
}
