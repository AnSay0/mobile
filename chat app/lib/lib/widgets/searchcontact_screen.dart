import 'package:flutter/material.dart';
class SearchContact extends StatelessWidget {
  final String name;

   SearchContact({required this.name});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name,style: TextStyle(color: Colors.purpleAccent.shade200),),
          IconButton(onPressed: (){}, icon: Icon(Icons.message)),
        ],
      ),
    );
  }
}