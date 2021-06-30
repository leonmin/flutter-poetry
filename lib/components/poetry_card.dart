import 'dart:async';

import 'package:flutter/material.dart';
import 'package:min_poetry_flutter/api/fetch.dart';
import 'package:min_poetry_flutter/components/author_avatar.dart';
import 'package:min_poetry_flutter/components/highlight.dart';
import 'package:min_poetry_flutter/constants.dart';
import 'package:min_poetry_flutter/model/poetries.dart';
import 'package:min_poetry_flutter/model/poetry.dart';
import 'package:min_poetry_flutter/pages/author_page.dart';
import 'package:min_poetry_flutter/pages/poetry_page.dart';
import 'package:min_poetry_flutter/utils/bus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PoetryCard extends StatefulWidget {
  PoetryCard({
    this.index,
    this.type,
    this.query = '',
    this.userid,
    this.enableAuthor = true,
    this.enablePoetry = true,
    Key key,
  }) : super(key: key);
  final int index;
  final String type;
  final String query;
  final String userid;
  // 控制头像跳转
  final bool enableAuthor;
  final bool enablePoetry;
  @override
  PoetryCardState createState() => PoetryCardState();
}

class PoetryCardState extends State<PoetryCard> {
  // 布局 layout 0 正常 1 行布局
  String _layout = '0';
  StreamSubscription<SettingEvent> _event;

  @override
  void initState() {
    _fetchLayout();
    // _fetchAction();
    _event = EventbusUtil.getInstance().on<SettingEvent>().listen((data) {
      if (data.status == 'layout') {
        _fetchLayout();
      }
    });
    super.initState();
  }

