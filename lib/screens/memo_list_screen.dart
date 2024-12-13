import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/memo.dart';
import '../providers/memo_provider.dart';
import '../utils/number_formatter.dart';
import 'memo_detail_screen.dart';

class MemoListScreen extends StatelessWidget {
  const MemoListScreen({super.key});

  void _addNewMemo(BuildContext context) {
    final newMemo = Memo(
      id: DateTime.now().toString(),
      title: 'New Memo',
      items: [],
    );

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
        title: const Text('メモ一覧'),
      ),
      body: Consumer<MemoProvider>(
        builder: (context, memoProvider, child) {
          return ListView.builder(
            itemCount: memoProvider.memos.length,
            itemBuilder: (context, index) {
              final memo = memoProvider.memos[index];
              return ListTile(
                title: Text(memo.title),
                subtitle: Text('合計: ${NumberFormatter.formatWithCurrency(memo.total)}'),
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
