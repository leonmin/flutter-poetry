// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:min_poetry_flutter/api/fetch.dart';
// import 'package:min_poetry_flutter/components/author_avatar.dart';
// import 'package:min_poetry_flutter/components/highlight.dart';
// import 'package:min_poetry_flutter/constants.dart';
// import 'package:min_poetry_flutter/model/poetries.dart';
// import 'package:min_poetry_flutter/model/poetry.dart';
// import 'package:min_poetry_flutter/pages/author_page.dart';
// import 'package:min_poetry_flutter/pages/poetry_page.dart';
// import 'package:min_poetry_flutter/utils/bus.dart';
// import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class PoetryCard extends StatefulWidget {
//   PoetryCard(
//       {this.index,
//       this.poetry,
//       this.query = '',
//       this.userid,
//       this.enableAuthor = true,
//       this.enablePoetry = true,
//       this.callback,
//       Key key})
//       : super(key: key);
//   final int index;
//   final Poetry poetry;
//   final String query;
//   final String userid;
//   final Function callback;
//   // 控制头像跳转
//   final bool enableAuthor;
//   final bool enablePoetry;
//   @override
//   PoetryCardState createState() => PoetryCardState();
// }

// class PoetryCardState extends State<PoetryCard> {
//   // 布局 layout 0 正常 1 行布局
//   String _layout = '0';
//   String _liked = 'N';
//   String _favored = 'N';
//   int _like = 0;
//   int _comment = 0;
//   StreamSubscription<SettingEvent> _event;

//   @override
//   void initState() {
//     _fetchLayout();
//     _fetchAction();
//     _event = EventbusUtil.getInstance().on<SettingEvent>().listen((data) {
//       if (data.status == 'layout') {
//         _fetchLayout();
//       }
//     });
//     super.initState();
//   }

