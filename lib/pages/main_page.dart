import 'dart:async';

import 'package:flutter/material.dart';
import 'package:min_poetry_flutter/constants.dart';
import 'package:min_poetry_flutter/pages/home_single_page.dart';
// import 'package:min_poetry_flutter/pages/home_page.dart';
import 'package:min_poetry_flutter/pages/login_page.dart';
import 'package:min_poetry_flutter/pages/more_page.dart';
import 'package:min_poetry_flutter/pages/user_page.dart';
import 'package:min_poetry_flutter/utils/bus.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  StreamSubscription<LoginEvent> _event;
  int _selectedIndex = 0;
  PageController _pageController = PageController();
  List<Widget> _screen = [HomeSinglePage(), MorePage(), UserPage()];
  // List<Widget> _screen = [LoginPage(), HomePage(), UserPage()];
  @override
  void initState() {
    _event = EventbusUtil.getInstance().on<LoginEvent>().listen((data) {
      if (data.status == 'register' || data.status == 'retrieve') {
        print('@@@ tab register/retrieve');
        _selectedIndex = 0;
        if (mounted) {
          setState(() {});
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _event?.cancel();
    super.dispose();
  }

  void _onPageChanged(int index) {
    _selectedIndex = index;
    if (mounted) {
      setState(() {});
    }
  }

  void _onTap(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _screen,
        onPageChanged: _onPageChanged,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTap,
        iconSize: 32.0,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: _selectedIndex == 0 ? kBlack : Colors.grey,
              ),
              label: '主页'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.explore_sharp,
                color: _selectedIndex == 1 ? kBlack : Colors.grey,
              ),
              label: '探索'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: _selectedIndex == 2 ? kBlack : Colors.grey,
              ),
              label: '我的'),
        ],
      ),
    );
  }
}
