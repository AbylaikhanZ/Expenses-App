import 'package:flutter/foundation.dart';

class Transaction {
  final String id;
  final String title;
  final double amount;
  final DateTime dates;
  Transaction(
      {@required this.amount,
      @required this.dates,
      @required this.id,
      @required this.title});
}
