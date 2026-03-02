import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // -----------------------------
  // SIGNUP
  // -----------------------------
  Future<User?> signUp(String email, String password) async {
    try {
      // Firebase Auth create user
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        // Save user info in Firestore (without fullName)
        await _firestore.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "email": email,
          "createdAt": DateTime.now(),
        });
      }

      return user;
    } on FirebaseAuthException catch (e) {
      // Return user-friendly messages
      if (e.code == 'weak-password') {
        throw Exception('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Exception('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        throw Exception('The email address is not valid.');
      } else {
        throw Exception(e.message);
      }
    } catch (e) {
      throw Exception('Signup failed: $e');
    }
  }

  // -----------------------------
  // LOGIN
  // -----------------------------
  Future<UserCredential> login(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  // -----------------------------
  // LOGOUT
  // -----------------------------
  Future<void> logout() async {
    await _auth.signOut();
  }

  // -----------------------------
  // GET CURRENT USER
  // -----------------------------
  User? get currentUser => _auth.currentUser;

  // -----------------------------
  // GET USER DATA FROM FIRESTORE
  // -----------------------------
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    try {
      DocumentSnapshot doc = await _firestore.collection("users").doc(uid).get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      } else {
        return null;
      }
    } catch (e) {
      throw Exception("Error fetching user data: $e");
    }
  }
}