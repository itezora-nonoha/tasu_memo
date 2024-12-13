import 'package:flutter/material.dart';
import '../constants/app_strings.dart';
import '../utils/number_formatter.dart';

class TotalDisplay extends StatelessWidget {
  final double total;

  const TotalDisplay({
    super.key,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        '${AppStrings.totalPrefix}${NumberFormatter.formatWithCurrency(total)}',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }
}