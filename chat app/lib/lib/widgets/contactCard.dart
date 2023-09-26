import 'package:flutter/material.dart';

import '../views/chatscreen.dart';

class ContactCard extends StatelessWidget {
  final String name;
  final Icon icon;
  ContactCard({required this.name,required this.icon});
  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.blue.shade400,
        child: SizedBox(
          child: Row(
            children: [
              IconButton(
                iconSize: 40,
                icon: icon,
                onPressed: () {
                  Navigator.pushNamed(context, ChatScreen.screen);
                },
              ),
              /*  Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(20),
              color: Colors.blueAccent,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: */
              Text(
                name,
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              //  ))
            ],
          ),
        ));
  }
}
