import '../models/memo.dart';

class MemoUtils {
  static bool isEmptyItem(MemoItem item) {
    return item.text.isEmpty && item.value == 0;
  }

  static bool hasEmptyRow(List<MemoItem> items) {
    return items.any((item) => isEmptyItem(item));
  }

  static String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  static MemoItem createEmptyItem() {
    return MemoItem(text: '', value: 0);
  }

  static Memo createNewMemo() {
    return Memo(
      id: generateId(),
      title: '',
      items: [createEmptyItem()],
    );
  }
}