import 'package:min_poetry_flutter/api/api.dart';
import 'package:min_poetry_flutter/api/dio.dart';
import 'package:min_poetry_flutter/model/author.dart';
import 'package:min_poetry_flutter/model/comment.dart';
import 'package:min_poetry_flutter/model/poetry.dart';
import 'package:min_poetry_flutter/model/user.dart';

class Fetch {
  // 诗词列表
  static Future<List<Poetry>> poetries(params) async {
    var res = await DioHttp.get(Api.Poetries, params);
    List<Poetry> poetries = [];
    if (res['statusCode'] == '000000' && res['data'] != null) {
      for (int i = 0; i < res['data'].length; i++) {
        Map<String, dynamic> p = res['data'][i];
        poetries.add(Poetry.fromJson(p));
      }
      print('poetries$poetries');
      return poetries;
    } else {
      return [];
    }
  }

  // 诗词详情
  static Future<Poetry> poetry(params) async {
    var res = await DioHttp.get(Api.Poetry, params);
    if (res != null && res['statusCode'] == '000000' && res['data'] != null) {
      // return res['data'];
      Map<String, dynamic> p = res['data'];
      Poetry poetry = Poetry.fromJson(p);
      return poetry;
    } else {
      return null;
    }
  }

  // 随机诗词
  static Future<Poetry> random(params) async {
    var res = await DioHttp.get(Api.PoetryRandom, params);
    if (res != null && res['statusCode'] == '000000' && res['data'] != null) {
      // return res['data'];
      Map<String, dynamic> p = res['data'];
      Poetry poetry = Poetry.fromJson(p);
      return poetry;
    } else {
      return null;
    }
  }

  // 诗人列表
  static Future<List<Poet>> authors(params) async {
    var res = await DioHttp.get(Api.Authors, params);
    List<Poet> authors = [];
    if (res['statusCode'] == '000000' && res['data'] != null) {
      for (int i = 0; i < res['data'].length; i++) {
        Map<String, dynamic> a = res['data'][i];
        authors.add(Poet.fromJson(a));
      }
      return authors;
    } else {
      return [];
    }
  }

  // 诗人详情
  static Future<Poet> author(params) async {
    var res = await DioHttp.get(Api.Author, params);
    if (res != null && res['statusCode'] == '000000' && res['data'] != null) {
      Map<String, dynamic> u = res['data'];
      Poet author = Poet.fromJson(u);
      return author;
    } else {
      // registerKey.currentState.showSnackBar(
      //   SnackBar(
      //     content: Text(res['message'] ?? '注册失败'),
      //   ),
      // );
    }
    return null;
  }

  // 用户列表
  static Future<List<User>> users(params) async {
    var res = await DioHttp.get(Api.Users, params);
    List<User> users = [];
    if (res['statusCode'] == '000000' && res['data'] != null) {
      for (int i = 0; i < res['data'].length; i++) {
        Map<String, dynamic> u = res['data'][i];
        users.add(User.fromJson(u));
      }
      print('users$users');
      return users;
    } else {
      return [];
    }
  }

  // 用户详情
  static Future<User> user(params) async {
    var res = await DioHttp.get(Api.User, params);
    User user;
    if (res != null && res['statusCode'] == '000000' && res['data'] != null) {
      Map<String, dynamic> u = res['data'];
      user = User.fromJson(u);
      return user;
    } else {
      return null;
    }
  }

  // 用户登录
  static Future<User> login(params) async {
    var res = await DioHttp.post(Api.UserLogin, params);
    if (res != null && res['statusCode'] == '000000' && res['data'] != null) {
      Map<String, dynamic> u = res['data'];
      User user = User.fromJson(u);
      return user;
    } else {
      // loginKey.currentState.showSnackBar(
      //   SnackBar(content: Text(res['message'] ?? '登录失败')),
      // );
    }
    return null;
  }

