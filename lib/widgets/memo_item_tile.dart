import 'package:flutter/material.dart';
import 'dart:async';
import '../models/memo.dart';
import '../constants/app_strings.dart';
import '../utils/number_formatter.dart';
import '../utils/platform_utils.dart';

class MemoItemTile extends StatefulWidget {
  final MemoItem item;
  final Function(MemoItem) onUpdate;
  final VoidCallback onDelete;
  final bool isLastItem;
  final Function(bool)? onReorderMode;

  const MemoItemTile({
    super.key,
    required this.item,
    required this.onUpdate,
    required this.onDelete,
    required this.isLastItem,
    this.onReorderMode,
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
    _debounceTimer = Timer(const Duration(milliseconds: 10000), () {
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

  Widget _buildInputFields() {
    return Row(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = PlatformUtils.isDesktop;
    final content = Row(
      children: [
        if (!widget.isLastItem)
          ReorderableDragStartListener(
            index: -1, // インデックスは ReorderableListView で上書きされます
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.0),
              // child: Icon(Icons.drag_handle),
            ),
          ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: _buildInputFields(),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
        ),
        if (isDesktop && !widget.isLastItem) // なんかisDesktopが機能してない
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: widget.onDelete,
          ),
      ],
    );

    if (!isDesktop && !widget.isLastItem) {
      return Dismissible(
        key: widget.key!,
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20.0),
          child: const Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        onDismissed: (_) => widget.onDelete(),
        child: content,
      );
    }

    return content;
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
