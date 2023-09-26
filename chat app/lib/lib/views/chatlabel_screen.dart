import 'dart:collection';

import 'package:chat_app/views/chatscreen.dart';
import 'package:chat_app/views/signin_screen.dart';
import 'package:chat_app/views/welcome_screen.dart';
import 'package:chat_app/widgets/buttonmain.dart';
import 'package:chat_app/widgets/chat_screen2.dart';
import 'package:chat_app/widgets/contactCard.dart';
import 'package:chat_app/widgets/searchcontact_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:textfield_search/textfield_search.dart';

class ChatLabelScreen extends StatefulWidget {
  static const String screen = 'chatlabelscreen';
  @override
  _ChatLabelScreenState createState() => _ChatLabelScreenState();
}

class _ChatLabelScreenState extends State<ChatLabelScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    usernames();
  }
/*
  Widget searchList() {
    return ListView.builder(itemBuilder: (context, index) {
      return SearchContact(name: ,)
    });
  }*/

  final _auth = FirebaseAuth.instance;
  List<ContactCard> contactlist = [];
  List<String> names = [];
  late String searchname;
  TextEditingController controller = TextEditingController();
  List<String> Liste = [];
  bool waitCircle = false;
  final _fstore = FirebaseFirestore.instance;
  void messageStream(String searchname) async {
    var messages = await _fstore.collection('userdata').get();
    for (var message in messages.docs) {
      if (message.data().values.contains(searchname))
        print('existe');
      else
        print(message.data().values.contains(searchname));
    }
  }

  void usernames() async {
    var messages = await _fstore.collection('userdata').get();
    for (var message in messages.docs) {
      print(message.get('name')+'from here');
      names.add(message.get('name'));
    }
  }

  void userFriends() async {
    var messages = await _fstore.collection('userdata').get();
    for (var message in messages.docs) {
      var friends = message.get('Friends');
      print(friends);
      HashMap hashMap = new HashMap<String, String>();
      hashMap.addAll(friends);
      var name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
        title: Center(
          child: Text(
            'Chat Rooms',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Colors.purpleAccent.shade400,
        //  leading: Image.asset('assets/logo.png', width: 3, height: 3),
      ),
      body: Column(
        children: [
        Expanded(
          flex: 1,
          child: TextFieldSearch(
              initialList: names,
              label: 'Search for name',
              controller: controller,
              decoration: InputDecoration(
                  hintText: 'Search for contact',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      //  messageStream(controller.text.toString());
                      usernames();
                      userFriends();
                    },
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ))),
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            child: ContactCard(name: 'Public chat (Standard)', icon: Icon(Icons.public)),
            onTap: () {
              Navigator.pushNamed(context, ChatScreen.screen);
            },
          ),
        ),
        Expanded(
            flex: 7,
            child: ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) {
                  child:
                  return GestureDetector(
                      child:ContactCard(
                        name: 'Public chat ${index+1} (Optionel)',
                        icon: Icon(Icons.public)),
                  onTap: (){
                    if(index == 0)
                           Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ChatScreen2(room: 'aa1')));
                           else
                          Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ChatScreen2(room: 'aa2')));
                  },);
                })),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await FirebaseAuth.instance.signOut();
          if (FirebaseAuth.instance.currentUser == null)
            Navigator.pushNamed(context, WelcomeScreen.screen);
        },
        child: Icon(Icons.logout),
        backgroundColor: Colors.purpleAccent.shade400,
      ),
    );
  }
}
