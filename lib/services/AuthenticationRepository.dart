import 'dart:convert';
import '../models/user.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/exceptions/auth_exception.dart';
import 'firebase_service.dart';

class AuthenticationRepository {
  final FirebaseService _firebaseService;
  final SharedPreferences _prefs;

  AuthenticationRepository({
    FirebaseService? firebaseService,
    required SharedPreferences prefs,
  })  : _firebaseService = firebaseService ?? FirebaseService(),
        _prefs = prefs;


  Future<void> _saveUserToPrefs(UserModel user) async {
    await _prefs.setString('userData', json.encode(user.toMap()));
  }

  Future<UserModel?> _getUserFromPrefs() async {
    final userData = _prefs.getString('userData');
    if (userData == null) return null;

    final Map<String, dynamic> decodedData = json.decode(userData);
    return UserModel(
      id: decodedData['id'],
      email: decodedData['email'],
      name: decodedData['name'],
      nickname: decodedData['nickname'],
      signInTime: DateTime.parse(decodedData['signInTime']), // Parse ISO 8601 string back to DateTime
      friends: List<String>.from(decodedData['friends'] ?? []),
    );
  }

  /// Signs in a user with email and password.
  Future<UserModel?> signInWithEmail(String email, String password) async {
    try {
      final firebaseUser = await _firebaseService.signInWithEmail(email, password);
      if (firebaseUser == null) return null;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (!userDoc.exists) {
        throw AuthException('User account not found', 'user-not-found');
      }

      final user = UserModel.fromMap(userDoc.data()!);
      await _saveUserToPrefs(user);
      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    } on FirebaseException catch (e) {
      throw AuthException('Database error: ${e.message}', 'firestore-error');
    } catch (e) {
      throw AuthException('Sign in failed. Please try again.');
    }
  }

  /// Registers a new user with email and password.
  Future<UserModel?> registerWithEmail(String email, String password, String name, String nickname) async {
    try {
      final firebaseUser = await _firebaseService.registerWithEmail(email, password);

      if (firebaseUser == null) return null;

      final user = UserModel(
        id: firebaseUser.uid,
        email: email,
        name: name,
        nickname: nickname,
        signInTime: DateTime.now(),
        friends: [],
      );

      // Save the user data in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.id)
          .set(user.toMap());

      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    } on FirebaseException catch (e) {
      throw AuthException('Database error: ${e.message}', 'firestore-error');
    } catch (e) {
      throw AuthException('Registration failed. Please try again.');
    }
  }

  /// Signs in a user with Google.
// In AuthenticationRepository
  Future<UserModel?> signInWithGoogle() async {
    try {
      final firebaseUser = await _firebaseService.signInWithGoogle();
      if (firebaseUser == null) return null;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      UserModel? user;

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

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.id)
            .set(user.toMap());
      }

      await _saveUserToPrefs(user); // Add this line
      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    } on FirebaseException catch (e) {
      throw AuthException('Database error: ${e.message}', 'firestore-error');
    } catch (e) {
      throw AuthException('Google sign-in failed. Please try again.');
    }
  }

  /// Signs out the currently signed-in user.
  Future<void> signOut() async {
    await _firebaseService.signOut();
    await _prefs.remove('userData');
  }


  /// Gets the current authenticated user as a custom User model.
  Future<UserModel?> getCurrentUser() async {
    try {
      // Check local storage first
      final userFromPrefs = await _getUserFromPrefs();
      if (userFromPrefs != null) return userFromPrefs;

      // Fallback to Firebase check
      final firebaseUser = _firebaseService.getCurrentUser();
      if (firebaseUser == null) return null;

      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(firebaseUser.uid)
          .get();

      if (!userDoc.exists) return null;

      final user = UserModel.fromMap(userDoc.data()!);
      await _saveUserToPrefs(user);
      return user;
    } catch (e) {
      return null;
    }
  }

  AuthException _handleFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'invalid-email':
        return AuthException('Invalid email address', e.code);
      case 'user-disabled':
        return AuthException('This account has been disabled', e.code);
      case 'user-not-found':
      case 'wrong-password':
        return AuthException('Invalid email or password', e.code);
      case 'email-already-in-use':
        return AuthException('Email already registered', e.code);
      case 'weak-password':
        return AuthException('Password is too weak', e.code);
      case 'operation-not-allowed':
        return AuthException('Operation not allowed', e.code);
      default:
        return AuthException('Authentication failed. Please try again.', e.code);
    }
  }

}
