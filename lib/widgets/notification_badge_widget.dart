import 'package:flutter/material.dart';

class NotificationBadge extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.0,
      height: 40.0,
      decoration: const BoxDecoration(
        color: Colors.red,
        shape: BoxShape.circle,
      ),
      child:const Center(
        child: Padding(
          padding:  EdgeInsets.all(8.0),
          child: Text(
            '5',
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
    );
  }
}