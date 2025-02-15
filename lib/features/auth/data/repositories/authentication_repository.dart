import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../services/firebase_firestore.dart';
import '../../../../core/exceptions/auth_exception.dart';
import '../../../../core/models/user.dart';
import '../../../../services/LocalStorageService.dart';
import '../../../../services/firebase_authentication_service.dart';

/// A wrapper class to store Google sign-in results.
/// It contains either a Firebase [User] or a [UserModel] from Firestore.
class GoogleSignInResult {
  final User? firebaseUser;
  final UserModel? userModel;

  GoogleSignInResult({this.firebaseUser, this.userModel});
}

/// Authentication repository responsible for handling user authentication,
/// registration, and session management.
class AuthenticationRepository {
  final FirebaseAuthService _firebaseAuthService;
  final LocalStorageService _localStorageService;
  final FireStoreService _fireStoreService;

  AuthenticationRepository({
    required FirebaseAuthService firebaseAuthService,
    required LocalStorageService localStorageService,
    required FireStoreService fireStoreService,
  })  : _firebaseAuthService = firebaseAuthService,
        _localStorageService = localStorageService,
        _fireStoreService = fireStoreService;

  /// Signs in a user using email and password.
  /// Fetches user data from Firestore and caches it locally.
  Future<UserModel?> signInWithEmail(String email, String password) async {
    try {
      final User? firebaseUser =
          await _firebaseAuthService.signInWithEmail(email, password);
      if (firebaseUser == null) return null;

      final docSnapshot = await _fireStoreService.getDocument(
        collectionPath: 'users',
        docId: firebaseUser.uid,
      );

      final user = UserModel.fromMap(docSnapshot.data()!);
      await _localStorageService.saveUser(user);
      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    }
  }

  /// Registers a new user with email and password.
  /// Creates a Firestore document and caches the user data.
  Future<UserModel?> registerWithEmail(
      String email, String password, String name, String nickname) async {
    try {
      final User? firebaseUser =
          await _firebaseAuthService.registerWithEmail(email, password);
      if (firebaseUser == null) return null;

      final user = UserModel(
        id: firebaseUser.uid,
        email: email,
        name: name,
        nickname: nickname,
        signInTime: DateTime.now(),
        friends: [],
      );

      await _fireStoreService.setDocument(
        collectionPath: 'users',
        docId: user.id,
        data: user.toMap(),
      );
      await _localStorageService.saveUser(user);
      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    }
  }

  /// Creates a Firestore document and caches the user data.
  Future<UserModel?> registerWithGoogle(
      User? firebaseUser, String name, String nickname) async {
    try {
      UserModel user;
      user = UserModel(
        id: firebaseUser!.uid,
        email: firebaseUser.email ?? '',
        name: name,
        nickname: nickname,
        signInTime: DateTime.now(),
        friends: [],
      );
      await _fireStoreService.setDocument(
        collectionPath: 'users',
        docId: user.id,
        data: user.toMap(),
      );
      await _localStorageService.saveUser(user);
      return user;
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    }
  }

  /// Signs in a user with Google authentication.
  /// Checks if a Firestore document exists;
  Future<GoogleSignInResult?> signInWithGoogle() async {
    try {
      final User? firebaseUser = await _firebaseAuthService.signInWithGoogle();
      if (firebaseUser == null) return null; // User canceled sign-in

      final docSnapshot = await _fireStoreService.getDocument(
        collectionPath: 'users',
        docId: firebaseUser.uid,
      );

      if (!docSnapshot.exists || docSnapshot.data() == null) {
        // No Firestore document → return GoogleSignInResult with only firebaseUser
        return GoogleSignInResult(firebaseUser: firebaseUser);
      }

      final userModel = UserModel.fromMap(docSnapshot.data()!);
      await _localStorageService.saveUser(userModel);

      return GoogleSignInResult(userModel: userModel);
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    }
  }

  /// Signs out the currently authenticated user.
  /// Clears user data from local storage.
  Future<void> signOut() async {
    try {
      await _firebaseAuthService.signOut();
      await _localStorageService.clearUser();
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    }
  }

  /// Signs out the user to allow Gmail account switching.
  Future<void> changeGmailWhileSigningIn() async {
    try {
      await _firebaseAuthService.signOut();
    } on FirebaseAuthException catch (e) {
      throw _handleFirebaseAuthError(e);
    }
  }

  /// Retrieves the currently signed-in user from local storage.
  Future<UserModel?> getCurrentUser() async {
    try {
      final userFromPrefs = _localStorageService.getUser();

      return userFromPrefs;
    } catch (e) {
      return null;
    }
  }

  /// Handles Firebase authentication errors and maps them to user-friendly messages.
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
      case 'network-request-failed':
        return AuthException(
            'Network error. Please check your internet connection.', e.code);
      default:
        debugPrint("Unhandled error code: ${e.code}");
        return AuthException(
            'Authentication failed. Please try again.', e.code);
    }
  }
}
