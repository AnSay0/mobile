import 'package:flutter/material.dart';

class Mybutton extends StatelessWidget {
  @override
  Mybutton({required this.color, required this.title,required this.image, required this.onpressed});
  final Color color;
  final String title;
  final String image;
  final VoidCallback onpressed;

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        elevation: 5,
        color: color,
        borderRadius: BorderRadius.circular(10),
        child: MaterialButton(
          onPressed: onpressed,
          minWidth: 200,
          height: 40,
          child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,children: [Text(title),Image.asset(image,width: 20,height: 20,)]),
        ),
      ),
    );
  }
}
