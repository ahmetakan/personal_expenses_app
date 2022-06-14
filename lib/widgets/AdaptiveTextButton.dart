import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveTextButton extends StatelessWidget {
  final String text;
  final Function _selectDate;

  AdaptiveTextButton(this.text, this._selectDate);

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(text),
            onPressed: () {
              _selectDate();
            },
          )
        : TextButton(
            onPressed: () {
              _selectDate();
            },
            child: Text(text),
            style: Theme.of(context).textButtonTheme.style,
          );
  }
}
