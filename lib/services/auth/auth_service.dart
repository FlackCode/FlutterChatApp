import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserCredential> signInWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      try {
        await _firestore.collection("users").doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': email,
        });
        print(
            "User document created successfully for user: ${userCredential.user!.uid}");
      } catch (e) {
        print("Error creating user document: $e");
        throw Exception("Failed to create user document in Firestore");
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException during sign-in: ${e.code} - ${e.message}");
      throw Exception(e.code);
    } catch (e) {
      print("General exception during sign-in: $e");
      throw Exception("An error occurred during sign-in");
    }
  }

  Future<UserCredential> signUpWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      try {
        await _firestore.collection("users").doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': email,
        });
        print(
            "User document created successfully for user: ${userCredential.user!.uid}");
      } catch (e) {
        print("Error creating user document: $e");
        throw Exception("Failed to create user document in Firestore");
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      print("FirebaseAuthException during sign-up: ${e.code} - ${e.message}");
      throw Exception(e.code);
    } catch (e) {
      print("General exception during sign-up: $e");
      throw Exception("An error occurred during sign-up");
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      print("User signed out successfully");
    } catch (e) {
      print("Error signing out: $e");
      throw Exception("Failed to sign out");
    }
  }
}
