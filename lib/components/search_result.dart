import 'package:flutter/material.dart';
import 'package:min_poetry_flutter/api/fetch.dart';
import 'package:min_poetry_flutter/components/author_card.dart';
import 'package:min_poetry_flutter/components/poetry_card.dart';
import 'package:min_poetry_flutter/components/user_card.dart';
import 'package:min_poetry_flutter/constants.dart';
import 'package:min_poetry_flutter/model/author.dart';
import 'package:min_poetry_flutter/model/poetries.dart';
import 'package:min_poetry_flutter/model/poetry.dart';
import 'package:min_poetry_flutter/model/user.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchResult extends StatefulWidget {
  SearchResult({this.query});
  final String query;
  @override
  _SearchResultState createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  List tabs = ['诗词', '标题', '诗人', '用户'];
  List<Widget> tabWidgets = [];
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: tabs.length, vsync: this);
    tabWidgets = [
      SearchTabPoetry(query: widget.query),
      SearchTabRhythmic(
        query: widget.query,
      ),
      SearchTabAuthor(
        query: widget.query,
      ),
      SearchTabUser(query: widget.query)
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height,
        // decoration: BoxDecoration(color: Colors.red[50]),
        child: Column(
          children: [
            TabBar(
              labelColor: kBlack,
              indicatorColor: Colors.transparent,
              controller: tabController,
              labelPadding: EdgeInsets.symmetric(vertical: 5.0),
              tabs: tabs
                  .map((e) => Tab(
                        child: Text(
                          e,
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ))
                  .toList(),
            ),
            Expanded(
              child: TabBarView(
                controller: tabController,
                children: tabWidgets
                    .map((e) => Container(
                          child: e,
                        ))
                    .toList(),
              ),
            ),
          ],
        ));
  }
}

// 诗词结果
class SearchTabPoetry extends StatefulWidget {
  SearchTabPoetry({this.query});
  final String query;
  @override
  _SearchTabPoetryState createState() => _SearchTabPoetryState();
}

