import 'package:min_poetry_flutter/model/user.dart';

class Comment {
  String id;
  String content;
  String type;
  String parentid;
  int reply;
  int rank;
  int high;
  int poor;
  String userzid;
  String poetryzid;
  int vote;
  String delete;
  String created;
  String updated;
  User user;

  Comment(
      {this.id,
      this.content,
      this.type,
      this.parentid,
      this.reply,
      this.rank,
      this.high,
      this.poor,
      this.userzid,
      this.poetryzid,
      this.vote,
      this.delete,
      this.created,
      this.updated,
      this.user});

  Comment.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    content = json['content'];
    type = json['type'];
    parentid = json['parentid'];
    reply = json['reply'];
    rank = json['rank'];
    high = json['high'];
    poor = json['poor'];
    userzid = json['userzid'];
    poetryzid = json['poetryzid'];
    vote = json['vote'];
    delete = json['delete'];
    created = json['created'];
    updated = json['updated'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['content'] = this.content;
    data['type'] = this.type;
    data['parentid'] = this.parentid;
    data['reply'] = this.reply;
    data['rank'] = this.rank;
    data['high'] = this.high;
    data['poor'] = this.poor;
    data['userzid'] = this.userzid;
    data['poetryzid'] = this.poetryzid;
    data['vote'] = this.vote;
    data['delete'] = this.delete;
    data['created'] = this.created;
    data['updated'] = this.updated;
    if (this.user != null) {
      data['user'] = this.user.toJson();
    }
    return data;
  }
}
