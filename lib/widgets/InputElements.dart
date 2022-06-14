import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import './AdaptiveTextButton.dart';

class InputElements extends StatefulWidget {
  final Function function;
  InputElements(this.function);

  @override
  State<InputElements> createState() => _InputElementsState();
}

class _InputElementsState extends State<InputElements> {
  final _titleController = TextEditingController();

  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  void addTx() {
    if (_titleController.text.isNotEmpty &&
        _amountController.text.isNotEmpty &&
        _selectedDate != null) {
      final tController = _titleController.text;
      final aController = double.parse(_amountController.text);
      widget.function(tController, aController, _selectedDate);
    } else {
      print("Lütfen girdi değerlerini kontrol edin.");
    }
  }

  void _selectDate() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime.now().subtract(
              const Duration(days: 6),
            ),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) {
        return pickedDate;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: "Ürün",
                  labelStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
                controller: _titleController,
              ),
              TextField(
                decoration: const InputDecoration(
                  labelText: "Tutar",
                  labelStyle: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                  ),
                ),
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                controller: _amountController,
                onSubmitted: (_) {
                  return addTx();
                },
              ),
              Row(
                children: [
                  Text(_selectedDate == null
                      ? "Tarih Seçilmedi!"
                      : DateFormat.yMMMd().format(_selectedDate!)),
                  AdaptiveTextButton("Tarih Seç", _selectDate),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  addTx();
                },
                child: const Text(
                  "İşlemi Ekle",
                ),
                style: Theme.of(context).elevatedButtonTheme.style,
              ),
            ],
          ),
          padding: EdgeInsets.only(
            left: 10,
            right: 10,
            top: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
        ),
      ),
    );
  }
}
