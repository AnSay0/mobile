import 'package:chat_app/views/chatlabel_screen.dart';
import 'package:chat_app/views/chatscreen.dart';
import 'package:chat_app/widgets/buttonmain.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../widgets/buttonsign.dart';

class SignupScreen extends StatefulWidget {
  static const String screen = 'signupscreen';
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  final _auth = FirebaseAuth.instance;
  final _userstore = FirebaseFirestore.instance;
  late var _email;
  late var _name;
  late var _password;
  final _textcontroleremail = TextEditingController();
  final _textcontrolername = TextEditingController();
  final _textcontrolerpassword = TextEditingController();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Container(
                child: ListView(children: [
              SizedBox(
                height: 60,
              ),
              Container(
                height: 120,
                child: Image.asset('assets/logo.png', width: 70, height: 120),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Column(
                  children: [
                    TextFormField(
                        controller: _textcontroleremail,
                        validator: (val) {
                          if (val!.isEmpty || val.length > 100) {
                            return 'Check email field rules';
                          } else
                            return null;
                        },
                        onChanged: (value) {
                          _email = value;
                        },
                        onSaved: (val) {
                          _email = val;
                        },
                        decoration: InputDecoration(
                            hintText: 'Email',
                            suffixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ))),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                        controller: _textcontrolername,
                        validator: (val) {
                          var users = FirebaseFirestore.instance
                              .collection('userdata')
                              .where('name',
                                  isEqualTo: _textcontrolername.text.toString())
                              .get();
                          print(users);
                          
                            if (val!.isEmpty || val.length < 6) {
                              return 'Check Username field rules';
                            } else
                              return null;
                       
                        },
                        onChanged: (value) {
                          _name = value;
                        },
                        onSaved: (val) {
                          _name = val;
                        },
                        decoration: InputDecoration(
                            hintText: 'User name',
                            suffixIcon: Icon(Icons.perm_identity),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ))),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _textcontrolerpassword,
                      validator: (val) {
                        if (val!.isEmpty || val.length < 6) {
                          return 'Check password field rules';
                        } else
                          return null;
                      },
                      onSaved: (val) {
                        _password = val;
                      },
                      obscureText: true,
                      onChanged: (value) {
                        _password = value;
                      },
                      obscuringCharacter: "*",
                      decoration: InputDecoration(
                          hintText: "Password",
                          suffixIcon: Icon(
                            Icons.lock,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                    MybuttonSign(
                      color: Colors.lightBlue,
                      title: 'Registre',
                      onpressed: () async {
                        try {
                          var data = formKey.currentState;

                          if (data!.validate()) {
                            final user =
                                await _auth.createUserWithEmailAndPassword(
                                    email: _email, password: _password);
                            _userstore.collection('userdata').add({
                              "name": _name,
                              "email": _email,
                              "password": _password
                            });

                            User? user1 = FirebaseAuth.instance.currentUser;
                            await user1!.sendEmailVerification();
                            setState(() async {
                              _textcontrolername.clear();
                              _textcontroleremail.clear();
                              _textcontrolerpassword.clear();
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
                                                    Text('Registration succes',
                                                        style: TextStyle(
                                                            color: Colors.green,
                                                            fontSize: 25)),
                                                    Icon(
                                                      Icons.check,
                                                      color: Colors.green,
                                                    ),
                                                  ]),
                                              SizedBox(
                                                height: 5,
                                              ),
                                              Text(
                                                  'We sent a confirmation message to your email',
                                                  style:
                                                      TextStyle(fontSize: 15))
                                            ],
                                          ))
                                    ]);
                                  });
                            });
                          } else {
                            setState(() async {
                              _textcontrolername.clear();
                              _textcontroleremail.clear();
                              _textcontrolerpassword.clear();
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
                                                  Text('Registration failed',
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
                                            Text('Form not valide try again',
                                                style: TextStyle(fontSize: 15))
                                          ],
                                        ),
                                      )
                                    ]);
                                  });
                            });
                          }
                        } catch (e) {}
                      },
                    ),
                  ],
                ),
              )
            ]))));
  }
}
