import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:realchat/features/auth/data/services/firebase_authentication_service.dart';

import 'firebase_auth_service_test.mocks.dart';
// Generate mocks for dependencies
@GenerateMocks([
  FirebaseAuth,
  UserCredential,
  GoogleSignIn,
  GoogleSignInAccount,
  GoogleSignInAuthentication,
  User // Ensure User is mocked
])
void main() {
  late FirebaseAuthService authService;
  late MockFirebaseAuth mockFirebaseAuth;
  late MockGoogleSignIn mockGoogleSignIn;
  late MockUserCredential mockUserCredential;
  late MockGoogleSignInAccount mockGoogleSignInAccount;
  late MockGoogleSignInAuthentication mockGoogleSignInAuthentication;
  late MockUser mockUser;

  setUp(() {
    // Create mock instances
    mockFirebaseAuth = MockFirebaseAuth();
    mockGoogleSignIn = MockGoogleSignIn();
    mockUserCredential = MockUserCredential();
    mockGoogleSignInAccount = MockGoogleSignInAccount();
    mockGoogleSignInAuthentication = MockGoogleSignInAuthentication();
    mockUser = MockUser(); // Mock user instance

    authService = FirebaseAuthService(
      firebaseAuth: mockFirebaseAuth,
      googleSignIn: mockGoogleSignIn,
    );

    // Stub the `user` property to return a valid `MockUser`
    when(mockUserCredential.user).thenReturn(mockUser);
  });

  group('Email Authentication', () {
    test('signInWithEmail should return User on success', () async {
      when(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      )).thenAnswer((_) async => mockUserCredential);

      final result = await authService.signInWithEmail('test@example.com', 'password123');

      expect(result, equals(mockUser));
      verify(mockFirebaseAuth.signInWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      )).called(1);
    });

    test('registerWithEmail should return User on success', () async {
      when(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      )).thenAnswer((_) async => mockUserCredential);

      final result = await authService.registerWithEmail('test@example.com', 'password123');

      expect(result, equals(mockUser));
      verify(mockFirebaseAuth.createUserWithEmailAndPassword(
        email: 'test@example.com',
        password: 'password123',
      )).called(1);
    });
  });

  group('Google Sign-In', () {
    test('signInWithGoogle should return User on success', () async {
      // Mock Google sign-in process
      when(mockGoogleSignIn.signIn()).thenAnswer((_) async => mockGoogleSignInAccount);
      when(mockGoogleSignInAccount.authentication)
          .thenAnswer((_) async => mockGoogleSignInAuthentication);
      when(mockGoogleSignInAuthentication.accessToken).thenReturn('fake-access-token');
      when(mockGoogleSignInAuthentication.idToken).thenReturn('fake-id-token');

      // Mock Firebase sign-in with credentials
      when(mockFirebaseAuth.signInWithCredential(any))
          .thenAnswer((_) async => mockUserCredential);

      final result = await authService.signInWithGoogle();

      expect(result, equals(mockUser));
      verify(mockGoogleSignIn.signIn()).called(1);
      verify(mockFirebaseAuth.signInWithCredential(any)).called(1);
    });

    test('signInWithGoogle should return null if user cancels sign-in', () async {
      when(mockGoogleSignIn.signIn()).thenAnswer((_) async => null);

      final result = await authService.signInWithGoogle();

      expect(result, isNull);
      verifyNever(mockFirebaseAuth.signInWithCredential(any));
    });
  });

  group('Sign Out', () {
    test('signOut should call FirebaseAuth and GoogleSignIn', () async {
      when(mockFirebaseAuth.signOut()).thenAnswer((_) async {});
      when(mockGoogleSignIn.signOut()).thenAnswer((_) async => null); // Return Future<Null>

      await authService.signOut();

      verify(mockFirebaseAuth.signOut()).called(1);
      verify(mockGoogleSignIn.signOut()).called(1);
    });
  });
}
