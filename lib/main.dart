
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:realchat/services/LocalStorageService.dart';
import 'package:realchat/services/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/my_app.dart';
import 'core/constants/firebase_options.dart';
import 'features/auth/logic/bloc/AuthBlocObserver.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AuthBlocObserver();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final localStorageService = LocalStorageService(prefs);
  final firebaseService = FirebaseService(); // Create once and inject

  runApp(MyApp(
    localStorageService: localStorageService,
    firebaseService: firebaseService,
  ));
}



