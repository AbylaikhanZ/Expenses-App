import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import '../models/transaction.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;
  TransactionList(this.transactions, this.deleteTx);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(7),
      child: transactions.isEmpty
          ? LayoutBuilder(builder: ((context, constraints) {
              return Column(
                children: <Widget>[
                  Text(
                    "   List of transactions is empty. Time to spend some money!",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(
                    height: constraints.maxHeight * 0.07,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      "assets/images/waiting.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              );
            }))
          : ListView.builder(
              itemBuilder: (ctx, index) {
                return Card(
                  elevation: 10,
                  margin: EdgeInsets.symmetric(vertical: 6.0, horizontal: 5.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Container(
                          height: 20,
                          child: FittedBox(
                              child: Text(
                            "₸${transactions[index].amount.toStringAsFixed(0)}",
                          )),
                        ),
                      ),
                    ),
                    title: Text(
                      transactions[index].title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    subtitle: Text(
                        DateFormat.yMMMd().format(transactions[index].dates)),
                    trailing: MediaQuery.of(context).size.width > 400
                        ? TextButton.icon(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              return deleteTx(transactions[index].id);
                            },
                            label: Text("Delete"),
                            style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Theme.of(context).errorColor)),
                          )
                        : IconButton(
                            onPressed: () {
                              return deleteTx(transactions[index].id);
                            },
                            icon: Icon(Icons.delete),
                            color: Theme.of(context).errorColor,
                          ),
                  ),
                );
              },
              itemCount: transactions.length,
            ),
    );
  }
}
