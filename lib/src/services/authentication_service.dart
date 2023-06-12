import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:aqueduct/aqueduct.dart';


import '../utils/response.dart';
import '../utils/status_code.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<AppResponse> login(@Bind.body() Map<String, dynamic> request) async {
    final email = request['email'] as String;
    final password = request['password'] as String;

    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Authentication successful
      // Return a success response
      return AppResponse.ok({'message': 'Authentication successful'});
    } catch (e) {
      // Authentication failed
      // Return an error response
      return AppResponse.unauthorized();
    }
  }

  Future<UserCredential> signUpWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<Object> checkUserLoggedIn() async {
    try {
      final User? currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        // User is logged in
        return AppResponse(status: StatusCode.ok, message: '', data: null);
      } else {
        // User is not logged in
        return AppResponse(
            status: StatusCode.unauthorized, message: '', data: null);
      }
    } catch (e) {
      // Error occurred while checking user logged in status
      if (kDebugMode) {
        print('Error checking user logged in status: $e');
      }
      return AppResponse(status: StatusCode.badRequest, message: '', data: null);
    }
  }
}
