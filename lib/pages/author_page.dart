import 'package:flutter/material.dart';
import 'package:min_poetry_flutter/api/fetch.dart';
import 'package:min_poetry_flutter/components/poetry_card.dart';
import 'package:min_poetry_flutter/constants.dart';
import 'package:min_poetry_flutter/model/author.dart';
import 'package:min_poetry_flutter/model/poetries.dart';
import 'package:min_poetry_flutter/model/poetry.dart';
import 'package:min_poetry_flutter/utils/bus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthorPage extends StatefulWidget {
  AuthorPage({this.id, this.type, this.index}); // 诗人id
  final int index; // 列表中的序号
  final String type; // 列表类型
  final String id;
  @override
  _AuthorPageState createState() => _AuthorPageState();
}

class _AuthorPageState extends State<AuthorPage> {
  Poet _author;
  int _page = 0;
  int _size = 10;
  bool _fetchingAll = false;
  bool _fetchingMore = false;
  ScrollController _controller;
  Poetries _provider;
  @override
  void initState() {
    // Future.delayed(Duration(milliseconds: 0), () {
    //   Provider.of<Poetries>(context, listen: false).refresh('poets');
    // });

    // Future.microtask(
    //     () => Provider.of<Poetries>(context, listen: false).refresh('poets'));
    new Future(
        // () => Provider.of<Poetries>(context, listen: false).refresh('poets'));
        () => _provider.refresh('poets'));
    _fetchAuthor();
    _fetchPoetry();
    _controller = ScrollController()..addListener(_scrollListener);
    super.initState();
    _provider = context.read<Poetries>();
  }

  void _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent) {
      if (!_fetchingMore && !_fetchingAll) {
        _fetchingMore = true;
        if (mounted) {
          setState(() {});
        }
        _fetchPoetry();
      }
    }
  }

  void _fetchPoetry() async {
    String userid = await _fetchUserid();
    List<Poetry> poetries = await Fetch.poetries({
      'page': _page + 1,
      'size': _size,
      'authorid': widget.id,
      'userid': userid,
    });
    _page += 1;
    // _fetching = false;
    _fetchingMore = false;
    // _poetries.addAll(poetries);
    // Provider.of<Poetries>(context, listen: false)
    //     .addAll('poets', poetries, _page);
    _provider.addAll('poets', poetries, _page);
    _fetchingAll = poetries.length < _size;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    print('author page dispose');

    _controller?.dispose();
    super.dispose();
  }

  Future<String> _fetchUserid() async {
    SharedPreferences refs = await SharedPreferences.getInstance();
    String id = refs.getString('id') ?? '';
    return id;
  }

  void _fetchAuthor() async {
    if (widget.id != null && widget.id != '') {
      String userid = await _fetchUserid();
      Poet author = await Fetch.author({
        'id': widget.id,
        'userid': userid,
      });
      _author = author;
      if (mounted) {
        setState(() {});
      }
    }
  }

  void _onFollow() async {
    if (_author.followed == 'Y') {
      String r = await Fetch.unfollow({'id': _author.id});
      if (r == 'OK') {
        _fetchAuthor();
        EventbusUtil.getInstance().fire(LoginEvent('profile'));
      }
    } else {
      String r = await Fetch.follow({'id': _author.id});
      if (r == 'OK') {
        _fetchAuthor();
        EventbusUtil.getInstance().fire(LoginEvent('profile'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        backgroundColor: Colors.grey[200],
        automaticallyImplyLeading: true,
        brightness: Brightness.light,
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
          '${_author?.author ?? ''}',
          style: TextStyle(color: kBlack),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: Consumer<Poetries>(
              builder: (context, poetries, child) {
                return ListView.separated(
                  controller: _controller,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return _author != null
                          ? Column(
                              children: [
                                Container(
                                  color: Colors.white,
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(top: 24.0),
                                  child: Container(
                                    width: 80.0,
                                    height: 80.0,
                                    child: CircleAvatar(
                                      backgroundImage:
                                          AssetImage('asset/images/author.png'),
                                    ),
                                  ),
                                ),
                                Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.fromLTRB(0, 15, 0, 5),
                                  // horizontal: 20.0,
                                  // vertical: 15.0,
                                  // ),
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _author?.author ?? '',
                                        style: TextStyle(
                                          fontSize: 18.0,
                                          color: kBlack,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(width: 10.0),
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
                                            bottomLeft:
                                                Radius.elliptical(5.0, 5.0),
                                            bottomRight: Radius.circular(10.0),
                                          ),
                                        ),
                                        child: Text(
                                          (_author?.type ?? '0') == '0'
                                              ? '诗'
                                              : '词',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 5.0, 0, 10.0),
                                  alignment: Alignment.center,
                                  color: Colors.white,
                                  child: Text(
                                    '${_author?.follower ?? 0}人关注',
                                    style: TextStyle(
                                      color: kBlack,
                                    ),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.only(bottom: 20.0),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border(
                                      bottom:
                                          BorderSide(color: Colors.grey[300]),
                                    ),
                                  ),
                                  child: GestureDetector(
                                    onTap: _onFollow,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 5.0,
                                        horizontal: 10.0,
                                      ),
                                      decoration: BoxDecoration(
                                          color: _author.followed == 'Y'
                                              ? Colors.red
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(50.0),
                                          border:
                                              Border.all(color: Colors.red)),
                                      child: Text(
                                        _author.followed == 'Y' ? '正在关注' : '关注',
                                        style: TextStyle(
                                            color: _author.followed == 'Y'
                                                ? Colors.white
                                                : Colors.red),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : Container(
                              height: 200.0,
                            );
                    } else if (index == (poetries.poets.length + 1)) {
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
                      return PoetryCard(
                        index: index - 1,
                        type: 'poets',
                        // poetry: poetries.poets[index - 1],
                        enableAuthor: false,
                      );
                    }
                  },
                  separatorBuilder: (context, index) => Divider(
                    height: 0.0,
                  ),
                  itemCount: (poetries.poets.length + 2),
                );
              },
            )),
          ],
        ),
      ),
    );
  }
}
