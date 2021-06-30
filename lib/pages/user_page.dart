import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:min_poetry_flutter/api/fetch.dart';
import 'package:min_poetry_flutter/components/author_avatar.dart';
import 'package:min_poetry_flutter/constants.dart';
import 'package:min_poetry_flutter/model/user.dart';
import 'package:min_poetry_flutter/pages/notify_page.dart';
import 'package:min_poetry_flutter/pages/setting_page.dart';
import 'package:min_poetry_flutter/utils/bus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage>
    with AutomaticKeepAliveClientMixin {
  User _user;
  StreamSubscription<LoginEvent> _event;
  bool _login = true;
  String _type = '';
  @override
  void initState() {
    print('init');
    _fetchUser();
    _event = EventbusUtil.getInstance().on<LoginEvent>().listen((data) {
      if (data.status == 'login') {
        _fetchUser();
      } else if (data.status == 'logout') {
        _login = false;
        if (mounted) {
          setState(() {});
        }
      } else if (data.status == 'profile') {
        print('profile');
        _fetchUser();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _event?.cancel();
    super.dispose();
  }

  void _fetchUser() async {
    SharedPreferences refs = await SharedPreferences.getInstance();
    String id = refs.getString('id');
    String type = refs.getString('type') ?? '';
    _type = type;
    if (id != null && id != '') {
      _login = true;
      if (mounted) {
        setState(() {});
      }
      User user = await Fetch.user({'id': id});
      _user = user;
      if (mounted) {
        setState(() {});
      }
    } else {
      _login = false;
      if (mounted) {
        setState(() {});
      }
    }
    if (id != null && id != '') {
      User user = await Fetch.user({'id': id});
      print('user$user');
      _user = user;
      if (mounted) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: _login
          ? AppBar(
              backgroundColor: Colors.white,
              brightness: Brightness.light,
              elevation: 0,
              leading: GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Icon(
                      Icons.settings,
                      size: 27.0,
                      color: kBlack,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingPage(),
                    ),
                  );
                },
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.all(0.0),
                    width: 40.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: IconButton(
                        padding: EdgeInsets.all(0),
                        icon: Icon(
                          Icons.email,
                          size: 27.0,
                          color: kBlack,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NotifyPage(),
                            ),
                          );
                        }),
                  ),
                ),
              ],
              title: Text(
                '我',
                style: TextStyle(
                  color: kBlack,
                ),
              ),
            )
          : AppBar(
              backgroundColor: Colors.white,
              brightness: Brightness.light,
              elevation: 0,
              title: Text(
                '我',
                style: TextStyle(color: kBlack),
              ),
            ),
      body: SafeArea(
        child: _login
            ? SingleChildScrollView(
                child: Column(
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
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.0,
                        vertical: 15.0,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        _user?.username ?? '',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: kBlack,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.fromLTRB(30.0, 0.0, 30.0, 20.0),
                      alignment: Alignment.center,
                      child: Text(
                        _user?.intro != '' && _user?.intro != null
                            ? _user.intro
                            : '暂无简介..',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.0,
                          color: kBlack,
                        ),
                      ),
                    ),
                    // Container(
                    //   decoration: BoxDecoration(color: Colors.grey[100]),
                    //   height: 30.0,
                    // ),
                    SizedBox(
                      height: 12,
                    ),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_user?.follow ?? 0}',
                                    style: kLabelBold,
                                  ),
                                  SizedBox(
                                    width: 4.0,
                                  ),
                                  Text(
                                    '正在关注',
                                    style: kLabel,
                                  ),
                                ],
                              ),
                              onTap: () {},
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.stars),
                                  SizedBox(
                                    width: 4.0,
                                  ),
                                  Text(
                                    _type == '0'
                                        ? '诗'
                                        : (_type == '1' ? '词' : '诗、词'),
                                    style: kLabel,
                                  ),
                                ],
                              ),
                              onTap: () {},
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.date_range_rounded),
                                SizedBox(
                                  width: 4.0,
                                ),
                                Text(
                                  '${DateFormat('yy/MM').format(DateTime.parse(_user?.created ?? '2020-01-01'))}',
                                  style: kLabel,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12.0,
                    ),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.fromLTRB(30.0, 15.0, 30.0, 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.favorite),
                                  SizedBox(
                                    width: 4.0,
                                  ),
                                  Text(
                                    '${_user?.like ?? 0}',
                                    style: kLabelBold,
                                  ),
                                ],
                              ),
                              onTap: () {},
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.star),
                                  SizedBox(
                                    width: 4.0,
                                  ),
                                  Text(
                                    '${_user?.favor ?? 0}',
                                    style: kLabelBold,
                                  ),
                                ],
                              ),
                              onTap: () {},
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.mark_chat_read_rounded),
                                SizedBox(
                                  width: 4.0,
                                ),
                                Text(
                                  '${_user?.comment ?? 0}',
                                  style: kLabelBold,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      alignment: Alignment.centerLeft,
                      child: Text('最喜欢诗/词人'),
                    ),
                    _user?.topAuthor != null
                        ? Container(
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 15.0),
                            alignment: Alignment.topLeft,
                            child: Row(
                              children: [
                                AuthorAvatar(
                                  size: 50,
                                ),
                                SizedBox(
                                  width: 12.0,
                                ),
                                Text(
                                  _user.topAuthor?.author ?? '柳永',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container(
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 15.0),
                            alignment: Alignment.topLeft,
                            child: Text('暂无最喜欢的诗/词人'),
                          ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      alignment: Alignment.centerLeft,
                      child: Text('最喜欢诗/词'),
                    ),
                    _user?.topPoetry != null
                        ? Container(
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                            alignment: Alignment.topLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(Icons.bookmark),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    Text(
                                      '#雨霖铃#',
                                      style: kRhythmic,
                                    ),
                                    SizedBox(
                                      width: 12.0,
                                    ),
                                    Text(
                                      '@柳永',
                                      style: kAuthor,
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10.0,
                                ),
                                Text(
                                  '意中有个人，芳颜二八。天然俏、自d 来奸黠。意中有个人，芳颜二八。天然俏、自来奸黠。意中有个人，芳颜二八。天然俏、自来奸黠。意中有个人，芳颜二八。天然俏、自来奸黠。意中有个人，芳颜二八。天然俏、自来奸黠。意中有个人，芳颜二八。天然俏、自来奸黠。',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    height: 1.5,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : Container(
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.0, vertical: 20.0),
                            alignment: Alignment.topLeft,
                            child: Text('暂无最喜欢的诗词'),
                          )
                  ],
                ),
              )
            : Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/login', arguments: 'user');
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 25.0,
                      vertical: 10.0,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(
                        50.0,
                      ),
                    ),
                    child: Text(
                      '登录',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