  void _fetchLayout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _layout = prefs.get('layout') ?? '0';
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<Poetries>(builder: (context, poetries, child) {
      Poetry poetry;
      print('find${widget.type}-${widget.index}');

      if (widget.type != null && widget.index != null) {
        poetry = poetries.find(widget.type, widget.index);
      }

      if (poetry != null) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
          child: Column(
            children: [
              // 头像, 姓名
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      if (widget.enableAuthor) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (content) => AuthorPage(
                              type: widget.type,
                              index: widget.index,
                              id: poetry.poet.id,
                            ),
                          ),
                        );
                      }
                    },
                    child: AuthorAvatar(
                      active: widget.enableAuthor,
                      size: 54,
                    ),
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  GestureDetector(
                    onTap: () {
                      print('enable');
                      if (widget.enableAuthor) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (content) => AuthorPage(
                              id: poetry.poet?.id ?? '',
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      poetry.author,
                      style: kAuthor,
                    ),
                  ),
                  SizedBox(
                    width: 10.0,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 0.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.red[200],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                        bottomLeft: Radius.elliptical(5.0, 5.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                    ),
                    child: Text(
                      poetry.type == '0' ? '诗' : '词',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Spacer(),
                  Image.asset(
                    'asset/images/more.png',
                    width: 32.0,
                    height: 32.0,
                  ),
                ],
              ),
              SizedBox(
                height: 12.0,
              ),
              // 标题, 正文
              GestureDetector(
                onTap: () {
                  if (widget.enablePoetry) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (content) => PoetryPage(
                          type: widget.type,
                          index: widget.index,
                          poetry: poetry,
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  color: Colors.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Container(
                        alignment: Alignment.centerLeft,
                        height: 30.0,
                        child: _highRhythmic(
                            widget.enablePoetry
                                ? '#' + poetry.rhythmic + '#'
                                : poetry.rhythmic,
                            widget.query),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: _layout == '1'
                            ? _highParagraphsLines(
                                poetry.paragraphs, widget.query)
                            : _highParagraphs(poetry.paragraphs, widget.query),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            var poetries = context.read<Poetries>();
                            if (poetry.id != null && poetry.liked != null) {
                              if (poetry.liked == 'Y') {
                                String r =
                                    await Fetch.unlike({'id': poetry.id});
                                if (r == 'OK') {
                                  if (poetry.like > 0) {
                                    // poetries.update(widget.index, widget.type,
                                    //     'like', poetry.like - 1);
                                    poetries.updateAll(poetry.id, widget.type,
                                        'like', poetry.like - 1);
                                  }
                                  // poetries.update(
                                  //     widget.index, widget.type, 'liked', 'N');
                                  poetries.updateAll(
                                      poetry.id, widget.type, 'liked', 'N');
                                  EventbusUtil.getInstance()
                                      .fire(LoginEvent('profile'));
                                }
                              } else {
                                String r = await Fetch.like({'id': poetry.id});
                                if (r == 'OK') {
                                  // poetries.update(widget.index, widget.type,
                                  //     'like', poetry.like + 1);
                                  // poetries.update(
                                  //     widget.index, widget.type, 'liked', 'Y');
                                  poetries.updateAll(poetry.id, widget.type,
                                      'like', poetry.like + 1);
                                  poetries.updateAll(
                                      poetry.id, widget.type, 'liked', 'Y');
                                  EventbusUtil.getInstance()
                                      .fire(LoginEvent('profile'));
                                }
                              }
                            }
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                poetry.liked == 'Y'
                                    ? 'asset/images/like_fill.png'
                                    : 'asset/images/like.png',
                                width: 32.0,
                                height: 32.0,
                              ),
                              SizedBox(
                                width: 4.0,
                              ),
                              Text(
                                '${poetry.like}',
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: () {
                        if (widget.enablePoetry) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (content) => PoetryPage(
                                type: widget.type,
                                index: widget.index,
                                poetry: poetry,
                              ),
                            ),
                          );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'asset/images/cmt.png',
                            width: 27.0,
                            height: 27.0,
                          ),
                          SizedBox(
                            width: 4.0,
                          ),
                          Text(
                            '${poetry.comment > 0 ? poetry.comment : "评论"}',
                            style: TextStyle(
                              fontSize: 15.0,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (poetry.id != null && poetry.favored != null) {
                              if (poetry.favored == 'Y') {
                                String r =
                                    await Fetch.unfavor({'id': poetry.id});
                                if (r == 'OK') {
                                  // poetries.update(widget.index, widget.type,
                                  //     'favored', 'N');
                                  poetries.updateAll(
                                      poetry.id, widget.type, 'favored', 'N');
                                  EventbusUtil.getInstance()
                                      .fire(LoginEvent('profile'));
                                }
                              } else {
                                String r = await Fetch.favor({'id': poetry.id});
                                if (r == 'OK') {
                                  // poetries.update(widget.index, widget.type,
                                  //     'favored', 'Y');
                                  poetries.updateAll(
                                      poetry.id, widget.type, 'favored', 'Y');
                                  EventbusUtil.getInstance()
                                      .fire(LoginEvent('profile'));
                                }
                              }
                            }
                          },
                          child: Image.asset(
                            poetry.favored == 'Y'
                                ? 'asset/images/fav_fill.png'
                                : 'asset/images/fav.png',
                            width: 27.0,
                            height: 27.0,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
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
        );
      } else {
        return Container();
      }
    });
  }

  Widget _highParagraphs(List<String> paragraphs, String query) {
    var ps = paragraphs.join('');
    return Highlight(
      text: ps,
      query: query,
      style1: kParagraphs,
      style2: kParagraphs.copyWith(color: kActive),
    );
  }

  Widget _highParagraphsLines(List<String> paragraphs, String query) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: paragraphs.map((e) {
        if (query != '') {
          return Highlight(
            text: e,
            query: query,
            style1: kParagraphs,
            style2: kParagraphs.copyWith(color: kActive),
          );
        } else {
          return Text(
            e,
            style: kParagraphs,
          );
        }
      }).toList(),
    );
  }

  Widget _highRhythmic(String rhythmic, String query) {
    return Highlight(
      text: rhythmic,
      query: query,
      style1: kRhythmic,
      style2: kRhythmic.copyWith(color: kActive),
    );
  }
}
