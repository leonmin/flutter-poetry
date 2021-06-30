import 'package:flutter/material.dart';
import 'package:min_poetry_flutter/constants.dart';

class AuthorAvatar extends StatelessWidget {
  AuthorAvatar({this.size, this.active = true});
  final double size;
  final bool active;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.all(3.0),
        child: Container(
          padding: EdgeInsets.all(3.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('asset/images/author.png'),
            radius: 21.0,
          ),
          decoration: BoxDecoration(
            color: Color(0xFFE7EEFB),
            borderRadius: BorderRadius.circular(size / 2),
          ),
        ),
      ),
      height: size,
      width: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: active ? [kTang, kSong] : [Colors.red[100], Colors.white],
          // colors: [Color(0xFFE7EEFB), kSong],
        ),
        borderRadius: BorderRadius.circular(size / 2),
      ),
    );
  }
}
