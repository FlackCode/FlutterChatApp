import 'package:chatapp/auth/auth_gate.dart';
import 'package:chatapp/services/consts.dart';
import 'package:chatapp/themes/light_mode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: FIREBASE_API_KEY,
            appId: FIREBASE_APP_ID,
            messagingSenderId: FIREBASE_MESSAGING_ID,
            projectId: FIREBASE_PROJECT_ID));
  } catch (e) {
    print(e.toString());
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
      theme: lightMode,
    );
  }
}
