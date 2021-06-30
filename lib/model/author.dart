class Poet {
  String id;
  String author;
  String type;
  String avatar;
  String intro;
  String followed;
  int follower;
  String created;
  String updated;
  String delete;

  Poet(
      {this.id,
      this.author,
      this.type,
      this.avatar,
      this.intro,
      this.followed,
      this.follower,
      this.created,
      this.updated,
      this.delete});

  Poet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    author = json['author'];
    type = json['type'];
    avatar = json['avatar'];
    intro = json['intro'];
    followed = json['followed'];
    follower = json['follower'];
    created = json['created'];
    updated = json['updated'];
    delete = json['delete'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['author'] = this.author;
    data['type'] = this.type;
    data['avatar'] = this.avatar;
    data['intro'] = this.intro;
    data['followed'] = this.followed;
    data['follower'] = this.follower;
    data['created'] = this.created;
    data['updated'] = this.updated;
    data['delete'] = this.delete;
    return data;
  }
}

var fakeAuthor = Poet(
  id: '',
  author: '',
  type: '0',
  avatar: '',
  intro: '',
  followed: 'N',
  follower: 0,
  created: '',
  updated: '',
  delete: 'N',
);
