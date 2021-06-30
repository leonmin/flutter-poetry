import 'package:min_poetry_flutter/model/author.dart';
import 'package:min_poetry_flutter/model/poetry.dart';

class User {
  String id;
  String username;
  String neckname;
  String token;
  int score;
  int faith;
  String gender;
  String avatarUrl;
  String intro;
  String phoneNumber;
  String email;
  String code;
  int comment;
  int favor;
  int like;
  int follow;
  String created;
  String updated;
  String delete;
  Poet topAuthor;
  Poetry topPoetry;

  User(
      {this.id,
      this.username,
      this.neckname,
      this.token,
      this.score,
      this.faith,
      this.gender,
      this.avatarUrl,
      this.intro,
      this.phoneNumber,
      this.email,
      this.code,
      this.comment,
      this.favor,
      this.like,
      this.follow,
      this.created,
      this.updated,
      this.delete,
      this.topAuthor,
      this.topPoetry});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    username = json['username'];
    neckname = json['neckname'];
    token = json['token'];
    score = json['score'];
    faith = json['faith'];
    gender = json['gender'];
    avatarUrl = json['avatar_url'];
    intro = json['intro'];
    phoneNumber = json['phone_number'];
    email = json['email'];
    code = json['code'];
    comment = json['comment'];
    favor = json['favor'];
    like = json['like'];
    follow = json['follow'];
    created = json['created'];
    updated = json['updated'];
    delete = json['delete'];
    topAuthor = json['top_author'];
    topPoetry = json['top_poetry'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['username'] = this.username;
    data['neckname'] = this.neckname;
    data['token'] = this.token;
    data['score'] = this.score;
    data['faith'] = this.faith;
    data['gender'] = this.gender;
    data['avatar_url'] = this.avatarUrl;
    data['intro'] = this.intro;
    data['phone_number'] = this.phoneNumber;
    data['email'] = this.email;
    data['code'] = this.code;
    data['comment'] = this.comment;
    data['favor'] = this.favor;
    data['like'] = this.like;
    data['follow'] = this.follow;
    data['created'] = this.created;
    data['updated'] = this.updated;
    data['delete'] = this.delete;
    data['top_author'] = this.topAuthor;
    data['top_poetry'] = this.topPoetry;
    return data;
  }
}
