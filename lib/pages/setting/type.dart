import 'package:flutter/material.dart';
import 'package:min_poetry_flutter/constants.dart';
import 'package:min_poetry_flutter/utils/bus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TypeSetting extends StatefulWidget {
  @override
  _TypeSettingState createState() => _TypeSettingState();
}

class _TypeSettingState extends State<TypeSetting> {
  String _type;
  @override
  void initState() {
    fetchType();
    super.initState();
  }

  void fetchType() async {
    SharedPreferences refs = await SharedPreferences.getInstance();
    String type = refs.getString('type') ?? '';
    _type = type;
    if (mounted) {
      setState(() {});
    }
  }

  void _pickType(String type) async {
    SharedPreferences refs = await SharedPreferences.getInstance();
    refs.setString('type', type);
    EventbusUtil.getInstance().fire(SettingEvent('type'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          '选择喜欢类型',
          style: TextStyle(color: kBlack),
        ),
      ),
      body: Column(
        children: [
          GestureDetector(
            onTap: () {
              _type = '';
              setState(() {});
              _pickType('');
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              height: 60.0,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[200],
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '诗、词',
                    style: kList,
                  ),
                  _type != '0' && _type != '1'
                      ? Icon(
                          Icons.check,
                          color: Colors.red,
                        )
                      : Container()
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _type = '0';
              setState(() {});
              _pickType('0');
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              height: 60.0,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    color: Colors.grey[200],
                  ),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '诗',
                    style: kList,
                  ),
                  _type == '0'
                      ? Icon(
                          Icons.check,
                          color: Colors.red,
                        )
                      : Container()
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              _type = '1';
              setState(() {});
              _pickType('1');
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              height: 60.0,
              decoration: BoxDecoration(color: Colors.white),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '词',
                    style: kList,
                  ),
                  _type == '1'
                      ? Icon(
                          Icons.check,
                          color: Colors.red,
                        )
                      : Container()
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
            alignment: Alignment.centerLeft,
            child: Text(
              '诗:唐诗, 词: 宋词, 暂未收录宋诗.',
              style: TextStyle(
                color: Colors.grey[700],
              ),
            ),
          )
        ],
      ),
    );
  }
}
