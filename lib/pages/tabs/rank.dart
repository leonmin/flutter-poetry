import 'package:flutter/material.dart';
import 'package:min_poetry_flutter/api/fetch.dart';
import 'package:min_poetry_flutter/model/poetry.dart';

class TabRank extends StatefulWidget {
  @override
  _TabRankState createState() => _TabRankState();
}

class _TabRankState extends State<TabRank> {
  List<Poetry> _poetries = [];
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          children: [
            RaisedButton(
              child: Text(''),
              onPressed: () async {
                var a = await Fetch.poetries({'page': 1});
                _poetries = a;
                if (mounted) {
                  setState(() {});
                }
              },
            ),
            Expanded(
                child: ListView.builder(
              itemCount: _poetries.length,
              itemBuilder: (context, index) {
                return Container(
                  child: Text(_poetries[index].rhythmic),
                );
              },
            ))
          ],
        ),
      ),
    );
  }
}
