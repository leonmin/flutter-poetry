import 'dart:async';

import 'package:flutter/material.dart';
import 'package:min_poetry_flutter/api/fetch.dart';
import 'package:min_poetry_flutter/components/author_avatar.dart';
import 'package:min_poetry_flutter/components/search_result.dart';
import 'package:min_poetry_flutter/constants.dart';
import 'package:min_poetry_flutter/model/poetry.dart';
import 'package:min_poetry_flutter/pages/author_page.dart';
import 'package:min_poetry_flutter/utils/bus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MorePage extends StatefulWidget {
  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage>
    with AutomaticKeepAliveClientMixin {
  Poetry poetry;
  StreamSubscription<SettingEvent> _event;
  String _layout = '0';
  @override
  void initState() {
    _fetchLayout();
    _fetchPoetry();
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

  void _fetchPoetry() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String type = prefs.getString('type') ?? '';
    Poetry p = await Fetch.random({'userid': '', 'type': type});
    poetry = p;
    if (mounted) {
      setState(() {});
    }
    print('$poetry');
  }

  Future<void> _onRefresh() async {
    _fetchPoetry();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: GestureDetector(
          onTap: () {
            showSearch(
              context: context,
              delegate: SearchBarViewDelegate(),
            );
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            alignment: Alignment.centerLeft,
            height: 40.0,
            child: Row(
              children: [
                Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                Text(
                  '请输入..',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(40.0),
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: poetry != null
              ? SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Container(
                    padding: EdgeInsets.all(15.0),
                    color: Colors.grey[100],
                    height: MediaQuery.of(context).size.height,
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (content) => AuthorPage(
                                        id: poetry?.poet?.id ?? '',
                                      ),
                                    ),
                                  );
                                },
                                child: AuthorAvatar(
                                  size: 54.0,
                                ),
                              ),
                              SizedBox(
                                width: 12.0,
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (content) => AuthorPage(
                                        id: poetry?.poet?.id ?? '',
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  poetry.author ?? '',
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
                              GestureDetector(
                                onTap: () {
                                  _fetchPoetry();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5.0,
                                    horizontal: 12.0,
                                  ),
                                  child: Text('随机刷新'),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 12.0,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              '#${poetry.rhythmic}#',
                              style: kRhythmic,
                            ),
                          ),
                          SizedBox(
                            height: 12.0,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: _layout == '1'
                                ? Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: poetry.paragraphs
                                        .map((e) => Text(
                                              e,
                                              style: kParagraphs,
                                            ))
                                        .toList())
                                : Text(
                                    poetry.paragraphs.join(''),
                                    style: kParagraphs,
                                  ),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    'asset/images/like.png',
                                    width: 32.0,
                                    height: 32.0,
                                  )
                                ],
                              ),
                              Row(
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
                              Row(
                                children: [
                                  Image.asset(
                                    'asset/images/fav.png',
                                    width: 27.0,
                                    height: 27.0,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : Container(),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class SearchBarViewDelegate extends SearchDelegate<String> {
  String searchHint = '请输入..';
  List<String> history = [];
  // fetch();
  Future fetch() async {
    SharedPreferences refs = await SharedPreferences.getInstance();
    history = refs.getStringList('history') ??
        [
          '柳永柳永',
          '力量',
          '柳永等待',
          '力量是',
          '柳永',
          '力量',
          '柳永',
          '力量神色',
          '柳永是',
          '力量',
          '柳',
          '力量',
          '柳永',
          '力量',
          '柳永',
          '力量'
        ];
    return history;
  }

  @override
  void showResults(BuildContext context) {
    super.showResults(context);
  }

  @override
  TextStyle get searchFieldStyle =>
      TextStyle(fontSize: 16.0, color: Colors.grey[600]);

  @override
  String get searchFieldLabel => searchHint;

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      query != ''
          ? IconButton(
              icon: Icon(
                Icons.cancel,
                color: Colors.grey,
              ),
              onPressed: () {
                query = '';
                showSuggestions(context);
              },
            )
          : Container(),
      GestureDetector(
        child: Container(
          padding: EdgeInsets.only(
            right: 12,
          ),
          alignment: Alignment.center,
          child: Text(
            '取消',
            style: TextStyle(fontSize: 20.0, color: kBlack),
          ),
          // decoration: BoxDecoration(color: Colors.red),
        ),
        onTap: () {
          close(context, '');
        },
      ),
    ];
  }

  @override
  Widget buildResults(BuildContext context) {
    return SearchResult(
      query: query,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
        future: fetch(),
        builder: (content, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            List<String> history = snapshot.data;
            List<String> suggest = ['李白', '杜甫', '白居易', '李清照', '柳永'];
            return Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: Text(
                      '搜索历史',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 12.0,
                    runSpacing: 12.0,
                    children: history.map((e) {
                      return GestureDetector(
                        onTap: () {
                          query = e;
                          showResults(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.0,
                            vertical: 5.0,
                          ),
                          child: Text(
                            e,
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 24.0, bottom: 12.0),
                    child: Text(
                      '推荐',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.grey[700],
                      ),
                    ),
                  ),
                  Wrap(
                    spacing: 12.0,
                    runSpacing: 12.0,
                    children: suggest.map((e) {
                      return GestureDetector(
                        onTap: () {
                          query = e;
                          showResults(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 15.0,
                            vertical: 5.0,
                          ),
                          child: Text(
                            e,
                            style: TextStyle(
                              fontSize: 16.0,
                            ),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            );
          }
          return Container();
        });
  }

  @override
  Widget buildLeading(BuildContext context) {
    return Container(
      child: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: kBlack,
        ),
        onPressed: () {
          close(context, '');
        },
      ),
    );
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryColor: Colors.grey[200],
    );
  }
}