class _SearchTabPoetryState extends State<SearchTabPoetry>
    with AutomaticKeepAliveClientMixin {
  int _page = 0;
  int _size = 10;
  bool _fetching = false;
  bool _fetchingAll = false;
  bool _fetchingMore = false;
  List<Poetry> _poetries = [];
  ScrollController _controller;
  Poetries _provider;
  @override
  void initState() {
    super.initState();
    new Future(() => fetch());

    _provider = context.read<Poetries>();
    print('Poetries$_provider');

    _controller = ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent) {
      if (!_fetchingMore && !_fetchingAll) {
        _fetchingMore = true;
        if (mounted) {
          setState(() {});
        }
        fetch();
      }
    }
  }

  Future<String> _fetchUserid() async {
    SharedPreferences refs = await SharedPreferences.getInstance();
    String id = refs.getString('id') ?? '';
    return id;
  }

  void fetch() async {
    String userid = await _fetchUserid();
    List<Poetry> poetries = await Fetch.poetries({
      'page': _page + 1,
      'size': _size,
      'paragraphs': widget.query,
      'userid': userid
    });
    _page += 1;
    _fetching = false;
    _fetchingMore = false;
    _poetries.addAll(poetries);

    _provider.addAll('paras', poetries, _page);
    _fetchingAll = poetries.length < _size;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: Column(
        children: [
          _fetching
              ? Container(
                  child: SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                    ),
                  ),
                )
              : Container(),
          Expanded(
            child: Consumer<Poetries>(
              builder: (context, poetries, child) {
                return ListView.separated(
                  controller: _controller,
                  itemBuilder: (context, index) {
                    if (index == poetries.paras.length) {
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
                    }
                    return PoetryCard(
                      // poetry: _poetries[index],
                      index: index,
                      type: 'paras',
                      query: widget.query,
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                    height: 0.0,
                  ),
                  itemCount: poetries.paras.length + 1,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

// 标题结果
class SearchTabRhythmic extends StatefulWidget {
  SearchTabRhythmic({this.query});
  final String query;
  @override
  _SearchTabRhythmicState createState() => _SearchTabRhythmicState();
}

class _SearchTabRhythmicState extends State<SearchTabRhythmic>
    with AutomaticKeepAliveClientMixin {
  int _page = 0;
  int _size = 10;
  bool _fetching = false;
  bool _fetchingAll = false;
  bool _fetchingMore = false;
  List<Poetry> _poetries = [];
  ScrollController _controller;
  Poetries _provider;
  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration(milliseconds: 100), () {
    //   fetch();
    // });
    // Future.microtask(() => fetch());
    _provider = context.read<Poetries>();
    new Future(() => fetch());
    _controller = ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent) {
      if (!_fetchingMore && !_fetchingAll) {
        _fetchingMore = true;
        if (mounted) {
          setState(() {});
        }
        fetch();
      }
    }
  }

  void fetch() async {
    List<Poetry> poetries = await Fetch.poetries(
        {'page': _page + 1, 'size': _size, 'rhythmic': widget.query});
    _page += 1;
    _fetching = false;
    _fetchingMore = false;
    _poetries.addAll(poetries);
    // Provider.of<Poetries>(context, listen: false)
    //     .addAll('users', poetries, _page);
    _provider..addAll('users', poetries, _page);
    _fetchingAll = poetries.length < _size;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: Column(
        children: [
          _fetching
              ? Container(
                  child: SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                    ),
                  ),
                )
              : Container(),
          Expanded(
            child: Consumer<Poetries>(
              builder: (context, poetreis, child) {
                return ListView.separated(
                  controller: _controller,
                  itemBuilder: (context, index) {
                    if (index == poetreis.users.length) {
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
                    }
                    return PoetryCard(
                      // poetry: _poetries[index],
                      index: index,
                      type: 'users',
                      query: widget.query,
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                    height: 0.0,
                  ),
                  itemCount: poetreis.users.length + 1,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

// 作者结果
class SearchTabAuthor extends StatefulWidget {
  SearchTabAuthor({this.query});
  final String query;
  @override
  _SearchTabAuthorState createState() => _SearchTabAuthorState();
}

class _SearchTabAuthorState extends State<SearchTabAuthor>
    with AutomaticKeepAliveClientMixin {
  int _page = 0;
  int _size = 10;
  bool _fetching = false;
  bool _fetchingAll = false;
  bool _fetchingMore = false;
  List<Poet> _authors = [];
  ScrollController _controller;
  @override
  void initState() {
    super.initState();
    fetch();
    _controller = ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent) {
      if (!_fetchingMore && !_fetchingAll) {
        _fetchingMore = true;
        if (mounted) {
          setState(() {});
        }
        fetch();
      }
    }
  }

  void fetch() async {
    List<Poet> authors = await Fetch.authors(
        {'page': _page + 1, 'size': _size, 'author': widget.query});
    _page += 1;
    _fetching = false;
    _fetchingMore = false;
    _authors.addAll(authors);
    _fetchingAll = authors.length < _size;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: Column(
        children: [
          _fetching
              ? Container(
                  child: SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                    ),
                  ),
                )
              : Container(),
          Expanded(
            child: ListView.separated(
                controller: _controller,
                itemBuilder: (context, index) {
                  if (index == _authors.length) {
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
                  }
                  return AuthorCard(
                      author: _authors[index], query: widget.query);
                },
                separatorBuilder: (context, index) => Divider(
                      height: 0.0,
                    ),
                itemCount: _authors.length + 1),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

// 用户结果
class SearchTabUser extends StatefulWidget {
  SearchTabUser({this.query});
  final String query;
  @override
  _SearchTabUserState createState() => _SearchTabUserState();
}

class _SearchTabUserState extends State<SearchTabUser>
    with AutomaticKeepAliveClientMixin {
  int _page = 0;
  int _size = 10;
  bool _fetching = false;
  bool _fetchingAll = false;
  bool _fetchingMore = false;
  List<User> _users = [];
  ScrollController _controller;
  @override
  void initState() {
    super.initState();
    fetch();
    _controller = ScrollController()..addListener(_scrollListener);
  }

  void _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent) {
      if (!_fetchingMore && !_fetchingAll) {
        _fetchingMore = true;
        if (mounted) {
          setState(() {});
        }
        fetch();
      }
    }
  }

  void fetch() async {
    List<User> users = await Fetch.users(
        {'page': _page + 1, 'size': _size, 'username': widget.query});
    _page += 1;
    _fetching = false;
    _fetchingMore = false;
    _users.addAll(users);
    _fetchingAll = users.length < _size;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: Column(
        children: [
          _fetching
              ? Container(
                  child: SizedBox(
                    width: 24.0,
                    height: 24.0,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                    ),
                  ),
                )
              : Container(),
          Expanded(
            child: ListView.separated(
                controller: _controller,
                itemBuilder: (context, index) {
                  if (index == _users.length) {
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
                  }
                  return UserCard(
                    user: _users[index],
                    query: widget.query,
                  );
                },
                separatorBuilder: (context, index) => Divider(
                      height: 0.0,
                    ),
                itemCount: _users.length + 1),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
