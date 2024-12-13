import 'package:flutter/foundation.dart';
import '../models/memo.dart';
import '../services/storage_service.dart';

class MemoProvider with ChangeNotifier {
  final StorageService _storage;
  List<Memo> _memos = [];

  MemoProvider(this._storage) {
    _loadMemos();
  }

  List<Memo> get memos => List.unmodifiable(_memos);

  Future<void> _loadMemos() async {
    _memos = await _storage.loadMemos();
    notifyListeners();
  }

  Future<void> _saveMemos() async {
    await _storage.saveMemos(_memos);
  }

  void addMemo(Memo memo) {
    _memos.add(memo);
    _saveMemos();
    notifyListeners();
  }

  void updateMemo(Memo updatedMemo) {
    final index = _memos.indexWhere((memo) => memo.id == updatedMemo.id);
    if (index != -1) {
      _memos[index] = updatedMemo;
      _saveMemos();
      notifyListeners();
    }
  }

  void deleteMemo(String id) {
    _memos.removeWhere((memo) => memo.id == id);
    _saveMemos();
    notifyListeners();
  }
}