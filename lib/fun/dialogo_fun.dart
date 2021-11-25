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
