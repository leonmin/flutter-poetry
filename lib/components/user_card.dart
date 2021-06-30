import 'package:flutter/material.dart';
import 'package:min_poetry_flutter/components/author_avatar.dart';
import 'package:min_poetry_flutter/components/highlight.dart';
import 'package:min_poetry_flutter/constants.dart';
import 'package:min_poetry_flutter/model/user.dart';

class UserCard extends StatefulWidget {
  UserCard({this.user, this.query});
  final User user;
  final String query;
  @override
  _UserCardState createState() => _UserCardState();
}

class _UserCardState extends State<UserCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AuthorAvatar(
            size: 72,
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 24.0,
                child: Highlight(
                  text: widget.user.neckname,
                  query: widget.query,
                  style1: kUsername,
                  style2: kUsername.copyWith(color: kActive),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '关注: ${widget.user.follow ?? 0}',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              )
            ],
          ),
          Spacer(),
        ],
      ),
    );
  }
}
