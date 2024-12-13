class MemoItem {
  String text;
  double value;

  MemoItem({
    required this.text,
    required this.value,
  });

  Map<String, dynamic> toJson() => {
    'text': text,
    'value': value,
  };

  factory MemoItem.fromJson(Map<String, dynamic> json) => MemoItem(
    text: json['text'] as String,
    value: json['value'] as double,
  );
}

class Memo {
  String id;
  String title;
  List<MemoItem> items;

  Memo({
    required this.id,
    required this.title,
    required this.items,
  });

  double get total => items.fold(0, (sum, item) => sum + item.value);

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'items': items.map((item) => item.toJson()).toList(),
  };

  factory Memo.fromJson(Map<String, dynamic> json) => Memo(
    id: json['id'] as String,
    title: json['title'] as String,
    items: (json['items'] as List)
        .map((item) => MemoItem.fromJson(item as Map<String, dynamic>))
        .toList(),
  );
}
