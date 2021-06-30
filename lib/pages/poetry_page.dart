import 'dart:async';

import 'package:flutter/material.dart';
import 'package:min_poetry_flutter/components/poetry_detail.dart';
import 'package:min_poetry_flutter/constants.dart';
import 'package:min_poetry_flutter/model/poetry.dart';

class PoetryPage extends StatefulWidget {
  PoetryPage({this.poetry, this.index, this.type});
  final int index; // 列表中的序号
  final String type; // 列表类型
  final Poetry poetry;
  @override
  _PoetryPageState createState() => _PoetryPageState();
}

class _PoetryPageState extends State<PoetryPage> {
  GlobalKey<PoetryDetailState> _list2detailKey = GlobalKey<PoetryDetailState>();

  Future<void> _handleRefresh() async {
    _list2detailKey.currentState.handleRefresh(widget.poetry);
  }

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration(milliseconds: 0), () {
    //   _handleRefresh();
    // });
    // Future.microtask(() => _handleRefresh());
    new Future(() => _handleRefresh());
  }

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
          '${widget.poetry?.rhythmic ?? ''}',
          softWrap: true,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: kBlack,
          ),
        ),
        actions: [
          Container(
            width: 40.0,
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: PoetryDetail(
          type: widget.type,
          index: widget.index,
          enableAuthor: true,
          enablePoetry: false,
          key: _list2detailKey,
        ),
      ),
    );
  }
}
