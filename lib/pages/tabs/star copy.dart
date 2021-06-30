import 'package:flutter/material.dart';
import 'package:min_poetry_flutter/api/fetch.dart';
import 'package:min_poetry_flutter/components/poetry_card.dart';
import 'package:min_poetry_flutter/model/poetry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabStar extends StatefulWidget {
  @override
  _TabStarState createState() => _TabStarState();
}

class _TabStarState extends State<TabStar> with AutomaticKeepAliveClientMixin {
  ScrollController _controller;
  static int _size = 10;
  List<Poetry> _poetries = [];
  int _page = 0;
  bool _refresh = false;
  bool _fetching = false;
  bool _fetchingAll = false;
  bool _fetchingMore = false;
  String _userid;

  @override
  void initState() {
    _fetchUser();
    super.initState();
    _fetchPoetries();
    _controller = ScrollController()..addListener(_scrollListener);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _fetchUser() async {
    _userid = await _fetchUserid();
    if (mounted) {
      setState(() {});
    }
  }

  Future<String> _fetchUserid() async {
    SharedPreferences refs = await SharedPreferences.getInstance();
    String id = refs.getString('id') ?? '';
    return id;
  }

  void _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent) {
      print('Reached end');
      if (!_fetchingMore && !_fetchingAll) {
        print('Fetching');
        _fetchingMore = true;
        if (mounted) {
          setState(() {});
        }
        _fetchPoetries();
      }
    }
  }

  void _fetchPoetries() async {
    if (_page == 0) {
      _fetching = true;
      if (mounted) {
        setState(() {});
      }
    }
    String userid = await _fetchUserid();
    List<Poetry> poetries = await Fetch.poetries({
      'page': _page + 1,
      'size': _size,
      'userid': userid,
    });
    _page += 1;
    _fetching = false;
    _fetchingMore = false;
    _refresh = false;
    _poetries.addAll(poetries);
    _fetchingAll = poetries.length < _size;
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _onRefresh() async {
    _page = 0;
    _refresh = true;
    _fetchingMore = false;
    _fetchingAll = false;
    _poetries = [];
    if (mounted) {
      setState(() {});
    }
    _fetchPoetries();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      child: Stack(
        children: [
          SafeArea(
            child: Column(
              children: [
                _fetching
                    ? Container(
                        padding: EdgeInsets.all(16.0),
                        alignment: Alignment.center,
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
                  child: RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: ListView.separated(
                      controller: _controller,
                      itemBuilder: (context, index) {
                        if (index == _poetries.length) {
                          return Container(
                            padding: EdgeInsets.all(16.0),
                            alignment: Alignment.center,
                            child: SizedBox(
                              height: 24.0,
                              child: Text(
                                _refresh
                                    ? ''
                                    : _fetchingAll
                                        ? '已全部加载'
                                        : '加载中..',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          );
                        }
                        return PoetryCard(
                          // poetry: _poetries[index],
                          userid: _userid,
                        );
                      },
                      separatorBuilder: (context, index) => Divider(
                        height: .0,
                      ),
                      itemCount: _poetries.length + 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
