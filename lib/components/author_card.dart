import 'package:flutter/material.dart';
import 'package:min_poetry_flutter/components/author_avatar.dart';
import 'package:min_poetry_flutter/components/highlight.dart';
import 'package:min_poetry_flutter/constants.dart';
import 'package:min_poetry_flutter/model/author.dart';
import 'package:min_poetry_flutter/pages/author_page.dart';

class AuthorCard extends StatefulWidget {
  AuthorCard({this.author, this.query});
  final Poet author;
  final String query;
  @override
  _AuthorCardState createState() => _AuthorCardState();
}

class _AuthorCardState extends State<AuthorCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (content) => AuthorPage(
                    id: widget.author.id,
                  ),
                ),
              );
            },
            child: AuthorAvatar(
              size: 72,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (content) => AuthorPage(
                        id: widget.author.id,
                      ),
                    ),
                  );
                },
                child: SizedBox(
                  height: 24.0,
                  child: Highlight(
                    text: widget.author.author,
                    query: widget.query,
                    style1: kAuthor.copyWith(
                      fontSize: 18.0,
                    ),
                    style2: kAuthor.copyWith(
                      color: kActive,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                '粉丝: ${widget.author.follower ?? 0}',
                style: TextStyle(
                  fontSize: 15.0,
                ),
              )
            ],
          ),
          Spacer(),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(5.0),
              child: Text(
                '${widget.author.followed == "Y" ? "已关注" : "未关注"}',
                style: TextStyle(fontSize: 15.0),
              ),
              decoration: BoxDecoration(
                  // border: Border.all(color: Colors.red)
                  ),
            ),
          )
        ],
      ),
    );
  }
}
