import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/memo.dart';

class StorageService {
  static const String _key = 'memos';
  final SharedPreferences _prefs;

  StorageService(this._prefs);

  Future<List<Memo>> loadMemos() async {
    final String? memosJson = _prefs.getString(_key);
    if (memosJson == null) return [];

    final List<dynamic> decoded = jsonDecode(memosJson);
    return decoded
        .map((item) => Memo.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveMemos(List<Memo> memos) async {
    final String encoded = jsonEncode(memos.map((m) => m.toJson()).toList());
    await _prefs.setString(_key, encoded);
  }
}
