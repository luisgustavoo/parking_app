import 'package:parking_app/core/rest_client/local_storages/local_storage.dart';
import 'package:parking_app/core/rest_client/local_storages/navigator/parking_navigator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesLocalStorageImpl implements LocalStorage {
  Future<SharedPreferences> get _instance => SharedPreferences.getInstance();

  @override
  Future<void> clear() async {
    final sp = await _instance;
    await sp.clear();
  }

  @override
  Future<bool> contains(String key) async {
    final sp = await _instance;
    return sp.containsKey(key);
  }

  @override
  Future<T?> read<T>(String key) async {
    final sp = await _instance;

    dynamic value;

    switch (T) {
      case const (String):
        value = sp.getString(key);
        return value as T?;
      case const (int):
        value = sp.getInt(key);
        return value as T?;
      case const (double):
        value = sp.getDouble(key);
        return value as T?;
      case const (bool):
        value = sp.getBool(key);
        return value as T?;
      case const (List<String>):
        value = sp.getStringList(key);
        return value as T?;
      default:
        return null;
    }
  }

  @override
  Future<void> remove(String key) async {
    final sp = await _instance;
    await sp.remove(key);
  }

  @override
  Future<void> write<T>(String key, T value) async {
    final sp = await _instance;

    switch (T) {
      case const (String):
        await sp.setString(key, value as String);
        break;
      case const (int):
        await sp.setInt(key, value as int);
        break;
      case const (bool):
        await sp.setBool(key, value as bool);
        break;
      case const (double):
        await sp.setDouble(key, value as double);
        break;
      case const (List<String>):
        await sp.setStringList(key, value as List<String>);
        break;
    }
  }

  @override
  Future<void> logout() async {
    // remove(Constants.localUserKey);
    await clear();

    await ParkingNavigator.to!
        .pushNamedAndRemoveUntil('/auth/login', (route) => false);
  }
}
