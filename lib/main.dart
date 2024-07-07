import 'package:chatapp/services/auth/auth_gate.dart';
import 'package:chatapp/services/consts.dart';
import 'package:chatapp/themes/theme_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: FIREBASE_API_KEY,
        appId: FIREBASE_APP_ID,
        messagingSenderId: FIREBASE_MESSAGING_ID,
        projectId: FIREBASE_PROJECT_ID,
      ),
    );
    runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ));
  } catch (e) {
    print("Error initializing Firebase: $e");
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