//   void _fetchLayout() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     _layout = prefs.get('layout') ?? '0';
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   void _fetchAction() {
//     _like = widget.poetry?.like ?? 0;
//     _liked = widget.poetry?.liked ?? 'N';
//     _favored = widget.poetry?.favored ?? 'N';
//     _comment = widget.poetry?.comment ?? 0;
//     // print('likded$_liked${widget.poetry.liked}');
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   void handleComment() {
//     _comment += 1;
//     if (mounted) {
//       setState(() {});
//     }
//   }

//   void _onLike() async {
//     // widget.poetry.liked = widget.poetry.liked == 'Y' ? 'N' : 'Y';
//     // Provider.of<Poetries>(context, listen: false).update();
//     // if (widget.poetry.liked != null && widget.poetry.id != null) {
//     //   if (_liked == 'Y') {
//     //     String r = await Fetch.unlike({'id': widget.poetry.id});
//     //     if (r == 'OK') {
//     //       if (_like > 0) {
//     //         _like -= 1;
//     //         widget.poetry.like -= 1;
//     //       }
//     //       _liked = 'N';
//     //       widget.poetry.liked = 'N';
//     //       if (mounted) {
//     //         setState(() {});
//     //       }
//     //       EventbusUtil.getInstance().fire(LoginEvent('profile'));
//     //     }
//     //   } else {
//     //     String r = await Fetch.like({'id': widget.poetry.id});
//     //     if (r == 'OK') {
//     //       _like += 1;
//     //       _liked = 'Y';
//     //       widget.poetry.like += 1;
//     //       widget.poetry.liked = 'Y';
//     //       if (mounted) {
//     //         setState(() {});
//     //       }
//     //       EventbusUtil.getInstance().fire(LoginEvent('profile'));
//     //     }
//     //   }
//     // }
//   }

//   void _onFavor() async {
//     if (widget.poetry.favored != null && widget.poetry.id != null) {
//       if (_favored == 'Y') {
//         String r = await Fetch.unfavor({'id': widget.poetry.id});
//         if (r == 'OK') {
//           _favored = 'N';
//           widget.poetry.favored = 'N';
//           if (mounted) {
//             setState(() {});
//           }
//           EventbusUtil.getInstance().fire(LoginEvent('profile'));
//         }
//       } else {
//         String r = await Fetch.favor({'id': widget.poetry.id});
//         if (r == 'OK') {
//           _favored = 'Y';
//           widget.poetry.favored = 'Y';
//           if (mounted) {
//             setState(() {});
//           }
//           EventbusUtil.getInstance().fire(LoginEvent('profile'));
//         }
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Consumer<Poetries>(builder: (context, poetries, child) {
//       Poetry poetry = poetries.poetries[widget.index];
//       return Container(
//         padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
//         child: widget.index != null && poetry != null
//             ? Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       GestureDetector(
//                         onTap: () {
//                           if (widget.enableAuthor) {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (content) => AuthorPage(
//                                   id: poetry.poet.id,
//                                 ),
//                               ),
//                             );
//                           }
//                         },
//                         child: AuthorAvatar(
//                           size: 54,
//                         ),
//                       ),
//                       SizedBox(
//                         width: 12.0,
//                       ),
//                       GestureDetector(
//                         onTap: () {
//                           if (widget.enableAuthor) {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (content) => AuthorPage(
//                                   id: poetry.poet?.id ?? '',
//                                 ),
//                               ),
//                             );
//                           }
//                         },
//                         child: Text(
//                           poetry.author,
//                           style: kAuthor,
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10.0,
//                       ),
//                       Container(
//                         padding: EdgeInsets.symmetric(
//                           horizontal: 10.0,
//                           vertical: 0.0,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.red[200],
//                           borderRadius: BorderRadius.only(
//                             topLeft: Radius.circular(10.0),
//                             topRight: Radius.circular(10.0),
//                             bottomLeft: Radius.elliptical(5.0, 5.0),
//                             bottomRight: Radius.circular(10.0),
//                           ),
//                         ),
//                         child: Text(
//                           poetry.type == '0' ? '诗' : '词',
//                           style: TextStyle(
//                             color: Colors.white,
//                           ),
//                         ),
//                       ),
//                       Spacer(),
//                       Image.asset(
//                         'asset/images/more.png',
//                         width: 32.0,
//                         height: 32.0,
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     height: 12.0,
//                   ),
//                   Container(
//                     alignment: Alignment.centerLeft,
//                     height: 20.0,
//                     child: _highRhythmic(
//                         '#' + poetry.rhythmic + '#', widget.query),
//                   ),
//                   SizedBox(
//                     height: 12.0,
//                   ),
//                   GestureDetector(
//                     onTap: () {
//                       if (widget.enablePoetry) {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (content) => PoetryPage(
//                               index: widget.index,
//                               poetry: poetry,
//                               id: poetry?.id ?? '',
//                             ),
//                           ),
//                         );
//                       }
//                     },
//                     child: Container(
//                       alignment: Alignment.centerLeft,
//                       child: _layout == '1'
//                           ? _highParagraphsLines(
//                               poetry.paragraphs, widget.query)
//                           : _highParagraphs(poetry.paragraphs, widget.query),
//                     ),
//                   ),
//                   SizedBox(
//                     height: 16.0,
//                   ),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           GestureDetector(
//                             onTap: () {
//                               var p = context.read<Poetries>();
//                               p.update(widget.index, 'liked',
//                                   poetry.liked == 'Y' ? 'N' : 'Y');
//                             },
//                             child: Row(
//                               children: [
//                                 Image.asset(
//                                   poetry.liked == 'Y'
//                                       ? 'asset/images/like_fill.png'
//                                       : 'asset/images/like.png',
//                                   width: 32.0,
//                                   height: 32.0,
//                                 ),
//                                 SizedBox(
//                                   width: 4.0,
//                                 ),
//                                 Text(
//                                   '$_like${poetry.liked}',
//                                   style: TextStyle(
//                                     fontSize: 16.0,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           Image.asset(
//                             'asset/images/cmt.png',
//                             width: 27.0,
//                             height: 27.0,
//                           ),
//                           SizedBox(
//                             width: 4.0,
//                           ),
//                           Text(
//                             '${_comment > 0 ? _comment : "评论"}',
//                             style: TextStyle(
//                               fontSize: 15.0,
//                             ),
//                           )
//                         ],
//                       ),
//                       Row(
//                         children: [
//                           GestureDetector(
//                             onTap: _onFavor,
//                             child: Image.asset(
//                               _favored == 'Y'
//                                   ? 'asset/images/fav_fill.png'
//                                   : 'asset/images/fav.png',
//                               width: 27.0,
//                               height: 27.0,
//                             ),
//                           )
//                         ],
//                       ),
//                     ],
//                   )
//                 ],
//               )
//             : Container(),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border(
//             bottom: BorderSide(
//               color: Colors.grey[200],
//               width: 2.0,
//               style: BorderStyle.solid,
//             ),
//           ),
//         ),
//       );
//     });
//   }

//   Widget _highParagraphs(List<String> paragraphs, String query) {
//     var ps = paragraphs.join('');
//     return Highlight(
//       text: ps,
//       query: query,
//       style1: kParagraphs,
//       style2: kParagraphs.copyWith(color: kActive),
//     );
//   }

//   Widget _highParagraphsLines(List<String> paragraphs, String query) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: paragraphs.map((e) {
//         if (query != '') {
//           return Highlight(
//             text: e,
//             query: query,
//             style1: kParagraphs,
//             style2: kParagraphs.copyWith(color: kActive),
//           );
//         } else {
//           return Text(
//             e,
//             style: kParagraphs,
//           );
//         }
//       }).toList(),
//     );
//   }

//   Widget _highRhythmic(String rhythmic, String query) {
//     return Highlight(
//       text: rhythmic,
//       query: query,
//       style1: kRhythmic,
//       style2: kRhythmic.copyWith(color: kActive),
//     );
//   }
// }
