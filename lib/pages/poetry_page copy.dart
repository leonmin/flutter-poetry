import 'package:flutter/material.dart';
import 'package:min_poetry_flutter/api/fetch.dart';
import 'package:min_poetry_flutter/components/comment_card.dart';
import 'package:min_poetry_flutter/components/poetry_card.dart';
import 'package:min_poetry_flutter/constants.dart';
import 'package:min_poetry_flutter/model/comment.dart';
import 'package:min_poetry_flutter/model/poetries.dart';
import 'package:min_poetry_flutter/model/poetry.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PoetryPage extends StatefulWidget {
  PoetryPage({this.index, this.id, this.poetry, this.type});
  final String id; // 诗词id
  final int index; // 列表中的序号
  final String type; // 列表类型
  final Poetry poetry;

  @override
  _PoetryPageState createState() => _PoetryPageState();
}

class _PoetryPageState extends State<PoetryPage> {
  GlobalKey<PoetryCardState> _poetryPageKey = GlobalKey<PoetryCardState>();
  Poetry _poetry;
  int _page = 0;
  int _size = 20;
  // bool _fetching = false;
  bool _fetchingAll = false;
  bool _fetchingMore = false;
  List<Comment> _comments = [];
  ScrollController _controller;
  PanelController _slidingController = PanelController();
  TextEditingController _textController = TextEditingController();
  bool _isComment = true;
  String _commentHint = '';
  String _replyHint = '';
  String _content = '';
  String _order = '0';
  Poetries _provider;

  @override
  void initState() {
    if (widget.poetry == null && widget.id != null) {
      _fetchPoetry();
    }

    _fetchComments();
    _controller = ScrollController()..addListener(_scrollListener);

    super.initState();
    _provider = context.read<Poetries>();
  }

  Future<String> _fetchUserid() async {
    SharedPreferences refs = await SharedPreferences.getInstance();
    String id = refs.getString('id') ?? '';
    return id;
  }

  void _fetchComments() async {
    if (widget.poetry != null && widget.poetry.id != null) {
      Map<String, dynamic> params = {
        'size': _size,
        'page': _page + 1,
        'poetryid': widget.poetry.id
      };
      if (_order == '0') {
        params['vote'] = 'Y';
      } else if (_order == '1') {
        params['vote'] = '';
      }
      List<Comment> comments = await Fetch.comments(params);
      _page += 1;
      _fetchingMore = false;
      _comments.addAll(comments);
      _fetchingAll = comments.length < _size;
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _onComment() async {
    String content = _textController.text ?? '';
    if (content != '') {
      Comment c = await Fetch.comment({
        'id': widget.poetry.id,
        'content': content,
      });
      if (c != null && c.id != null) {
        _comments.insert(0, c);
        // _poetryPageKey.currentState.handleComment();
        if (widget.id != null && widget.type != null) {
          // Provider.of<Poetries>(context, listen: false).updateAll(
          //     widget.id, widget.type, 'comment', widget.poetry.comment + 1);
          _provider.updateAll(
              widget.id, widget.type, 'comment', widget.poetry.comment + 1);
        }
        _slidingController.close();
        if (mounted) {
          setState(() {});
        }
      }
    }
  }

  void _fetchPoetry() async {
    String userid = await _fetchUserid();
    Poetry poetry = await Fetch.poetry({
      'id': widget.id,
      'userid': userid,
    });
    _poetry = poetry;
    if (mounted) {
      setState(() {});
    }
    _fetchComments();
  }

  void _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent) {
      if (!_fetchingMore && !_fetchingAll) {
        _fetchingMore = true;
        if (mounted) {
          setState(() {});
        }
        _fetchComments();
      }
    }
  }

