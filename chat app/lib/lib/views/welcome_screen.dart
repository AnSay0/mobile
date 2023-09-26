import 'package:chat_app/views/signin_screen.dart';
import 'package:chat_app/views/signup_screen.dart';
import 'package:chat_app/views/signupmethodes_screen.dart';
import 'package:chat_app/widgets/buttonmain.dart';
import 'package:chat_app/widgets/buttonsign.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static const String screen = 'welomescreen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Center(child:Column(children: [
                        SizedBox(height: 100),
                    Container(
                      height: 150,
                      child: Image.asset('assets/logo.png'),
                    ),
                    SizedBox(height: 30,),
                    Container(
                        height: 250,
                        child: Column(
                          children: [
                        MybuttonSign(
                              color: Colors.purpleAccent.shade400,
                              title: 'Sign in',
                              onpressed: () {
                                Navigator.pushNamed(
                                    context, SigninScreen.screen);
                              },
                            ),
                            MybuttonSign(
                                  color: Colors.lightBlue,
                                  title: 'Sign up',
                                  onpressed: () {
                                    Navigator.pushNamed(
                                        context, SignupMethodesScreen.screen);
                                  },
                                )
                          ],
                        )),
                  ])
     ) ));
  }

}

