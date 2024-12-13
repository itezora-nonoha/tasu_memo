import 'package:flutter/material.dart';
import '../models/memo.dart';
import '../utils/number_formatter.dart';

class MemoItemTile extends StatefulWidget {
  final MemoItem item;
  final Function(MemoItem) onUpdate;
  final VoidCallback onDelete;

  const MemoItemTile({
    super.key,
    required this.item,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<MemoItemTile> createState() => _MemoItemTileState();
}

class _MemoItemTileState extends State<MemoItemTile> {
  late TextEditingController _textController;
  late TextEditingController _valueController;
  String _lastText = '';
  String _lastValue = '';

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.item.text);
    _valueController = TextEditingController(
      text: NumberFormatter.format(widget.item.value),
    );
    _lastText = widget.item.text;
    _lastValue = _valueController.text;
  }

  void _updateItem() {
    if (_lastText != _textController.text || _lastValue != _valueController.text) {
      _lastText = _textController.text;
      _lastValue = _valueController.text;
      
      widget.onUpdate(MemoItem(
        text: _textController.text,
        value: double.tryParse(_valueController.text.replaceAll(',', '')) ?? 0,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
        icon: const Icon(Icons.drag_handle),
        onPressed: null,
      ),
      title: Row(
        children: [
          Expanded(
            flex: 3,
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                hintText: 'テキストを入力',
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
              onEditingComplete: _updateItem,
              onSubmitted: (_) => _updateItem(),
              textInputAction: TextInputAction.done,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: TextField(
              controller: _valueController,
              decoration: const InputDecoration(
                prefixText: '¥',
                hintText: '0',
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              onEditingComplete: _updateItem,
              onSubmitted: (_) => _updateItem(),
              textInputAction: TextInputAction.done,
              onTapOutside: (_) => _updateItem(),
            ),
          ),
        ],
      ),
      trailing: IconButton(
        icon: const Icon(Icons.delete),
        onPressed: widget.onDelete,
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _valueController.dispose();
    super.dispose();
  }
}