  // 用户注册
  static Future<User> register(params) async {
    var res = await DioHttp.post(Api.UserRegister, params);
    if (res != null && res['statusCode'] == '000000' && res['data'] != null) {
      Map<String, dynamic> u = res['data'];
      User user = User.fromJson(u);
      return user;
    } else {
      // registerKey.currentState.showSnackBar(
      //   SnackBar(
      //     content: Text(res['message'] ?? '注册失败'),
      //   ),
      // );
    }
    return null;
  }

  // 用户找回密码
  static Future<User> retrieve(params) async {
    var res = await DioHttp.post(Api.UserRetrieve, params);
    if (res != null && res['statusCode'] == '000000' && res['data'] != null) {
      Map<String, dynamic> u = res['data'];
      User user = User.fromJson(u);
      return user;
    } else {
      // retrieveKey.currentState.showSnackBar(
      //   SnackBar(
      //     content: Text(res['message'] ?? '系统错误, 稍后再试.'),
      //   ),
      // );
    }
    return null;
  }

  // 用户发送验证码
  static Future<String> send(params) async {
    var res = await DioHttp.post(Api.UserSend, params);
    if (res != null && res['statusCode'] == '000000' && res['data'] != null) {
      return 'OK';
    } else {
      // retrieveKey.currentState.showSnackBar(
      //   SnackBar(
      //     content: Text(res['message'] ?? '发送失败'),
      //   ),
      // );
    }
    return null;
  }

  // 用户重置密码
  // 用户更新信息
  // 关注
  static Future<String> follow(params) async {
    var res = await DioHttp.post(Api.UserFollow, params);
    if (res != null && res['statusCode'] == '000000' && res['data'] != null) {
      return 'OK';
    } else {
      // retrieveKey.currentState.showSnackBar(
      //   SnackBar(
      //     content: Text(res['message'] ?? '发送失败'),
      //   ),
      // );
    }
    return null;
  }

  // 取消关注
  static Future<String> unfollow(params) async {
    var res = await DioHttp.post(Api.UserUnfollow, params);
    if (res != null && res['statusCode'] == '000000' && res['data'] != null) {
      return 'OK';
    }
    return null;
  }

  // 喜欢
  static Future<String> like(params) async {
    var res = await DioHttp.post(Api.UserLike, params);
    if (res != null && res['statusCode'] == '000000' && res['data'] != null) {
      return 'OK';
    }
    return null;
  }

  // 取消喜欢
  static Future<String> unlike(params) async {
    var res = await DioHttp.post(Api.UserUnlike, params);
    if (res != null && res['statusCode'] == '000000' && res['data'] != null) {
      return 'OK';
    }
    return null;
  }

  // 收藏
  static Future<String> favor(params) async {
    var res = await DioHttp.post(Api.UserFavor, params);
    if (res != null && res['statusCode'] == '000000' && res['data'] != null) {
      return 'OK';
    }
    return null;
  }

  // 取消收藏
  static Future<String> unfavor(params) async {
    var res = await DioHttp.post(Api.UserUnfavor, params);
    if (res != null && res['statusCode'] == '000000' && res['data'] != null) {
      return 'OK';
    }
    return null;
  }

  // 评论列表
  static Future<List<Comment>> comments(params) async {
    var res = await DioHttp.get(Api.Comments, params);
    List<Comment> comments = [];
    if (res['statusCode'] == '000000' && res['data'] != null) {
      for (int i = 0; i < res['data'].length; i++) {
        Map<String, dynamic> p = res['data'][i];
        comments.add(Comment.fromJson(p));
      }
      return comments;
    } else {
      return [];
    }
  }

  // 评论
  static Future<Comment> comment(params) async {
    var res = await DioHttp.post(Api.UserComment, params);
    if (res != null && res['statusCode'] == '000000' && res['data'] != null) {
      Map<String, dynamic> c = res['data'];
      Comment cmt = Comment.fromJson(c);
      return cmt;
    }
    return null;
  }
}
