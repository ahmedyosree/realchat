
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/exceptions/auth_exception.dart';
import '../../../../core/models/user.dart';
import '../../../../services/LocalStorageService.dart';
import '../../../../services/firebase_service.dart';

/// Authentication repository
class AuthenticationRepository {
  final FirebaseService _firebaseService;
  final LocalStorageService _localStorageService;

  AuthenticationRepository({
    required FirebaseService firebaseService,
    required LocalStorageService localStorageService,
  })  : _firebaseService = firebaseService,
        _localStorageService = localStorageService;

  Future<UserModel?> signInWithEmail(String email, String password) async {
    try {
      final User? firebaseUser =
          await _firebaseService.signInWithEmail(email, password);


      final user = await _getOrCreateUser(firebaseUser!);
      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    } catch (e) {
      throw AuthException(
          'An unexpected error occurred. Please try again.', 'unknown');
    }
  }

  Future<UserModel?> registerWithEmail(
      String email, String password, String name, String nickname) async {
    try {
      final User? firebaseUser =
          await _firebaseService.registerWithEmail(email, password);
      if (firebaseUser == null) return null;

      final user = UserModel(
        id: firebaseUser.uid,
        email: email,
        name: name,
        nickname: nickname,
        signInTime: DateTime.now(),
        friends: [],
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .set(user.toMap());
      await _localStorageService.saveUser(user);
      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    } catch (e) {
      throw AuthException('Registration failed. Please try again.');
    }
  }

  Future<UserModel?> signInWithGoogle() async {
    try {
      final User? firebaseUser = await _firebaseService.signInWithGoogle();
      if (firebaseUser == null) return null;

      final user = await _getOrCreateUser(firebaseUser);
      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    } catch (e) {
      debugPrint("Google sign-in error: $e");
      throw AuthException(
          'Google sign-in failed. Please try again.', 'google-error');
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseService.signOut();
      await _localStorageService.clearUser();
    } catch (e) {
      throw AuthException('Sign-out failed. Please try again.');
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final userFromPrefs = _localStorageService.getUser();
      if (userFromPrefs != null) {
        return userFromPrefs;
      }

      final User? firebaseUser = _firebaseService.getCurrentUser();
      if (firebaseUser == null) return null;

      final user = await _getOrCreateUser(firebaseUser);
      return user;
    } catch (e) {
      return null;
    }
  }

  Future<UserModel> _getOrCreateUser(User firebaseUser) async {
    final userCollection = FirebaseFirestore.instance.collection('users');
    final userDoc = await userCollection.doc(firebaseUser.uid).get();

    UserModel user;
    if (userDoc.exists) {
      user = UserModel.fromMap(userDoc.data()!);
    } else {
      user = UserModel(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        name: firebaseUser.displayName ?? 'Unknown',
        nickname: 'User${firebaseUser.uid.substring(0, 5)}',
        signInTime: DateTime.now(),
        friends: [],
      );
      await userCollection.doc(user.id).set(user.toMap());
    }
    await _localStorageService.saveUser(user);
    return user;
  }

  AuthException _handleFirebaseAuthError(FirebaseAuthException e) {
    debugPrint("Firebase error code: ${e.code}");
    switch (e.code) {
      case 'invalid-email':
        return AuthException('Invalid email address', e.code);
      case 'user-disabled':
        return AuthException('This account has been disabled', e.code);
      case 'invalid-credential':
      case 'wrong-password':
      case 'user-not-found':
        return AuthException('Invalid email or password', e.code);
      case 'email-already-in-use':
        return AuthException('Email already registered', e.code);
      case 'weak-password':
        return AuthException('Password is too weak', e.code);
      case 'operation-not-allowed':
        return AuthException('Operation not allowed', e.code);
      case 'account-exists-with-different-credential':
        return AuthException(
            'Account exists with different sign-in method', e.code);
      default:
        debugPrint("Unhandled error code: ${e.code}");
        return AuthException(
            'Authentication failed. Please try again.', e.code);
    }
  }
}
