import 'dart:async';

import 'package:flutter/material.dart';

import '../models/Transactions.dart';
import './TransactionItem.dart';

class InfoTx extends StatelessWidget {
  final List<Transactions> transactions;
  final Function deleteTransaction;

  InfoTx(this.transactions, this.deleteTransaction);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: transactions.isEmpty
          ? LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  children: [
                    Text(
                      "There is no transaction yet!",
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Container(
                      child: Image.asset(
                        "assets/images/waiting.png",
                        fit: BoxFit.cover,
                      ),
                      height: constraints.maxHeight * 0.6,
                      margin: const EdgeInsets.only(top: 20),
                    ),
                  ],
                );
              },
            )
          : ListView(
              children: transactions.map((tx) {
                return TransactionItem(
                  key: ValueKey(tx.id),
                  deleteTransaction: deleteTransaction,
                  transaction: tx,
                );
              }).toList(),
            ),
      color: Colors.purple.shade100,
    );
  }
}