  void _refreshComments() async {
    _page = 0;
    _fetchingMore = false;
    _fetchingAll = false;
    _comments = [];
    if (mounted) {
      setState(() {});
    }
    _fetchComments();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.grey[200],
        automaticallyImplyLeading: true,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(
            Icons.arrow_back,
            color: kBlack,
            size: 30,
          ),
        ),
        title: Text(
          '${widget.poetry?.rhythmic ?? ''}',
          style: TextStyle(
            color: kBlack,
          ),
        ),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    controller: _controller,
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return widget.poetry != null
                            ? Container(
                                child: Column(
                                  children: [
                                    PoetryCard(
                                        // poetry: _poetry,
                                        type: widget.type,
                                        // poetry: widget.poetry,
                                        index: widget.index,
                                        enableAuthor: false,
                                        enablePoetry: false,
                                        key: _poetryPageKey),
                                    SizedBox(
                                      height: 10.0,
                                    ),
                                    Container(
                                      height: 50.0,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 20.0,
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
                                      child: Row(
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              _order = '0';
                                              _refreshComments();
                                            },
                                            child: Text(
                                              '热度',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: _order == '0'
                                                    ? Colors.red
                                                    : kBlack,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                              horizontal: 10.0,
                                            ),
                                            child: Container(
                                              width: 1.0,
                                              height: 18.0,
                                              color: Colors.grey[500],
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              _order = '1';
                                              _refreshComments();
                                            },
                                            child: Text(
                                              '时间',
                                              style: TextStyle(
                                                fontSize: 16.0,
                                                color: _order == '1'
                                                    ? Colors.red
                                                    : kBlack,
                                              ),
                                            ),
                                          ),
                                          Spacer(),
                                          GestureDetector(
                                            onTap: () {
                                              _slidingController.open();
                                            },
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 10.0,
                                                vertical: 5.0,
                                              ),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  width: 1.0,
                                                  color: Colors.red,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  30.0,
                                                ),
                                              ),
                                              child: Text(
                                                '写评论',
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              )
                            : Container(
                                height: 100.0,
                              );
                      } else if (index == (_comments.length + 1)) {
                        return Container(
                          padding: EdgeInsets.all(
                            16.0,
                          ),
                          alignment: Alignment.center,
                          child: SizedBox(
                            height: 24.0,
                            child: Text(_fetchingAll ? '已全部加载' : '加载中..'),
                          ),
                        );
                        ;
                      } else {
                        return Container(
                          child: CommentCard(
                            comment: _comments[index - 1],
                          ),
                        );
                      }
                    },
                    separatorBuilder: (context, index) => Divider(
                      height: 0.0,
                    ),
                    itemCount: _comments.length + 2,
                  ),
                ),
              ],
            ),
          ),
          SlidingUpPanel(
            backdropEnabled: true,
            controller: _slidingController,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(34.0),
              topRight: Radius.circular(34.0),
            ),
            boxShadow: [],
            color: Colors.white,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            minHeight: 0.0,
            panel: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 12.0,
                      bottom: 16.0,
                    ),
                    child: Container(
                      width: 42.0,
                      height: 4.0,
                      decoration: BoxDecoration(
                        color: Color(0xFFC5CBD6),
                        borderRadius: BorderRadius.circular(2.0),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(
                            20.0,
                          ),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 15.0,
                          vertical: 5.0,
                        ),
                        child: Text(
                          '取消',
                          style: TextStyle(
                            color: kBlack,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          if (_content != '') {
                            _onComment();
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: _content != '' ? kActive : Colors.grey[200],
                            borderRadius: BorderRadius.circular(
                              20.0,
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.0,
                            vertical: 5.0,
                          ),
                          child: Text(
                            '发布',
                            style: TextStyle(
                              color: _content != '' ? Colors.white : kBlack,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(20.0, 5.0, 20.0, 20.0),
                    child: Column(
                      children: [
                        Expanded(
                          child: TextField(
                            onChanged: (val) {
                              _content = val;
                              if (mounted) {
                                setState(() {});
                              }
                            },
                            style: TextStyle(
                              fontSize: 18.0,
                            ),
                            decoration: InputDecoration(
                              hintText:
                                  '请发表与诗词相关的内容.\n每首诗词都有它的故事,\n你也有你的故事,\n只不过换了时间,\n换了个地点.\n',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(0.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            controller: _textController,
                            maxLines: 99,
                            maxLength: 400,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
