import 'dart:math';

import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/Transactions.dart';

class TransactionItem extends StatefulWidget {
  final Function deleteTransaction;
  final Transactions transaction;

  const TransactionItem({
    Key? key,
    required this.deleteTransaction,
    required this.transaction,
  }) : super(key: key);

  @override
  State<TransactionItem> createState() => _TransactionItemState();
}

class _TransactionItemState extends State<TransactionItem> {
  Color? _bgColor;

  @override
  void initState() {
    const availableColors = [
      Colors.black,
      Colors.red,
      Colors.green,
      Colors.blue,
    ];
    _bgColor = availableColors[Random().nextInt(4)];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 5,
        vertical: 4,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: _bgColor,
          child: Container(
            padding: const EdgeInsets.all(7),
            child: FittedBox(child: Text("₺${widget.transaction.amount}")),
          ),
          radius: 30,
        ),
        title: Text(
          widget.transaction.title,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          DateFormat.yMMMd().format(widget.transaction.date),
        ),
        trailing: MediaQuery.of(context).size.width < 400
            ? IconButton(
                icon: const Icon(Icons.delete),
                color: Theme.of(context).errorColor,
                onPressed: () {
                  widget.deleteTransaction(widget.transaction.id);
                },
              )
            : TextButton.icon(
                onPressed: () {
                  widget.deleteTransaction(widget.transaction.id);
                },
                icon: Icon(
                  Icons.delete,
                  color: Theme.of(context).errorColor,
                ),
                label: Text(
                  "Delete",
                  style: TextStyle(color: Theme.of(context).errorColor),
                ),
              ),
      ),
    );
  }
}
