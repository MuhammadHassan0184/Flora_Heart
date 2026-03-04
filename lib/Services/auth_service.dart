// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   // -----------------------------
//   // SIGNUP
//   // -----------------------------
//   Future<User?> signUp(String email, String password) async {
//     try {
//       // Firebase Auth create user
//       UserCredential result = await _auth.createUserWithEmailAndPassword(
//         email: email,
//         password: password,
//       );

//       User? user = result.user;

//       if (user != null) {
//         // Save user info in Firestore (without fullName)
//         await _firestore.collection("users").doc(user.uid).set({
//           "uid": user.uid,
//           "email": email,
//           "createdAt": DateTime.now(),
//         });
//       }

//       return user;
//     } on FirebaseAuthException catch (e) {
//       // Return user-friendly messages
//       if (e.code == 'weak-password') {
//         throw Exception('The password provided is too weak.');
//       } else if (e.code == 'email-already-in-use') {
//         throw Exception('The account already exists for that email.');
//       } else if (e.code == 'invalid-email') {
//         throw Exception('The email address is not valid.');
//       } else {
//         throw Exception(e.message);
//       }
//     } catch (e) {
//       throw Exception('Signup failed: $e');
//     }
//   }

//   // -----------------------------
//   // LOGIN
//   // -----------------------------
//   Future<UserCredential> login(String email, String password) async {
//     try {
//       return await _auth.signInWithEmailAndPassword(
//         email: email,
//         password: password,
//       );
//     } catch (e) {
//       throw Exception(e.toString());
//     }
//   }

//   // -----------------------------
//   // LOGOUT
//   // -----------------------------
//   Future<void> logout() async {
//     await _auth.signOut();
//   }

//   // -----------------------------
//   // GET CURRENT USER
//   // -----------------------------
//   User? get currentUser => _auth.currentUser;

//   // -----------------------------
//   // GET USER DATA FROM FIRESTORE
//   // -----------------------------
//   Future<Map<String, dynamic>?> getUserData(String uid) async {
//     try {
//       DocumentSnapshot doc = await _firestore.collection("users").doc(uid).get();

//       if (doc.exists) {
//         return doc.data() as Map<String, dynamic>;
//       } else {
//         return null;
//       }
//     } catch (e) {
//       throw Exception("Error fetching user data: $e");
//     }
//   }
// }

// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // -----------------------------
  // SIGNUP (Email & Password)
  // -----------------------------
  Future<User?> signUp(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = result.user;

      if (user != null) {
        await _firestore.collection("users").doc(user.uid).set({
          "uid": user.uid,
          "email": email,
          "createdAt": FieldValue.serverTimestamp(),
          "provider": "email",
        });
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // -----------------------------
  // LOGIN (Email & Password)
  // -----------------------------
  Future<UserCredential> login(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message);
    }
  }

  // -----------------------------
  // GOOGLE SIGN IN (FIXED)
  // -----------------------------
  Future<User?> signInWithGoogle() async {
    try {
      // Force account picker every time (optional)
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return null; // user cancelled
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // IMPORTANT FIX: null safety handling
      if (googleAuth.idToken == null) {
        throw Exception("Google ID Token is null");
      }

      final AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final UserCredential userCredential = await _auth.signInWithCredential(
        credential,
      );

      final User? user = userCredential.user;

      if (user != null) {
        final docRef = _firestore.collection("users").doc(user.uid);

        final doc = await docRef.get();

        if (!doc.exists) {
          await docRef.set({
            "uid": user.uid,
            "email": user.email,
            "name": user.displayName,
            "photo": user.photoURL,
            "createdAt": FieldValue.serverTimestamp(),
            "provider": "google",
          });
        }
      }

      return user;
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException: ${e.message}");
      return null;
    } catch (e) {
      print("Google Sign-In Error: $e");
      return null;
    }
  }

  // -----------------------------
  // LOGOUT
  // -----------------------------
  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // -----------------------------
  // CURRENT USER
  // -----------------------------
  User? get currentUser => _auth.currentUser;

  // -----------------------------
  // GET USER DATA
  // -----------------------------
  Future<Map<String, dynamic>?> getUserData(String uid) async {
    final doc = await _firestore.collection("users").doc(uid).get();

    if (doc.exists) {
      return doc.data();
    }
    return null;
  }
}
