import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:min_poetry_flutter/api/fetch.dart';
import 'package:min_poetry_flutter/constants.dart';
import 'package:min_poetry_flutter/main.dart';
import 'package:min_poetry_flutter/model/user.dart';
import 'package:min_poetry_flutter/pages/main_page.dart';
import 'package:min_poetry_flutter/utils/bus.dart';
import 'package:shared_preferences/shared_preferences.dart';

GlobalKey<ScaffoldState> retrieveKey = new GlobalKey<ScaffoldState>();

class RetrievePage extends StatefulWidget {
  @override
  _RetrievePageState createState() => _RetrievePageState();
}

class _RetrievePageState extends State<RetrievePage> {
  GlobalKey<FormState> retrieveFormKey = new GlobalKey<FormState>();
  String _email;
  String _password;
  String _code;
  Timer _timer;
  int _seconds = 60;
  String _hint = '获取验证码';
  final String regexEmail =
      '^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$';
  final String regexPassword =
      '(?=.*([a-zA-Z].*))(?=.*[0-9].*)[a-zA-Z0-9-*/+.,~!@#\$%^&*()]{6,20}\$';
  final String regexCode = '^[0-9]{6}\$';
  void _onTap() async {
    var form = retrieveFormKey.currentState;
    if (form.validate()) {
      form.save();
      User user = await Fetch.retrieve(
          {'email': _email, 'password': _password, 'code': _code});
      if (user != null) {
        SharedPreferences refs = await SharedPreferences.getInstance();
        refs.setString('id', user.id ?? '');
        refs.setString('token', user.token ?? '');
        print('=>>>token retrieve${user.token}');
        EventbusUtil.getInstance().fire(LoginEvent('retrieve'));
        navigatorKey.currentState
            .pushNamedAndRemoveUntil('/', (route) => false);
      }
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds == 0) {
        _cancelTimer();
        _seconds = 60;
        _hint = '重新发送';
        if (mounted) {
          setState(() {});
        }
        return;
      }
      _seconds--;
      _hint = '已发送';
      if (mounted) {
        setState(() {});
      }
      // if (_seconds == 0) {
      //   _hint = '重新发送';
      // }
    });
  }

  void _cancelTimer() {
    _timer?.cancel();
  }

  void _onSend() async {
    var form = retrieveFormKey.currentState;
    form.save();
    if (new RegExp(regexEmail).hasMatch(_email)) {
      if (_seconds == 60) {
        var r = await Fetch.send({'email': _email});
        if (r == 'OK') {
          retrieveKey.currentState.showSnackBar(
            SnackBar(content: Text('发送成功')),
          );
          _startTimer();
          if (mounted) {
            setState(() {});
          }
        }
      }
    } else {
      retrieveKey.currentState.showSnackBar(SnackBar(content: Text('邮箱格式错误')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: retrieveKey,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            alignment: Alignment.center,
            height: MediaQuery.of(context).size.height * 1,
            child: Column(
              children: [
                Row(
                  children: [
                    FlatButton(
                      padding: EdgeInsets.symmetric(vertical: 12.0),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Icon(
                        Icons.arrow_back,
                        size: 27,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  '欢迎回到沽酒家',
                  style: TextStyle(fontSize: 32.0),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Container(
                  child: Form(
                    key: retrieveFormKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10.0),
                          child: TextFormField(
                            style: TextStyle(fontSize: 18.0),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              errorText: '',
                              errorMaxLines: 1,
                              errorStyle: TextStyle(
                                height: 1.4,
                                fontSize: 16.0,
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                              hintText: '邮箱',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (val) {
                              return new RegExp(regexEmail).hasMatch(val)
                                  ? null
                                  : '邮箱格式错误';
                            },
                            onSaved: (val) {
                              _email = val;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10.0),
                          child: TextFormField(
                            obscureText: true,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18.0),
                            decoration: InputDecoration(
                              errorText: '',
                              errorMaxLines: 1,
                              errorStyle: TextStyle(
                                height: 1.4,
                                fontSize: 16.0,
                              ),
                              filled: true,
                              fillColor: Colors.grey[200],
                              hintText: '新密码',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50.0),
                                borderSide: BorderSide.none,
                              ),
                            ),
                            validator: (val) {
                              return new RegExp(regexPassword).hasMatch(val)
                                  ? null
                                  : '验证码格式错误(6位数字)';
                            },
                            onSaved: (val) {
                              _password = val;
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 18.0),
                                  maxLength: 6,
                                  inputFormatters: [],
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    errorText: '',
                                    errorMaxLines: 1,
                                    errorStyle: TextStyle(
                                      height: 1.4,
                                      fontSize: 16.0,
                                    ),
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    hintText: '验证码',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.horizontal(
                                          left: Radius.circular((50))),
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  validator: (val) {
                                    print(
                                        'val${RegExp(regexCode).hasMatch(val)}');
                                    return new RegExp(regexCode).hasMatch(val)
                                        ? null
                                        : '6位字母数字';
                                  },
                                  onSaved: (val) {
                                    _code = val;
                                  },
                                ),
                              ),
                              Expanded(
                                flex: 1,
                                child: GestureDetector(
                                  onTap: _onSend,
                                  child: TextFormField(
                                    enabled: false,
                                    obscureText: true,
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 18.0),
                                    buildCounter: (context,
                                            {currentLength,
                                            maxLength,
                                            isFocused}) =>
                                        Container(
                                      child: Text(
                                        '$_seconds/60s',
                                        style: TextStyle(
                                            fontSize: 11.0,
                                            color: _seconds == 60
                                                ? Colors.grey[600]
                                                : kBlack),
                                      ),
                                    ),
                                    decoration: InputDecoration(
                                      errorText: '',
                                      errorMaxLines: 1,
                                      errorStyle: TextStyle(
                                        height: 1.4,
                                        fontSize: 16.0,
                                      ),
                                      filled: true,
                                      fillColor: Colors.grey[300],
                                      hintText: _hint,
                                      hintStyle: TextStyle(
                                          color: _seconds == 60
                                              ? kBlack
                                              : Colors.grey[600]),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.horizontal(
                                            right: Radius.circular((50))),
                                        borderSide: BorderSide.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        GestureDetector(
                          onTap: _onTap,
                          child: Container(
                            padding: EdgeInsets.all(30.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(50.0),
                            ),
                            child: Icon(
                              Icons.arrow_forward,
                              size: 30.0,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
