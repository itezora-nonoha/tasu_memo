import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/memo.dart';
import '../providers/memo_provider.dart';
import '../widgets/memo_item_tile.dart';
import '../utils/number_formatter.dart';

class MemoDetailScreen extends StatefulWidget {
  final Memo memo;

  const MemoDetailScreen({
    super.key,
    required this.memo,
  });

  @override
  State<MemoDetailScreen> createState() => _MemoDetailScreenState();
}

class _MemoDetailScreenState extends State<MemoDetailScreen> {
  late List<MemoItem> _items;
  late TextEditingController _titleController;

  @override
  void initState() {
    super.initState();
    _items = List.from(widget.memo.items);
    _titleController = TextEditingController(text: widget.memo.title);
  }

  void _updateMemo() {
    context.read<MemoProvider>().updateMemo(
          Memo(
            id: widget.memo.id,
            title: _titleController.text,
            items: _items,
          ),
        );
  }

  void _addItem() {
    setState(() {
      _items.add(MemoItem(text: '', value: 0));
    });
    _updateMemo();
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
    _updateMemo();
  }

  void _updateItem(int index, MemoItem updatedItem) {
    setState(() {
      _items[index] = updatedItem;
    });
    _updateMemo();
  }

  void _reorderItems(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _items.removeAt(oldIndex);
      _items.insert(newIndex, item);
    });
    _updateMemo();
  }

  @override
  Widget build(BuildContext context) {
    final total = _items.fold(0.0, (sum, item) => sum + item.value);

    return Scaffold(
      appBar: AppBar(
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _titleController,
            style: Theme.of(context).textTheme.titleLarge,
            decoration: const InputDecoration(
              border: InputBorder.none,
              hintText: 'メモタイトル',
              contentPadding: EdgeInsets.symmetric(vertical: 8),
            ),
            onChanged: (_) => _updateMemo(),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '合計: ${NumberFormatter.formatWithCurrency(total)}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Expanded(
            child: ReorderableListView.builder(
              itemCount: _items.length,
              onReorder: _reorderItems,
              itemBuilder: (context, index) {
                return MemoItemTile(
                  key: ValueKey(_items[index]),
                  item: _items[index],
                  onUpdate: (item) => _updateItem(index, item),
                  onDelete: () => _removeItem(index),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}
