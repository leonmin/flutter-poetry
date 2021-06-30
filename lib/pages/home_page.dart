import 'package:flutter/material.dart';
import 'package:min_poetry_flutter/pages/tabs/find.dart';
import 'package:min_poetry_flutter/pages/tabs/rank.dart';
import 'package:min_poetry_flutter/pages/tabs/star.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
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
        backgroundColor: Colors.white,
        brightness: Brightness.light,
        title: SizedBox(
          width: 180,
          child: TabBar(
            labelColor: Colors.black,
            labelStyle: TextStyle(wordSpacing: 0),
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorPadding: EdgeInsets.only(bottom: 5.0),
            indicatorWeight: 2.5,
            tabs: tabs
                .map((e) => Tab(
                      child: Text(e, style: TextStyle(fontSize: 16.0)),
                    ))
                .toList(),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabWidgets
            .map((e) => Container(
                  child: e,
                ))
            .toList(),
      ),
    );
  }

  // @override
  // bool get wantKeepAlive => true;
}
