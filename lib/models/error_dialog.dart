import 'package:flutter/material.dart';

class ErrorDialog {
  Future<T> showCustomDialog<T>(
      BuildContext context, String message) async {
    return await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: Text("An error occurred"),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: Text("Ok"))
              ],
            ));
  }
}
