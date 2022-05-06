import 'package:shared_preferences/shared_preferences.dart';

const String saharedData = "PostData";

class SharedPrefs {
  static late SharedPreferences _shared;

  factory SharedPrefs() => SharedPrefs._internal();

  SharedPrefs._internal();

  Future<void> init() async {
    _shared = await SharedPreferences.getInstance();
  }

  bool get control => _shared.containsKey(saharedData);

  String? get sharedData => _shared.getString(saharedData);

  Future<bool?> createDataShared(String post) async {
    bool? result = await _shared.setString(saharedData, post);
    return result;
  }

  Future<bool?> removeUserShared() async {
    bool? result = await _shared.remove(saharedData);
    return result;
  }
}
