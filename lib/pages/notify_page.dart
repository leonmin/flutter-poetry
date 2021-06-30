import 'package:flutter/material.dart';
import 'package:min_poetry_flutter/constants.dart';

class NotifyPage extends StatefulWidget {
  @override
  _NotifyPageState createState() => _NotifyPageState();
}

class _NotifyPageState extends State<NotifyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            '通知',
            style: TextStyle(color: kBlack),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(30.0),
                alignment: Alignment.center,
                child: Text(
                  '暂无消息',
                  style: TextStyle(fontSize: 15),
                ),
              )
            ],
          ),
        ));
  }
}
