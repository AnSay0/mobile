import 'package:chat_app/widgets/messageLine.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final textcontroler = TextEditingController();

class ChatScreen2 extends StatefulWidget {
  final String room;
  ChatScreen2({required this.room});
  @override
  _ChatScreen2State createState() => _ChatScreen2State();
}

class _ChatScreen2State extends State<ChatScreen2> {
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
    await for (var messages in _fstore.collection(widget.room).snapshots()) {
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
    print(widget.room);
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
              onPressed: () async {
                var users = await FirebaseFirestore.instance
                    .collection('userdata')
                    .where('email', isEqualTo: 'aymen.jake@gmail.com')
                    .where('Friends', arrayContains:[{'name':'aymenjake'}] )
                ;
               QuerySnapshot query = await users.get();
                query.docs.forEach((element) {
                  print(element.data());
                });
                print('from call');
                //  print(users);
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
              stream:
                  _fstore.collection(widget.room).orderBy('time').snapshots(),
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
                        onPressed: () {
                          messageStream();
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
                    child: ListView(
                  children: liste,
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
                            _fstore.collection(widget.room).add({
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
