import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modalcrud/busquedaCalcu.dart';
Widget alerdialogCodeRepeat(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text("Código repetido"),
      content: Text("Ingrese un código que no este registrado"),
      actions: [
        TextButton(
            onPressed: () {
              
              Navigator.pop(context);
            },
            child: Text("Close")),
        
      ],
    );
  }

Widget alerdialogProductRepeat(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text("Producto ya registrado"),
      content: Text("Ingrese un producto que no este registrado"),
      
    );
  }