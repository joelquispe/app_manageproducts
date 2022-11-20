import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:modalcrud/bs/db.dart';
void clearText(TextEditingController _controlQr,
  TextEditingController _controlName,
  TextEditingController _controlPrice,) {
    _controlQr.text = "";
    _controlName.text = "";
    _controlPrice.text = "";
  }

Widget  buttonBacks(BuildContext context,TextEditingController _controlQr,
  TextEditingController _controlName,
  TextEditingController _controlPrice,) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF114b5f),
      ),
      onPressed: () {
        clearText(_controlQr,_controlName,_controlPrice);
        Navigator.pop(context);
      },
      child: Text("Cancelar"),
    );
  }

Widget ImproveAlerdialog(BuildContext context,String code) {
    return CupertinoAlertDialog(
      title: Text("Eliminara un producto"),
      content: Text("¿Esta seguro de querer eliminar el producto?"),
      actions: [
        TextButton(
            onPressed: () {
              delete(code);
              Navigator.pop(context);
            },
            child: Text("SI")),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("NO")),
      ],
    );
  }