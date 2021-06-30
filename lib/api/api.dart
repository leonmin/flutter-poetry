class Api {
  // static const String BASE_URL = 'http://192.168.101.2:9701/api';
  // static const String BASE_URL = 'http://localhost:9701/api';
  // static const String BASE_URL = 'https://poetry.leonmin.com/api/peotry/';
  static const String BASE_URL = 'https://gujiu.leonmin.com/api';
  // 诗词
  static const String Poetries = BASE_URL + '/poetries';
  static const String Poetry = BASE_URL + '/poetries/find';
  static const String PoetryRandom = BASE_URL + '/poetries/random';
  // 诗人
  static const String Authors = BASE_URL + '/authors';
  static const String Author = BASE_URL + '/authors/find';
  // 用户
  static const String Users = BASE_URL + '/users';
  static const String User = BASE_URL + '/users/find';
  static const String UserLogin = BASE_URL + '/users/login';
  static const String UserRegister = BASE_URL + '/users/register';
  static const String UserRetrieve = BASE_URL + '/users/retrieve';
  static const String UserSend = BASE_URL + '/users/send';
  static const String UserUpdate = BASE_URL + '/user/update';
  static const String UserChange = BASE_URL + '/user/change';
  static const String UserFollow = BASE_URL + '/user/follow';
  static const String UserUnfollow = BASE_URL + '/user/unfollow';
  static const String UserLike = BASE_URL + '/user/like';
  static const String UserUnlike = BASE_URL + '/user/unlike';
  static const String UserFavor = BASE_URL + '/user/favor';
  static const String UserUnfavor = BASE_URL + '/user/unfavor';
  static const String UserComment = BASE_URL + '/user/comment';

  // 评论
  static const String Comments = BASE_URL + '/comments';

  // 测试401
  static const String TEST401 = BASE_URL + '/user/test';
}
