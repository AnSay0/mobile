import 'package:chat_app/views/chatlabel_screen.dart';
import 'package:chat_app/views/chatscreen.dart';
import 'package:chat_app/views/liquideSwip_screen.dart';
import 'package:chat_app/views/signin_screen.dart';
import 'package:chat_app/views/signup_screen.dart';
import 'package:chat_app/views/signupmethodes_screen.dart';
import 'package:chat_app/views/welcome_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: FirebaseAuth.instance.currentUser == null? LiquideScreen.screen : ChatLabelScreen.screen,
        routes: {
          LiquideScreen.screen : (context) => LiquideScreen(),
          WelcomeScreen.screen: (context) => WelcomeScreen(),
          SigninScreen.screen: (context) => SigninScreen(),
          SignupScreen.screen: (context) => SignupScreen(),
          ChatScreen.screen: (context) => ChatScreen(),
          ChatLabelScreen.screen: (context) => ChatLabelScreen(),
          SignupMethodesScreen.screen: (context) => SignupMethodesScreen(),
        });
  }
}
