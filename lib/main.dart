import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '/widgets/chart.dart';
import '/widgets/newTransaction.dart';
import '/widgets/transactionList.dart';
import 'models/transaction.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      home: MyHomePage(),
      color: Colors.deepPurple,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        fontFamily: "Montserrat",
        appBarTheme: AppBarTheme(
            titleTextStyle: TextStyle(
          fontFamily: "Montserrat",
          fontSize: 20,
        )),
        textTheme: TextTheme(
            titleLarge: TextStyle(
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
                fontSize: 20),
            titleMedium: TextStyle(
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple)
            .copyWith(secondary: Colors.purple),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    // Transaction(id: "t1", title: "Meat", amount: 8040, dates: DateTime.now()),
    // Transaction(id: "t2", title: "Shoes", amount: 28000, dates: DateTime.now()),
  ];
  List<Transaction> get _recentTrans {
    return _userTransactions.where((tx) {
      return tx.dates.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _startAddingTransactions(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(_addNewTx);
        });
  }

  void _addNewTx(String newTitle, double newAmount, DateTime newDate) {
    final newTx = Transaction(
        amount: newAmount,
        dates: newDate,
        id: DateTime.now().toString(),
        title: newTitle);
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _deleteTx(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => element.id == id);
    });
  }

  bool _showChart = false;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Expenses'),
            trailing: Row(children: [
              GestureDetector(
                child: Icon(CupertinoIcons.add),
                onTap: () {
                  _startAddingTransactions(context);
                },
              )
            ], mainAxisSize: MainAxisSize.min),
          )
        : AppBar(
            title: Text('Personal Expenses'),
            actions: [
              IconButton(
                  onPressed: () {
                    _startAddingTransactions(context);
                  },
                  icon: Icon(Icons.add))
            ],
          );
    final txList = Container(
        height: (mediaQuery.size.height -
                appBar.preferredSize.height -
                mediaQuery.padding.top) *
            0.7,
        child: TransactionList(_userTransactions, _deleteTx));
    final appBody = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (isLandscape)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Show Chart",
                    style: Theme.of(context).textTheme.titleMedium),
                Switch.adaptive(
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    })
              ],
            ),
          if (!isLandscape)
            Container(
                height: (mediaQuery.size.height -
                        appBar.preferredSize.height -
                        mediaQuery.padding.top) *
                    0.3,
                child: Chart(_recentTrans)),
          if (!isLandscape) txList,
          if (isLandscape)
            _showChart
                ? Container(
                    height: (mediaQuery.size.height -
                            appBar.preferredSize.height -
                            mediaQuery.padding.top) *
                        0.7,
                    child: Chart(_recentTrans))
                : txList
        ],
      ),
    ));
    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: appBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: appBody,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    onPressed: () {
                      _startAddingTransactions(context);
                    },
                    child: Icon(Icons.add),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
