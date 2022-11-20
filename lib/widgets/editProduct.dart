import 'package:flutter/material.dart';
import 'package:modalcrud/bs/db.dart';
import 'package:modalcrud/improvements/addFeaturesVoids.dart';

void buttonPressedEdit(
  BuildContext context,
  int inde,
  String codeq,
  String name,
  String price,
) {
  TextEditingController _controlName = TextEditingController(text: "");
  TextEditingController _controlPrice = TextEditingController(text: "");
  TextEditingController _controlQr = TextEditingController(text: "");
  TextEditingController searchController = TextEditingController(text: "");
  void addDot() {
    if (!_controlPrice.text.contains(".")) {
      _controlPrice.text += ".00";
    }
  }

  void addZero() {
    if (_controlPrice.text
            .substring(
                _controlPrice.text.indexOf(".") + 1, _controlPrice.text.length)
            .length <=
        1) {
      _controlPrice.text += "0";
    }
    print(_controlPrice.text
        .substring(_controlPrice.text.indexOf("."), _controlPrice.text.length)
        .length);
  }

  showModalBottomSheet(
      backgroundColor: Color(0xFFf3e9d2),
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(18.0),
                  child: Text(
                    "Modificar Producto",
                    style: TextStyle(
                      fontSize: 25.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Helvetica',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(18.0),
                  child: TextField(
                    controller: _controlQr,
                    enabled: false,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: codeq),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(18.0),
                  child: TextField(
                    controller: _controlName,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: name),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(18.0),
                  child: TextField(
                    controller: _controlPrice,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: price),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFF114b5f)),
                          onPressed: () {
                            if (_controlName.text == "") {
                              _controlName.text = name;
                            }
                            if (_controlPrice.text == "") {
                              _controlPrice.text = price;
                            }
                            addDot();
                            addZero();
                            update(codeq, _controlName, _controlPrice);
                            Navigator.pop(context);

                            clearText(
                              _controlQr,
                              _controlName,
                              _controlPrice,
                            );
                          },
                          child: Text("Guardar")),
                      SizedBox(
                        width: 10.0,
                      ),
                      buttonBacks(
                          context, _controlQr, _controlName, _controlPrice),
                      SizedBox(
                        width: 10.0,
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      });
}
