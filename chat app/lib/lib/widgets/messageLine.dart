import 'package:flutter/material.dart';

class MessageLine extends StatelessWidget {
  final String message;
  final String sender;
  final CrossAxisAlignment cross;
  final Color color;
  final Radius edge1;
  final Radius edge2;
  final Widget widget;
  MessageLine({
    required this.message,
    required this.sender,
    required this.cross,
    required this.color,
    required this.edge1,
    required this.edge2,
    required this.widget
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.all(7.0),
        child: SizedBox(
          child: Column(
            crossAxisAlignment: cross,
            children: [
                 
                     Text(
                  sender,
                  style: TextStyle(color: Colors.blueGrey, fontSize: 12),
                ),
          
          Container(height: 63,child:Stack(children : [ 
              
             Positioned(right: 0,bottom:0,child:widget ) ,
             
             
              Material(
                  elevation: 5,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      topLeft: edge1,
                      topRight: edge2),
                  color: color,
                  child: Padding(
                    padding: EdgeInsets.all(7.0),
                    child: Text(
                      message,
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    
              )),
              ])
                    )
            ],
          ),
        ));
  }
}
