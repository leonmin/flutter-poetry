import 'author.dart';

class Poetry {
  String id;
  String author;
  String type;
  List<String> paragraphs;
  String rhythmic;
  int visit;
  int comment;
  int favor;
  int like;
  String favored;
  String liked;
  String created;
  String updated;
  String delete;
  Poet poet;

  Poetry(
      {this.id,
      this.author,
      this.type,
      this.paragraphs,
      this.rhythmic,
      this.visit,
      this.comment,
      this.favor,
      this.like,
      this.favored,
      this.liked,
      this.created,
      this.updated,
      this.delete,
      this.poet});

  Poetry.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    author = json['author'];
    type = json['type'];
    paragraphs = json['paragraphs'].cast<String>();
    rhythmic = json['rhythmic'];
    visit = json['visit'];
    comment = json['comment'];
    favor = json['favor'];
    like = json['like'];
    favored = json['favored'];
    liked = json['liked'];
    created = json['created'];
    updated = json['updated'];
    delete = json['delete'];
    poet = json['poet'] != null ? new Poet.fromJson(json['poet']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['author'] = this.author;
    data['type'] = this.type;
    data['paragraphs'] = this.paragraphs;
    data['rhythmic'] = this.rhythmic;
    data['visit'] = this.visit;
    data['comment'] = this.comment;
    data['favor'] = this.favor;
    data['like'] = this.like;
    data['favored'] = this.favored;
    data['liked'] = this.liked;
    data['created'] = this.created;
    data['updated'] = this.updated;
    data['delete'] = this.delete;
    if (this.poet != null) {
      data['poet'] = this.poet.toJson();
    }
    return data;
  }
}

var fakePoetry = Poetry(
  id: '',
  author: '',
  type: '0',
  paragraphs: null,
  rhythmic: '',
  visit: 0,
  comment: 0,
  favor: 0,
  like: 0,
  favored: '',
  liked: '',
  created: '',
  updated: '',
  delete: '',
);
