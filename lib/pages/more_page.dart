import 'package:flutter/material.dart';
import 'package:min_poetry_flutter/api/fetch.dart';
import 'package:min_poetry_flutter/components/poetry_detail.dart';
import 'package:min_poetry_flutter/components/search_result.dart';
import 'package:min_poetry_flutter/constants.dart';
import 'package:min_poetry_flutter/model/poetries.dart';
import 'package:min_poetry_flutter/model/poetry.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MorePage extends StatefulWidget {
  @override
  _MorePageState createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  GlobalKey<PoetryDetailState> _random2detailKey =
      GlobalKey<PoetryDetailState>();
  Poetry _poetry;
  String _randomid;
  Poetries _provider;

  @override
  void initState() {
    // Future.delayed(Duration(milliseconds: 100), () {
    //   // _fetchRandomPoetry();
    // });
    // Future.microtask(() => _fetchRandomPoetry());
    new Future(() => _fetchRandomPoetry());

    super.initState();
    _provider = context.read<Poetries>();
  }

  void _fetchRandomPoetry() async {
    SharedPreferences refs = await SharedPreferences.getInstance();
    String type = refs.getString('type') ?? '';
    String userid = refs.getString('id') ?? '';
    Poetry p = await Fetch.random({'userid': userid, 'type': type});
    _poetry = p;
    if (mounted) {
      setState(() {});
    }
    // Provider.of<Poetries>(context, listen: false).add('random', p);
    _provider..add('random', p);
    if (_random2detailKey != null && _random2detailKey.currentState != null) {
      _random2detailKey.currentState.handleRefresh(p);
    }
  }

  Future<void> _handleRefresh() async {
    _fetchRandomPoetry();
  }

  @override
  Widget build(BuildContext context) {
    // Poetry random = context.watch<Poetries>().random;
    // if (random != null && random.id != null && random.id != _randomid) {
    //   _randomid = random.id;
    //   print('random id change$_randomid${random.rhythmic}');
    //   _random2detailKey.currentState.handleRefresh(random);
    // }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        brightness: Brightness.light,
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
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: PoetryDetail(
          type: 'random',
          index: 0,
          enableAuthor: true,
          enablePoetry: false,
          key: _random2detailKey,
        ),
      ),
    );
  }
}

class SearchBarViewDelegate extends SearchDelegate<String> {
  String searchHint = '请输入..';
  List<String> history = [];
  Future fetch() async {
    SharedPreferences refs = await SharedPreferences.getInstance();
    history = refs.getStringList('history') ?? [];
    // print('history${h}');
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
          ? Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: IconButton(
                icon: Icon(
                  Icons.cancel,
                  color: Colors.grey,
                ),
                onPressed: () {
                  query = '';
                  showSuggestions(context);
                },
              ),
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
    if (query != '') {
      setHistory(query);
    }
    return SearchResult(
      query: query,
    );
  }

  void setHistory(String query) async {
    SharedPreferences refs = await SharedPreferences.getInstance();
    List<String> history = refs.getStringList('history') ?? [];
    if (history.length > 10) {
      history.removeLast();
    }
    if (!history.contains(query)) {
      history.insert(0, query);
      refs.setStringList('history', history);
    }
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
      },
    );
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
      primaryColorBrightness: Brightness.light,
    );
  }
}
