import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_chat_app/models/user.dart' as local;

// Auth Service Firebase
class AuthService {
  final auth.FirebaseAuth firebaseAuth = auth.FirebaseAuth.instance;

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Create user obj based on Firebaseuser
  local.User? _userFromFirebaseUser(auth.User user) {
    return local.User(idUser: user.uid);
  }

  // Auth change user stream
  Stream<auth.User?> get authState {
    return firebaseAuth.idTokenChanges();
  }

  // Function SignIn
  Future signInUserWithEmailAndPass(String userMail, String password) async {
    try {
      auth.User user = (await firebaseAuth.signInWithEmailAndPassword(
              email: userMail, password: password))
          .user!;
      // ignore: unnecessary_null_comparison
      if (user != null) {
        // Save data provider
        _userFromFirebaseUser(user);
        return true;
      }
    } on auth.FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  // Function SignUp
  Future signUpUserWithEmailAndPass(
      String userMail, String password, String fullName) async {
    try {
      auth.User user = (await firebaseAuth.createUserWithEmailAndPassword(
              email: userMail, password: password))
          .user!;

      // ignore: unnecessary_null_comparison
      if (user != null) {
        // Save data user in Database Firestore
        firestore.collection('users').doc(user.uid).set({
          "userMail": userMail,
          "fullName": fullName,
          "idUser": user.uid,
        });
        // Save data provider
        _userFromFirebaseUser(user);
        return true;
      }
    } on auth.FirebaseAuthException catch (e) {
      return e.code;
    }
  }

  // Function Recovery Password
  Future resetPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      return null;
    }
  }

  // Function SignOut
  Future signOut() async {
    try {
      return await firebaseAuth.signOut();
      // ignore: unused_catch_clause
    } on auth.FirebaseAuthException catch (e) {
      return null;
    }
  }
}
