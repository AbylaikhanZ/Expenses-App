import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmt;
  final double spendingPcnt;
  ChartBar(this.label, this.spendingAmt, this.spendingPcnt);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: ((context, constraints) {
      return Column(
        children: <Widget>[
          Container(
              height: constraints.maxHeight * 0.15,
              child:
                  FittedBox(child: Text("₸${spendingAmt.toStringAsFixed(0)}"))),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(
            height: constraints.maxHeight * 0.6,
            width: 10,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                          color: Color.fromRGBO(220, 220, 220, 1), width: 1.0)),
                ),
                FractionallySizedBox(
                  heightFactor: spendingPcnt,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(15)),
                  ),
                )
              ],
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(height: constraints.maxHeight * 0.15, child: Text(label))
        ],
      );
    }));
  }
}
