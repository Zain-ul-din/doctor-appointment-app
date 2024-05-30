import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:async';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSigin = GoogleSignIn();

  User? get getUser => _auth.currentUser;
  Stream<User?> get user => _auth.userChanges();

  Future<String?> getUserName() async {
    User? user = _auth.currentUser;
    if (user != null) {
      return user.displayName;
      // DocumentSnapshot userDoc =
      //     await _db.collection('users').doc(user.uid).get();
      // return userDoc.data()?[''] ?? user.displayName;
    }
    return null;
  }

  Future<User?> googleSignIn() async {
    try {
      GoogleSignInAccount? googleSignInAccount = await _googleSigin.signIn();
      GoogleSignInAuthentication? googleAuth =
          await googleSignInAccount?.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken ?? "",
        idToken: googleAuth?.idToken ?? "",
      );

      UserCredential? result = await _auth.signInWithCredential(credential);

      // update user data

      return result.user;
    } catch (err) {
      print(err);
      return null;
    }
  }
}
