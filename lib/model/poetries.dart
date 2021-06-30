import 'package:flutter/foundation.dart';
import 'package:min_poetry_flutter/api/fetch.dart';
import 'package:min_poetry_flutter/model/poetry.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Poetries with ChangeNotifier {
  Poetries() {
    fetchingRandom();
  }

  Future<void> fetchingRandom() async {
    SharedPreferences refs = await SharedPreferences.getInstance();
    String type = refs.getString('type') ?? '';
    String userid = refs.getString('id') ?? '';
    Poetry p = await Fetch.random({'userid': userid, 'type': type});
    print('>>>>random${p.rhythmic}');
    _random = p;
  }

  List<Poetry> _stars = []; // 首页
  List<Poetry> _paras = []; // 正文搜索
  List<Poetry> _users = []; // 词人搜索
  List<Poetry> _poets = []; // 词人
  Poetry _random;

  List<Poetry> get stars => _stars;
  List<Poetry> get paras => _paras;
  List<Poetry> get poets => _poets;
  List<Poetry> get users => _users;
  Poetry get random => _random;

  Poetry find(String type, int index) {
    if (type == 'stars') {
      return _stars[index];
    } else if (type == 'paras') {
      return _paras[index];
    } else if (type == 'poets') {
      return _poets[index];
    } else if (type == 'users') {
      return _users[index];
    } else if (type == 'random') {
      return _random;
    }
    return null;
  }

  void add(String type, Poetry poetry) {
    // print('>>>random add$poetry');
    if (type == 'random') {
      _random = poetry;
    }
    notifyListeners();
  }

  void addAll(String type, List<Poetry> poetries, int page) {
    if (type == 'stars') {
      if (page == 1) {
        _stars = poetries;
      } else {
        _stars.addAll(poetries);
      }
    } else if (type == 'paras') {
      if (page == 1) {
        _paras = poetries;
      } else {
        _paras.addAll(poetries);
      }
    } else if (type == 'poets') {
      if (page == 1) {
        _poets = poetries;
      } else {
        _poets.addAll(poetries);
      }
    } else if (type == 'users') {
      if (page == 1) {
        _users = poetries;
      } else {
        _users.addAll(poetries);
      }
    }
    notifyListeners();
  }

  // 修改诗词的内容, 同步到所有列表中
  void updateAll(String id, String type, String key, dynamic value) {
    // print('update>>>>-$id-$type-$key-$value');
    if (random != null && random.id == id) {
      print('@@@random change');
      if (key == 'like') {
        random.like = value;
      } else if (key == 'liked') {
        random.liked = value;
      } else if (key == 'favored') {
        random.favored = value;
      } else if (key == 'comment') {
        random.comment = value;
      }
    }
    Poetry star =
        stars.firstWhere((e) => e != null && e.id == id, orElse: () => null);
    if (star != null) {
      print('@@@star change');
      if (key == 'like') {
        star.like = value;
      } else if (key == 'liked') {
        star.liked = value;
      } else if (key == 'favored') {
        star.favored = value;
      } else if (key == 'comment') {
        star.comment = value;
        print('comment${star.comment}');
      }
    }
    Poetry para =
        paras.firstWhere((e) => e != null && e.id == id, orElse: () => null);
    if (para != null) {
      print('@@@para change');

      if (key == 'like') {
        para.like = value;
      } else if (key == 'liked') {
        para.liked = value;
      } else if (key == 'favored') {
        para.favored = value;
      } else if (key == 'comment') {
        para.comment = value;
      }
    }
    Poetry poet =
        poets.firstWhere((e) => e != null && e.id == id, orElse: () => null);
    if (poet != null) {
      print('@@@poet change');
      if (key == 'like') {
        poet.like = value;
      } else if (key == 'liked') {
        poet.liked = value;
      } else if (key == 'favored') {
        poet.favored = value;
      } else if (key == 'comment') {
        poet.comment = value;
      }
    }
    Poetry user =
        users.firstWhere((e) => e != null && e.id == id, orElse: () => null);
    if (user != null) {
      print('@@@user change');

      if (key == 'like') {
        user.like = value;
      } else if (key == 'liked') {
        user.liked = value;
      } else if (key == 'favored') {
        user.favored = value;
      } else if (key == 'comment') {
        user.comment = value;
      }
    }

    notifyListeners();
  }

  void refresh(String type) {
    if (type == 'stars') {
      _stars.clear();
    } else if (type == 'paras') {
      _paras.clear();
    } else if (type == 'poets') {
      _poets.clear();
    } else if (type == 'users') {
      _users.clear();
    }
    notifyListeners();
  }
}
