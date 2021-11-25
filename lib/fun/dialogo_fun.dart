import 'package:flutter/material.dart';

Future<bool> mostrarAlertaConfirmacao(BuildContext context, String content,
    {String title = 'Atenção'}) async {
  return (await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                child: const Text('NÃO', style: TextStyle(fontSize: 16)),
                onPressed: () => Navigator.of(context).pop(false),
              ),
              TextButton(
                child: const Text('SIM', style: TextStyle(fontSize: 16)),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        },
      )) ??
      false;
}

void mostrarSnackbar(
  BuildContext context,
  String msg, {
  int sec = 6,
  Color cor = Colors.blue,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      // margin: EdgeInsets.fromLTRB(12, 0, 12, screenH - (60) - (18 + 24)),
      behavior: SnackBarBehavior.floating,
      padding: const EdgeInsets.symmetric(vertical: 8 * 3, horizontal: 12),
      content: Text(
        msg,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      backgroundColor: cor,
      duration: const Duration(seconds: 1),
    ),
  );
}
