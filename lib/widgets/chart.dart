import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/chartBar.dart';
import '/models/transaction.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTrans;
  Chart(this.recentTrans);
  List<Map<String, Object>> get groupedTransVals {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      var totalSum = 0.0;
      for (int i = 0; i < recentTrans.length; i++) {
        if (recentTrans[i].dates.day == weekDay.day &&
            recentTrans[i].dates.year == weekDay.year &&
            recentTrans[i].dates.month == weekDay.month)
          totalSum += recentTrans[i].amount;
      }
      print(DateFormat.E().format(weekDay));
      print(totalSum);
      return {
        "day": DateFormat.E().format(weekDay).substring(0, 1),
        "amount": totalSum
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransVals.fold(0.0, (sum, item) {
      return sum + item["amount"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransVals.map((data) {
            return Flexible(
              fit: FlexFit.tight,
              child: ChartBar(
                  data["day"],
                  data["amount"],
                  totalSpending == 0.0
                      ? 0.0
                      : (data["amount"] as double) / totalSpending),
            );
          }).toList(),
        ),
      ),
    );
  }
}
