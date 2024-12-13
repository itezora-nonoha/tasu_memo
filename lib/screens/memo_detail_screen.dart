import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/memo.dart';
import '../providers/memo_provider.dart';
import '../widgets/memo_item_tile.dart';
import '../widgets/total_display.dart';
import '../utils/memo_utils.dart';
import '../utils/platform_utils.dart';
import '../constants/app_strings.dart';

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
    if (!MemoUtils.hasEmptyRow(_items)) {
      _items.add(MemoUtils.createEmptyItem());
    }
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

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
      if (!MemoUtils.hasEmptyRow(_items)) {
        _items.add(MemoUtils.createEmptyItem());
      }
    });
    _updateMemo();
  }

  void _updateItem(int index, MemoItem updatedItem) {
    setState(() {
      _items[index] = updatedItem;
      
      if (index == _items.length - 1 && !MemoUtils.isEmptyItem(updatedItem)) {
        _items.add(MemoUtils.createEmptyItem());
      }
      
      if (_items.length > 1) {
        _items.removeWhere((item) => 
          MemoUtils.isEmptyItem(item) && 
          _items.indexOf(item) != _items.length - 1
        );
      }
    });
    _updateMemo();
  }

  void _reorderItems(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      if (oldIndex != _items.length - 1 && newIndex != _items.length - 1) {
        final item = _items.removeAt(oldIndex);
        _items.insert(newIndex, item);
      }
    });
    _updateMemo();
  }

  @override
  Widget build(BuildContext context) {
    final total = _items
        .where((item) => !MemoUtils.isEmptyItem(item))
        .fold(0.0, (sum, item) => sum + item.value);

    final isDesktop = PlatformUtils.isDesktop;

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _titleController,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: AppStrings.memoTitleHint,
          ),
          onChanged: (_) => _updateMemo(),
        ),
      ),
      body: Column(
        children: [
          TotalDisplay(total: total),
          Expanded(
            child: ReorderableListView(
              // buildDefaultDragHandles: false,
              onReorder: _reorderItems,
              children: [
                for (int index = 0; index < _items.length; index++)
                  MemoItemTile(
                    key: ValueKey(_items[index]),
                    item: _items[index],
                    onUpdate: (item) => _updateItem(index, item),
                    onDelete: () => _removeItem(index),
                    isLastItem: index == _items.length - 1,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }
}
