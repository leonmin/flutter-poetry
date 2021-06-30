import 'package:flutter/material.dart';
import 'package:min_poetry_flutter/constants.dart';
import 'package:min_poetry_flutter/pages/tabs/find.dart';
import 'package:min_poetry_flutter/pages/tabs/rank.dart';
import 'package:min_poetry_flutter/pages/tabs/star.dart';

class HomeSinglePage extends StatefulWidget {
  @override
  _HomeSinglePageState createState() => _HomeSinglePageState();
}

class _HomeSinglePageState extends State<HomeSinglePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  List tabs = ['关注', '全部'];
  List<Widget> tabWidgets = [TabStar(), TabFind()];
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    return Scaffold(
        appBar: AppBar(
          elevation: 1,
          brightness: Brightness.light,
          backgroundColor: Colors.white,
          title: Text(
            '沽酒家',
            style: TextStyle(
              color: kBlack,
            ),
          ),
        ),
        body: TabStar());
  }

  // @override
  // bool get wantKeepAlive => true;
}
