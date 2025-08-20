import 'package:flutter/cupertino.dart' ;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'Welcome_Screen.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: FirebaseOptions(
          
          appId: '1:1074730843722:android:5b8550f2b42ecc1a0530b3',
          messagingSenderId: '1074730843722',
          projectId: 'sharebook-app-632f8')
    );
  runApp(const MyApp());
}
class DefaultFirebaseOptions {
  static var currentPlatform;
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}

