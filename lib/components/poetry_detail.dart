import 'package:flutter/material.dart';
import 'package:min_poetry_flutter/api/fetch.dart';
import 'package:min_poetry_flutter/components/comment_card.dart';
import 'package:min_poetry_flutter/components/poetry_card.dart';
import 'package:min_poetry_flutter/constants.dart';
import 'package:min_poetry_flutter/model/comment.dart';
import 'package:min_poetry_flutter/model/poetries.dart';
import 'package:min_poetry_flutter/model/poetry.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PoetryDetail extends StatefulWidget {
  PoetryDetail({
    this.id,
    this.type,
    this.index,
    this.enableAuthor = false,
    this.enablePoetry = false,
    Key key,
  }) : super(key: key);
  final String id; // 诗词id
  final String type; // 列表类型
  final int index; // 列表序号
  final bool enableAuthor;
  final bool enablePoetry;
  @override
  PoetryDetailState createState() => PoetryDetailState();
}

class PoetryDetailState extends State<PoetryDetail> {
  ScrollController _scrollController;
  PanelController _slidingController = PanelController();
  TextEditingController _editController = TextEditingController();
  int _page = 0;
  int _size = 20;
  bool _fetchingAll = false;
  bool _fetchingMore = false;
  List<Comment> _comments = [];
  // String _id = '';
  String _order = '0'; // 评论排序
  String _content = '0'; // 评论内容
  Poetry _poetry;
  Poetries _provider;

  @override
  void initState() {
    _scrollController = ScrollController()..addListener(_scrollListener);
    super.initState();
    _provider = context.read<Poetries>();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  void _fetchComments() async {
    if (_poetry != null && _poetry.id != null) {
      Map<String, dynamic> params = {
        'size': _size,
        'page': _page + 1,
        'poetryid': _poetry.id
      };
      if (_order == '0') {
        params['vote'] = 'Y';
      } else if (_order == '1') {
        params['vote'] = '';
      }
      print('@@@coment id${_poetry.id}');
      List<Comment> comments = await Fetch.comments(params);
      _page += 1;
      _fetchingMore = false;
      _comments.addAll(comments);
      _fetchingAll = comments.length < _size;
      print('comment fetch all${comments.length}-$_size');
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _handleComment() async {
    if (_content != null && _content != '') {
      Comment c = await Fetch.comment({
        'id': _poetry.id,
        'content': _content,
      });
      if (c != null && c.id != null) {
        _comments.insert(0, c);
        if (widget.type != null && _poetry != null && _poetry.id != null) {
          // Provider.of<Poetries>(context, listen: false).updateAll(
          //   _poetry.id,
          //   widget.type,
          //   'comment',
          //   _poetry.comment + 1,
          // );
          _provider.updateAll(
            _poetry.id,
            widget.type,
            'comment',
            _poetry.comment + 1,
          );
        }
        _slidingController.close();
        if (mounted) {
          setState(() {});
        }
      }
    }
  }

  void handleRefresh(Poetry poetry) {
    _poetry = poetry;
    if (mounted) {
      setState(() {});
    }
    _handleRefresh();
  }

  void _handleRefresh() async {
    print('refresh${_poetry?.id}');
    _page = 0;
    _fetchingMore = false;
    _fetchingAll = false;
    _comments = [];
    if (mounted) {
      setState(() {});
    }
    _fetchComments();
  }

  void _scrollListener() {
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent) {
      if (!_fetchingMore && !_fetchingAll) {
        _fetchingMore = true;
        if (mounted) {
          setState(() {});
        }
        _fetchComments();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Container(
            color: bg,
            child: Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Container(
                          child: Column(
                            children: [
                              PoetryCard(
                                type: widget.type,
                                index: widget.index,
                                enableAuthor: widget.enableAuthor,
                                enablePoetry: widget.enablePoetry,
                              ),
                              SizedBox(height: 10.0),
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
                                        _handleRefresh();
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
                                        _handleRefresh();
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
                                          borderRadius: BorderRadius.circular(
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
                              ),
                            ],
                          ),
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
          maxHeight: MediaQuery.of(context).size.height * 0.5,
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
                      child: GestureDetector(
                        onTap: () {
                          _slidingController.close();
                          _editController.clear();
                        },
                        child: Text(
                          '取消',
                          style: TextStyle(
                            color: kBlack,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        _handleComment();
                        // if (_content != '') {
                        //   _handleComment();
                        // }
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
                          controller: _editController,
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
        ),
      ],
    );
  }
}
