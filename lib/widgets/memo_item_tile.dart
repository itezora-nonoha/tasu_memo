import 'dart:async';

import 'package:flutter/material.dart';
import '../models/memo.dart';
import '../constants/app_strings.dart';
import '../utils/number_formatter.dart';

class MemoItemTile extends StatefulWidget {
  final MemoItem item;
  final Function(MemoItem) onUpdate;
  final VoidCallback onDelete;
  final bool isLastItem;

  const MemoItemTile({
    super.key,
    required this.item,
    required this.onUpdate,
    required this.onDelete,
    required this.isLastItem,
  });

  @override
  State<MemoItemTile> createState() => _MemoItemTileState();
}

class _MemoItemTileState extends State<MemoItemTile> {
  late TextEditingController _textController;
  late TextEditingController _valueController;
  final FocusNode _textFocusNode = FocusNode();
  final FocusNode _valueFocusNode = FocusNode();
  String _lastText = '';
  String _lastValue = '';
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.item.text);
    _valueController = TextEditingController(
      text: widget.item.value > 0 
          ? NumberFormatter.format(widget.item.value)
          : '',
    );
    _lastText = widget.item.text;
    _lastValue = _valueController.text;

    _textFocusNode.addListener(_handleTextFocusChange);
    _valueFocusNode.addListener(_handleValueFocusChange);
  }

  void _handleTextFocusChange() {
    if (!_textFocusNode.hasFocus) {
      _updateItem();
    }
  }

  void _handleValueFocusChange() {
    if (!_valueFocusNode.hasFocus) {
      _updateItem();
    }
  }

  void _debouncedUpdate() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        _updateItem();
      }
    });
  }

  void _updateItem() {
    if (_lastText != _textController.text || _lastValue != _valueController.text) {
      _lastText = _textController.text;
      _lastValue = _valueController.text;
      
      final value = _valueController.text.isEmpty 
          ? 0.0 
          : double.tryParse(_valueController.text.replaceAll(',', '')) ?? 0.0;
      
      widget.onUpdate(MemoItem(
        text: _textController.text,
        value: value,
      ));
    }
  }

  void _handleTextSubmitted(String value) {
    _updateItem();
    FocusScope.of(context).requestFocus(_valueFocusNode);
  }

  void _handleValueSubmitted(String value) {
    _updateItem();
    FocusScope.of(context).unfocus();
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
              focusNode: _textFocusNode,
              decoration: const InputDecoration(
                hintText: AppStrings.textInputHint,
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
              onChanged: (value) => _debouncedUpdate(),
              onSubmitted: _handleTextSubmitted,
              textInputAction: TextInputAction.next,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: TextField(
              controller: _valueController,
              focusNode: _valueFocusNode,
              decoration: const InputDecoration(
                prefixText: AppStrings.currencySymbol,
                hintText: AppStrings.defaultValue,
                contentPadding: EdgeInsets.symmetric(horizontal: 8),
              ),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              onChanged: (value) => _debouncedUpdate(),
              onSubmitted: _handleValueSubmitted,
              textInputAction: TextInputAction.done,
            ),
          ),
        ],
      ),
      trailing: widget.isLastItem 
          ? null 
          : IconButton(
              icon: const Icon(Icons.delete),
              onPressed: widget.onDelete,
            ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _valueController.dispose();
    _textFocusNode.dispose();
    _valueFocusNode.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }
}
