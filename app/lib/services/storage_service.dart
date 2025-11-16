import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';

class StorageService {
  static const String userBoxName = 'userBox';
  static Box<UserModel>? _userBox;

  static Future<void> init() async {
    _userBox = await Hive.openBox<UserModel>(userBoxName);
  }

  static Future<void> saveUser(UserModel user) async {
    await _userBox?.put('current_user', user);
  }

  static UserModel? getCurrentUser() {
    return _userBox?.get('current_user');
  }

  static Future<void> clearUser() async {
    await _userBox?.clear();
  }

  static bool hasUser() {
    return _userBox?.get('current_user') != null;
  }
}

