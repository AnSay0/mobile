import 'package:chat_app/views/chatlabel_screen.dart';
import 'package:chat_app/views/chatscreen.dart';
import 'package:chat_app/widgets/buttonmain.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SigninScreen extends StatefulWidget {
  static const String screen = 'signinscreen';
  @override
  _SigninScreenState createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _auth = FirebaseAuth.instance;
  late var email;
  late var password;
  String note = '';
  bool waitCircle = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: waitCircle,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                  child: ListView(children: [
                SizedBox(
                  height: 70,
                ),
                Container(
                  height: 200,
                  child: Image.asset('assets/logo.png', width: 70, height: 120),
                ),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                          onChanged: (value) {
                            email = value;
                          },
                          onSaved: (val) {
                            email = val;
                          },
                          decoration: InputDecoration(
                              hintText: 'Enter your email',
                              suffixIcon: Icon(
                                Icons.email,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ))),
                      SizedBox(height: 10),
                      TextFormField(
                        obscureText: true,
                        onChanged: (value) {
                          password = value;
                        },
                        onSaved: (val) {
                          password = val;
                        },
                        obscuringCharacter: "*",
                        decoration: InputDecoration(
                            hintText: "Enter password",
                            suffixIcon: Icon(
                              Icons.lock,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            )),
                      ),
                      Mybutton(
                        color: Colors.lightBlue,
                        title: 'Enter',
                        image: 'assets/authicon.jpeg',
                        onpressed: () async {
                          setState(() {
                            waitCircle = true;
                          });

                          try {
                            // if (data!.validate()) {
                            setState(() {
                              waitCircle = true;
                            });
                            final user = await _auth.signInWithEmailAndPassword(
                                email: email, password: password);
                            if (user != null) {}
                            if (!user.user!.emailVerified) {
                              User? userr =
                                  await FirebaseAuth.instance.currentUser;
                              await userr!.sendEmailVerification();
                              setState(() async {
                                return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(actions: [
                                        Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              children: [
                                                Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text('Sign in failed',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 25)),
                                                      Icon(
                                                        Icons.cancel,
                                                        color: Colors.red,
                                                      ),
                                                    ]),
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                    'Please confirm your email',
                                                    style:
                                                        TextStyle(fontSize: 15))
                                              ],
                                            ))
                                      ]);
                                    });
                              });
                              print('please confirm your email');
                            } else {
                              Navigator.pushNamed(
                                  context, ChatLabelScreen.screen);
                              setState(() {
                                waitCircle = false;
                              });
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              print('no user found for that email');
                              setState(() {
                                note = 'No user found for that email !';
                              });
                             setState(() async {
                                waitCircle = false;
                                return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(actions: [
                                        Padding(
                                            padding: EdgeInsets.all(10),
                                            child:Center(child: Column(
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                      Text('Sign in failed',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 30,fontWeight: FontWeight.bold)),
                                                    
                                                 
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(note,
                                                    style:
                                                        TextStyle(fontSize: 15))
                                              ],
                                            )))
                                      ]);
                                    });
                              });
                            } else if (e.code == 'wrong-password') {
                              print('password incorrect try again');

                              setState(() {
                                note = 'password incorrect try again';
                              });

                              setState(() async {
                                waitCircle = false;
                                return await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(actions: [
                                        Padding(
                                            padding: EdgeInsets.all(10),
                                            child:Center(child: Column(
                                                 crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                      Text('Sign in failed',
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 30,fontWeight: FontWeight.bold)),
                                                    
                                                 
                                                SizedBox(
                                                  height: 5,
                                                ),
                                                Text(note,
                                                    style:
                                                        TextStyle(fontSize: 15))
                                              ],
                                            )))
                                      ]);
                                    });
                              });
                            } else {
                              print(e);

                              print('try again');
                            }

                            setState(() {
                              waitCircle = false;
                            });
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ]))),
        ));
  }
}
