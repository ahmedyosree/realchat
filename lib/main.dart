
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realchat/services/local_storage_service.dart';
import 'package:realchat/features/auth/data/services/firebase_authentication_service.dart';
import 'package:realchat/services/firebase_firestore_chat_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/firebase_firestore_user_service.dart';
import 'app/my_app.dart';
import 'core/constants/firebase_options.dart';
import 'features/auth/logic/bloc/auth_bloc_observer.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AuthBlocObserver();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final localStorageService = LocalStorageService(prefs);
  final firebaseAuthService = FirebaseAuthService();
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  final fireStoreService = FireStoreUserService(firestore: firestore);
  final fireStoreChatService = FireStoreChatService(firestore: firestore);


  runApp(MyApp(
    localStorageService: localStorageService,
    firebaseAuthService: firebaseAuthService,
    fireStoreService: fireStoreService,
    fireStoreChatService: fireStoreChatService,

  ));
}



