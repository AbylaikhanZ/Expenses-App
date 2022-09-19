import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/widgets/adaptiveTextButton.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addNewTx;
  NewTransaction(this.addNewTx);

  @override
  State<NewTransaction> createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _pickedDate = null;

  void _submitData() {
    if (_amountController.text.isEmpty) return;
    final inputTitle = _titleController.text;
    final inputAmount = double.parse(_amountController.text);
    if (inputTitle.isEmpty || inputAmount <= 0 || _pickedDate == null) return;
    widget.addNewTx(_titleController.text, double.parse(_amountController.text),
        _pickedDate);
    Navigator.of(context).pop();
  }

  void _datePicker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime.now())
        .then((userDate) {
      if (userDate == null) return;
      setState(() {
        _pickedDate = userDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                autocorrect: true,
                decoration: InputDecoration(labelText: "Title"),
                controller: _titleController,
                cursorColor: Colors.deepPurple,
                onSubmitted: (_) => _submitData(),
                keyboardType: TextInputType.text,
              ),
              TextField(
                decoration: InputDecoration(labelText: "Amount"),
                controller: _amountController,
                cursorColor: Colors.deepPurple,
                onSubmitted: (_) => _submitData(),
                keyboardType: TextInputType.number,
              ),
              Container(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                        child: Text(_pickedDate == null
                            ? "No date chosen"
                            : "Purchase Date: ${DateFormat.yMd().format(_pickedDate)}")),
                    AdaptiveFlatButton("Select the date", _datePicker),
                  ],
                ),
              ),
              ElevatedButton(
                  onPressed: _submitData, child: Text("Add Transaction"))
            ],
          ),
        ),
      ),
    );
  }
}
