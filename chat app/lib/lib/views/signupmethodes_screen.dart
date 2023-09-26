import 'package:chat_app/views/chatlabel_screen.dart';
import 'package:chat_app/views/chatscreen.dart';
import 'package:chat_app/views/signup_screen.dart';
import 'package:chat_app/widgets/buttonmain.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignupMethodesScreen extends StatefulWidget {
  static const String screen = 'signupmethodesscreen';
  @override
  _SignupMethodesScreenState createState() => _SignupMethodesScreenState();
}

class _SignupMethodesScreenState extends State<SignupMethodesScreen> {
  final _auth = FirebaseAuth.instance;
  final _userstore = FirebaseFirestore.instance;
  late String email;
  late String name;
  late String password;
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Chose registretion methode',style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10,),
                  Mybutton(
                    color: Colors.white,
                    title: 'Registre manually',
                    image: 'assets/authicon.jpeg',
                    onpressed: () {
                      Navigator.pushNamed(context, SignupScreen.screen);
                    },
                  ),
                  Mybutton(
                    color: Colors.white,
                    title: 'Registre with google',
                    image: 'assets/googleicon.png',
                    onpressed: () async {
                      var cas = await signInWithGoogle();
                      print(cas.user!.emailVerified);
                      Navigator.pushNamed(context, ChatLabelScreen.screen);
                    },
                  ),
                ]))));
  }
}
