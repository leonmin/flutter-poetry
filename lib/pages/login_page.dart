import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:min_poetry_flutter/api/fetch.dart';
import 'package:min_poetry_flutter/main.dart';
import 'package:min_poetry_flutter/model/user.dart';
import 'package:min_poetry_flutter/utils/bus.dart';
import 'package:shared_preferences/shared_preferences.dart';

GlobalKey<ScaffoldState> loginKey = new GlobalKey<ScaffoldState>();

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> loginFormKey = new GlobalKey<FormState>();
  String _email;
  String _password;
  final String regexEmail =
      '^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$';
  final String regexPassword =
      '(?=.*([a-zA-Z].*))(?=.*[0-9].*)[a-zA-Z0-9-*/+.,~!@#\$%^&*()]{6,20}\$';
  void _onTap() async {
    var form = loginFormKey.currentState;
    if (form.validate()) {
      form.save();
      User user = await Fetch.login({'email': _email, 'password': _password});
      if (user != null) {
        SharedPreferences refs = await SharedPreferences.getInstance();
        refs.setString('id', user.id ?? '');
        refs.setString('token', user.token ?? '');
        loginKey.currentState.showSnackBar(SnackBar(content: Text('登录成功')));
        EventbusUtil.getInstance().fire(LoginEvent('login'));
        navigatorKey.currentState.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        key: loginKey,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Container(
              alignment: Alignment.center,
              height: MediaQuery.of(context).size.height * 1,
              child: Column(
                children: [
                  Row(
                    children: [
                      FlatButton(
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
                    '沽酒家',
                    style: TextStyle(fontSize: 32.0),
                  ),
                  SizedBox(
                    height: 40.0,
                  ),
                  Container(
                    child: Form(
                      key: loginFormKey,
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10.0),
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
                            padding:
                                EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 10.0),
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
                                hintText: '密码',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              validator: (val) {
                                return new RegExp(regexPassword).hasMatch(val)
                                    ? null
                                    : '密码格式错误(至少6位字母数字)';
                              },
                              onSaved: (val) {
                                _password = val;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 30.0,
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
                  // Spacer(),
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/retrieve');
                        },
                        child: Text('忘记密码'),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        child: Container(
                          width: 2.0,
                          height: 15.0,
                          decoration: BoxDecoration(color: Colors.grey[400]),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/register');
                        },
                        child: Text('用户注册'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
