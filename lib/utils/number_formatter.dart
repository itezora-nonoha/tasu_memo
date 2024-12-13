import 'package:intl/intl.dart';

class NumberFormatter {
  static final _formatter = NumberFormat('#,##0', 'ja_JP');
  
  static String format(double value) {
    return _formatter.format(value);
  }
  
  static String formatWithCurrency(double value) {
    return '¥${_formatter.format(value)}';
  }
}