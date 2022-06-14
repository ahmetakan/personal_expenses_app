import 'package:flutter/material.dart';
import 'package:personal_expenses_app/widgets/ChartBar.dart';
import '../models/Transactions.dart';
import 'package:intl/intl.dart';

class Chart extends StatelessWidget {
  final List<Transactions> recentTransactions;

  Chart(this.recentTransactions);

  // List<Map<String, Object>> get groupedTransactionValues {
  //   return List.generate(7, (index) {
  //     var weekDay = DateTime.now().subtract(Duration(days: index));
  //     double totalSum = 0.0;

  //     for (var i = 0; i < recentTransactions.length; i++) {
  //       if (weekDay.day == recentTransactions[i].date.day &&
  //           weekDay.month == recentTransactions[i].date.month &&
  //           weekDay.year == recentTransactions[i].date.year) {
  //         totalSum += recentTransactions[i].amount;
  //       }
  //     }

  //     return {
  //       "day": DateFormat.E(weekDay).toString().substring(0, 1),
  //       "amount": totalSum,
  //     };
  //   });
  // }

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      var weekDay = DateTime.now().subtract(Duration(days: index));

      double totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      return {
        "day": DateFormat.E().format(weekDay).substring(0, 1),
        "amount": totalSum,
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, tx) {
      return sum + double.parse(tx["amount"].toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactionValues);

    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            return ChartBar(
                data["day"].toString(),
                double.parse(data["amount"].toString()),
                totalSpending == 0.0
                    ? 0.0
                    : double.parse(data["amount"].toString()) / totalSpending);
          }).toList(),
        ),
      ),
    );
  }
}
