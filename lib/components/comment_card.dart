import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:min_poetry_flutter/components/author_avatar.dart';
import 'package:min_poetry_flutter/constants.dart';
import 'package:min_poetry_flutter/model/comment.dart';

class CommentCard extends StatefulWidget {
  CommentCard({this.comment});
  final Comment comment;
  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200],
            width: 2.0,
            style: BorderStyle.solid,
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
      child: Column(
        children: [
          Row(
            children: [
              AuthorAvatar(
                size: 45,
              ),
              SizedBox(
                width: 10.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.comment.user.username}',
                    style: TextStyle(color: kBlack, fontSize: 15.0),
                  ),
                  SizedBox(
                    height: 4.0,
                  ),
                  Text(
                    '${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(widget.comment?.created ?? '2020-01-01'))}',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 14.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Container(
            alignment: Alignment.topLeft,
            padding: EdgeInsets.fromLTRB(55, 0, 20, 0),
            child: Text(
              '${widget.comment.content}',
              style: TextStyle(
                fontSize: 16.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}
