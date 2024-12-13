import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/memo_provider.dart';
import '../utils/memo_utils.dart';
import '../utils/number_formatter.dart';
import '../constants/app_strings.dart';
import 'memo_detail_screen.dart';

class MemoListScreen extends StatelessWidget {
  const MemoListScreen({super.key});

  void _addNewMemo(BuildContext context) {
    final newMemo = MemoUtils.createNewMemo();
    context.read<MemoProvider>().addMemo(newMemo);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MemoDetailScreen(memo: newMemo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.memoListTitle),
      ),
      body: Consumer<MemoProvider>(
        builder: (context, memoProvider, child) {
          return ListView.builder(
            itemCount: memoProvider.memos.length,
            itemBuilder: (context, index) {
              final memo = memoProvider.memos[index];
              final nonEmptyItems = memo.items
                  .where((item) => !MemoUtils.isEmptyItem(item));
              final total = nonEmptyItems.fold(
                0.0, 
                (sum, item) => sum + item.value,
              );

              return ListTile(
                title: Text(memo.title.isEmpty 
                  ? AppStrings.newMemoTitle 
                  : memo.title),
                subtitle: Text(
                  '${AppStrings.totalPrefix}${NumberFormatter.formatWithCurrency(total)}',
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MemoDetailScreen(memo: memo),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addNewMemo(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
