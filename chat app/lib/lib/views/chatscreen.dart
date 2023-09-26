import 'package:chat_app/widgets/messageLine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final textcontroler = TextEditingController();

class ChatScreen extends StatefulWidget {
  static const String screen = 'chatscreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final _fstore = FirebaseFirestore.instance;
  late String message;
  late String written;

  late User appuser;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authentificationUser();
  }

  void authentificationUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        appuser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void messageStream() async {
    await for (var messages in _fstore.collection('aa').snapshots()) {
      for (var message in messages.docs) {
        print(message.data().entries);
      }
    }
  }

  dialog() async {
    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(actions: [
            Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Dont touche !',
                              style: TextStyle(
                                  color: Colors.purpleAccent, fontSize: 25)),
                          Icon(
                            Icons.report_problem,
                            color: Colors.purpleAccent,
                          ),
                        ]),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                        'Thats will hurts you ... kidding its still in maintenance',
                        style: TextStyle(fontSize: 15))
                  ],
                ))
          ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[100],
      appBar: AppBar(
          title: Text(
            'Chat Room',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.purpleAccent.shade400,
          actions: [
            IconButton(
              icon: Icon(Icons.call),
              onPressed: () {
                dialog();
              },
            ),
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                dialog();
              },
            ),
            IconButton(
              icon: Icon(Icons.more_vert),
              onPressed: () {
                dialog();
              },
            )
          ]),
      body: SafeArea(
          child: Column(
        children: [
          StreamBuilder<QuerySnapshot>(
              stream: _fstore.collection('aa').orderBy('time').snapshots(),
              builder: (context, snapshot) {
                List<MessageLine> liste = [];
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(
                    color: Colors.blue,
                  ));
                }
                final messages = snapshot.data!.docs;
                for (var message in messages) {
                  final messageText = message.get('message');
                  final messageSender = message.get('sender');
                  final messageWidget;
                  if (messageSender == _auth.currentUser!.email) {
                    messageWidget = MessageLine(
                      message: messageText,
                      sender: messageSender,
                      cross: CrossAxisAlignment.end,
                      color: Colors.blueAccent,
                      edge1: Radius.circular(20),
                      edge2: Radius.circular(0),
                      widget: Text(''),
                    );
                  } else {
                    messageWidget = MessageLine(
                      message: messageText,
                      sender: messageSender,
                      cross: CrossAxisAlignment.start,
                      color: Colors.purpleAccent.shade400,
                      edge1: Radius.circular(0),
                      edge2: Radius.circular(20),
                      widget: IconButton(
                        onPressed: () async {
                          //  messageStream();
                          /*   var id = await FirebaseFirestore.instance
                              .collection('aa')
                              .doc('')
                              .update({
                            'message': 'Thanxxxxx',
                            'email': 'wassim079510@gmail.com',
                            'time': FieldValue.serverTimestamp()
                          });*/
                          // print(id);
                          var ide = await FirebaseFirestore.instance
                              .collection('aa')
                              .get()
                              .then((value) => print(value.docs.map((e) {
                                    print(e.get('message'));
                                    print(e.id);
                                  })));
                        },
                        icon: Icon(Icons.person_add_alt),
                        color: Colors.black,
                        iconSize: 13,
                      ),
                    );
                  }
                  liste.add(messageWidget);
                }
                return Expanded(
                    child: ListView.builder(
                  itemCount: liste.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onDoubleTap: () async {
                          var id =
                              await FirebaseFirestore.instance.collection('aa');
                          var ide = await FirebaseFirestore.instance
                              .collection('aa')
                              .get()
                              .then((value) => print(value.docs.map((e) {
                                    if (e.get('message') ==
                                        liste[index].message) id.doc(e.id).update({
                                          'email' : liste[index].sender,
                                          'message' : 'changed now',
                                          'time' : e.get('time')
                                        });
                                  })));
                          print(liste[index].message);
                        },
                        child: liste[index]);
                  },
                  //  children: liste,
                ));
              })
        ],
      )),
      bottomNavigationBar: BottomAppBar(
        color: Colors.blue[50],
        child: SizedBox(
          child: Container(
              child: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.public,
                  color: Colors.blueAccent,
                ),
                onPressed: () {},
              ),
              Container(
                width: 280,
                child: TextField(
                    onChanged: (value) {
                      written = value;
                    },
                    controller: textcontroler,
                    decoration: InputDecoration(
                        hintText: 'Write something ...',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(width: 1.0)),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.send,
                            color: Colors.blueAccent,
                          ),
                          onPressed: () {
                            textcontroler.clear();
                            _fstore.collection('aa').add({
                              'message': written,
                              'sender': _auth.currentUser!.email,
                              'time': FieldValue.serverTimestamp()
                            });
                          },
                        ))),
              )
            ],
          )),
        ),
      ),
    );
  }
}
