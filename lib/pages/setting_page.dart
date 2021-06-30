import 'dart:async';

import 'package:flutter/material.dart';
import 'package:min_poetry_flutter/constants.dart';
import 'package:min_poetry_flutter/pages/setting/type.dart';
import 'package:min_poetry_flutter/utils/bus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  GlobalKey<ScaffoldState> _settingKey = GlobalKey();
  String _type;
  String _layout;
  StreamSubscription<SettingEvent> _event;
  void _logout() async {
    SharedPreferences refs = await SharedPreferences.getInstance();
    refs.remove('id');
    refs.remove('token');
    EventbusUtil.getInstance().fire(LoginEvent('logout'));
    Navigator.of(context).pop();
  }

  void _fetchSetting() async {
    SharedPreferences refs = await SharedPreferences.getInstance();
    String type = refs.getString('type') ?? '';
    String layout = refs.getString('layout') ?? '0';
    _type = type;
    _layout = layout;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    _fetchSetting();
    _event = EventbusUtil.getInstance().on<SettingEvent>().listen((data) {
      if (data.status == 'type') {
        _fetchSetting();
      } else if (data.status == 'logout') {}
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _settingKey,
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 2,
        brightness: Brightness.light,
        backgroundColor: Colors.grey[200],
        automaticallyImplyLeading: true,
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
          '设置',
          style: TextStyle(color: kBlack),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return TypeSetting();
                    }),
                  );
                },
                child: Container(
                  height: 55.0,
                  padding: EdgeInsets.symmetric(
                    horizontal: 20.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '诗词偏好',
                        style: kList,
                      ),
                      Spacer(),
                      Text(
                        _type == '0' ? '诗' : (_type == '1' ? '词' : '诗、词'),
                        style: kList.copyWith(color: Colors.grey[700]),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 55.0,
                padding: EdgeInsets.symmetric(
                  horizontal: 20.0,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '断句布局',
                      style: kList,
                    ),
                    Spacer(),
                    SizedBox(
                      width: 10.0,
                    ),
                    GestureDetector(
                      onTap: () async {
                        _layout = _layout == '1' ? '0' : '1';
                        if (mounted) {
                          setState(() {});
                        }
                        SharedPreferences refs =
                            await SharedPreferences.getInstance();
                        refs.setString('layout', _layout);
                        EventbusUtil.getInstance().fire(SettingEvent('layout'));
                      },
                      child: Image.asset(
                        _layout == '1'
                            ? 'asset/images/switch_on.png'
                            : 'asset/images/switch_off.png',
                        height: 45.0,
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              GestureDetector(
                onTap: _logout,
                child: Container(
                  height: 55.0,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: Colors.white),
                  child: Text(
                    '退出登录',
                    style: kList,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
