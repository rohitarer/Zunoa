// 📄 firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// FirebaseService class to handle all Firestore and Firebase Authentication tasks
class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up with email and password and store user data
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    required String fullName,
    required String nickName,
  }) async {
    UserCredential result = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    await _firestore.collection("users").doc(result.user!.uid).set({
      'uid': result.user!.uid,
      'email': email,
      'fullName': fullName,
      'nickName': nickName,
      'createdAt': FieldValue.serverTimestamp(),
      'isProfileComplete': false,
    });

    return result;
  }

  // Login with email and password
  Future<UserCredential> loginWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Logout the user
  Future<void> logout() async {
    await _auth.signOut();
  }

  // Get current logged-in user
  User? get currentUser => _auth.currentUser;

  // Fetch user profile data from Firestore
  Future<Map<String, dynamic>> fetchUserData(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (!doc.exists) throw Exception("User not found in Firestore");
    return doc.data() ?? {};
  }

  // Update user profile data in Firestore
  Future<void> updateUserProfile({
    required String uid,
    required String fullName,
    required String nickName,
    required String gender,
    required String dob,
    required String email,
    required String phone,
    String? profileImageUrl,
  }) async {
    final Map<String, dynamic> data = {
      'fullName': fullName,
      'nickName': nickName,
      'gender': gender,
      'dob': dob,
      'email': email,
      'phone': phone,
    };

    if (profileImageUrl != null) {
      data['profileImageUrl'] = profileImageUrl;
    }

    await _firestore.collection("users").doc(uid).update(data);
  }

  // Mark profile as complete
  Future<void> markProfileComplete(String uid) async {
    await _firestore.collection("users").doc(uid).update({
      'isProfileComplete': true,
    });
  }

  // ✅ Fetch chat messages once (useful for static loading)
  Future<List<Map<String, dynamic>>> fetchChatMessages() async {
    final snapshot =
        await _firestore.collection('chats').orderBy('timestamp').get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  // ✅ Stream chat messages live
  Stream<List<Map<String, dynamic>>> getMessages() {
    return _firestore
        .collection('chats')
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
  }

  // ✅ Send a message with user's nickname
  Future<void> sendMessage(String message) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final userDoc = await _firestore.collection("users").doc(uid).get();
    final userData = userDoc.data();
    final nickname = userData?['nickName'] ?? "Anonymous";

    await _firestore.collection('chats').add({
      'message': message,
      'nickname': nickname,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

// ✅ Singleton instance
final firebaseService = FirebaseService();

// ✅ Riverpod provider
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return firebaseService;
});

// // 📄 firebase_service.dart
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class FirebaseService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // Sign up with email and password and store user data
//   Future<UserCredential> signUpWithEmail({
//     required String email,
//     required String password,
//     required String fullName,
//   }) async {
//     UserCredential result = await _auth.createUserWithEmailAndPassword(
//       email: email,
//       password: password,
//     );

//     await _firestore.collection("users").doc(result.user!.uid).set({
//       'uid': result.user!.uid,
//       'email': email,
//       'fullName': fullName,
//       'createdAt': FieldValue.serverTimestamp(),
//       'isProfileComplete': false,
//     });

//     return result;
//   }

//   // Login with email and password
//   Future<UserCredential> loginWithEmail({
//     required String email,
//     required String password,
//   }) async {
//     return await _auth.signInWithEmailAndPassword(
//       email: email,
//       password: password,
//     );
//   }

//   // Logout
//   Future<void> logout() async {
//     await _auth.signOut();
//   }

//   // Get current user
//   User? get currentUser => _auth.currentUser;

//   // Fetch user profile data from Firestore
//   Future<Map<String, dynamic>> fetchUserData(String uid) async {
//     final doc = await _firestore.collection('users').doc(uid).get();
//     if (!doc.exists) throw Exception("User not found in Firestore");
//     return doc.data() ?? {};
//   }

//   // Update user profile data in Firestore
//   Future<void> updateUserProfile({
//     required String uid,
//     required String fullName,
//     required String nickName,
//     required String gender,
//     required String dob,
//     required String email,
//     required String phone,
//     String? profileImageUrl,
//   }) async {
//     final Map<String, dynamic> data = {
//       'fullName': fullName,
//       'nickName': nickName,
//       'gender': gender,
//       'dob': dob,
//       'email': email,
//       'phone': phone,
//     };
//     if (profileImageUrl != null) {
//       data['profileImageUrl'] = profileImageUrl;
//     }
//     await _firestore.collection("users").doc(uid).update(data);
//   }

//   // Mark profile as complete
//   Future<void> markProfileComplete(String uid) async {
//     await _firestore.collection("users").doc(uid).update({
//       'isProfileComplete': true,
//     });
//   }
// }

// // Singleton instance
// final firebaseService = FirebaseService();
