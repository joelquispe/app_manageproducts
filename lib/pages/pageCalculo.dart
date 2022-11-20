import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:modalcrud/busquedaCalcu.dart';

import 'package:modalcrud/models/claseCalculo.dart';
import 'package:modalcrud/models/claselistacalcu.dart';
import 'package:modalcrud/widgets/drawer.dart';

class CalculoPage extends StatefulWidget {
  static final String route = "calcupage";
  CalculoPage({Key? key}) : super(key: key);

  @override
  _CalculoPageState createState() => _CalculoPageState();
}

class _CalculoPageState extends State<CalculoPage> {
  TextEditingController _controlPayClient = new TextEditingController();

  String _entry = "";
  String _valueCal = "";

  final firebase = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    setState(() {});
    super.initState();
    setState(() {});
  }

  Future _scannerBarCalculate() async {
    await FlutterBarcodeScanner.scanBarcode(
            "#004297", "Cancel", true, ScanMode.BARCODE)
        .then((value) => setState(() => firebase
                .collection(uid)
                .doc(value)
                .get()
                .then((DocumentSnapshot doc) {
              setState(() {});
              produCalcu.add(ProduCalcu(doc.get("CodigoQr"), doc.get("Nombre"),
                  double.parse(doc.get("Precio")), 1));
              suma += double.parse(doc.get("Precio"));
            })));
  }

  getProductid(String code, List<ProduCalcu> ca) {
    firebase.collection(uid).doc(code).get().then((DocumentSnapshot doc) {
      ca.add(ProduCalcu(
          doc.get("CodigoQr"), doc.get("Nombre"), doc.get("Precio"), 1));
      suma += double.parse(doc.get("Precio"));
    });
  }

  double roundDouble(double value, int places) {
    num mod = pow(10.0, places);
    return ((value * mod).round().toDouble() / mod);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color(0xFF114B5F)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Color(0xFF114b5f),
          title: Text("Calculo"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, BusquedaCalcu.route);
                },
                icon: Icon(Icons.search)),
            IconButton(
                onPressed: () {
                  showDialog(context: context, builder: (_) => alerdialog());
                },
                icon: Icon(Icons.delete_sweep)),
          ],
        ),
        // Stack(children: [listarfirebase(), _draggable()]),
        drawer: drawerMain(context),
        body: Column(children: [
          Expanded(
            flex: 8,
            child: Container(child: listarfirebase(),)),
          Expanded(
            flex: 2,
            child: Container(child:_draggable() ,))
          
        ],),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _scannerBarCalculate();
          },
          child: Image.asset(
            'assets/barcode.png',
            width: 45.0,
          ),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }

  Widget alerdialog() {
    return CupertinoAlertDialog(
      title: Text("Eliminar ista de compra"),
      content: Text("¿Esta segur@ de querer eliminar la lista?"),
      actions: [
        TextButton(
            onPressed: () {
              produCalcu.clear();
              suma = 0;
              payClient = 0;
              _controlPayClient.clear();
              setState(() {});
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

  Widget _draggable() {
    return DraggableScrollableSheet(
        initialChildSize: 1.0,
        minChildSize: 1.0,
        
        builder: (context, s) {
          return SingleChildScrollView(
            controller: s,
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [Color(0xFF114B5F), Color(0xFF88d498)],
                      begin: FractionalOffset(0.0, 0.1),
                      end: FractionalOffset(0.0, 1.0)),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  )),
              child: Column(
                children: [
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Total a pagar   :   ",
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                      Text(
                        suma.toStringAsFixed(2),
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 7.0, horizontal: 15.0),
                    child: TextField(
                      controller: _controlPayClient,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                          hintText: "Pago de cliente",
                          hintStyle: TextStyle(color: Colors.white),
                          border: OutlineInputBorder()),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Cambio  :   ",
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
                      Text(
                        payClient.toStringAsFixed(2),
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFF114B5F), elevation: 5),
                          onPressed: () {
                            if (_controlPayClient.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content:
                                          Text("Ingrese el pago del cliente"),
                                      duration: Duration(seconds: 1)));
                            }
                            payClient =
                                double.parse(_controlPayClient.text) - suma;
                            setState(() {});
                          },
                          child: Text(
                            "Calcular cambio",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.0),
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget listarfirebase() {
    return  SingleChildScrollView(
            physics: ScrollPhysics(),
            child: ListView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: produCalcu.length,
                itemBuilder: (_, i) {
                  return Container(
                    decoration: BoxDecoration(
                        color: Color(0xFFf3e9d2),
                        border: Border.all(color: Colors.black)),
                    child: Column(
                      children: [
                        Divider(
                          height: 7.0,
                        ),
                        Row(
                          children: [
                            Expanded(
                                child: ListTile(
                              title: Text(produCalcu[i].nom),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0)),
                              subtitle: Text("Precio:" +
                                  produCalcu[i].pric.toString() +
                                  "\n" +
                                  "Cantidad:" +
                                  produCalcu[i].canti.toString()),
                              leading: IconButton(
                                  onPressed: () {
                                    suma = suma -
                                        (produCalcu[i].canti *
                                            produCalcu[i].pric);
                                    produCalcu.removeAt(i);
                                    setState(() {});
                                  },
                                  icon: Icon(Icons.delete)),
                              isThreeLine: true,
                            )),
                            IconButton(
                                onPressed: () {
                                  suma += produCalcu[i].pric;
                                  produCalcu[i].canti += 1;
                                  setState(() {});
                                },
                                icon: Icon(Icons.plus_one_outlined)),
                            IconButton(
                                onPressed: () {
                                  suma -= produCalcu[i].pric;
                                  roundDouble(suma, 3);
                                  produCalcu[i].canti -= 1;
                                  if (produCalcu[i].canti == 0) {
                                    produCalcu.removeAt(i);
                                  }
                                  setState(() {});
                                },
                                icon: Icon(Icons.exposure_minus_1_outlined))
                          ],
                        ),
                      ],
                    ),
                  );
                }));
  }
}


// Widget listarfirebase() {
//     return SizedBox(
//         width: double.infinity,
//         height: 680,
//         child: SingleChildScrollView(
//             physics: ScrollPhysics(),
//             child: ListView.builder(
//                 shrinkWrap: true,
//                 physics: ScrollPhysics(),
//                 itemCount: produCalcu.length,
//                 itemBuilder: (_, i) {
//                   return Container(
//                     decoration: BoxDecoration(
//                         color: Color(0xFFf3e9d2),
//                         border: Border.all(color: Colors.black)),
//                     child: Column(
//                       children: [
//                         Divider(
//                           height: 7.0,
//                         ),
//                         Row(
//                           children: [
//                             Expanded(
//                                 child: ListTile(
//                               title: Text(produCalcu[i].nom),
//                               shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(20.0)),
//                               subtitle: Text("Precio:" +
//                                   produCalcu[i].pric.toString() +
//                                   "\n" +
//                                   "Cantidad:" +
//                                   produCalcu[i].canti.toString()),
//                               leading: IconButton(
//                                   onPressed: () {
//                                     suma = suma -
//                                         (produCalcu[i].canti *
//                                             produCalcu[i].pric);
//                                     produCalcu.removeAt(i);
//                                     setState(() {});
//                                   },
//                                   icon: Icon(Icons.delete)),
//                               isThreeLine: true,
//                             )),
//                             IconButton(
//                                 onPressed: () {
//                                   suma += produCalcu[i].pric;
//                                   produCalcu[i].canti += 1;
//                                   setState(() {});
//                                 },
//                                 icon: Icon(Icons.plus_one_outlined)),
//                             IconButton(
//                                 onPressed: () {
//                                   suma -= produCalcu[i].pric;
//                                   roundDouble(suma, 3);
//                                   produCalcu[i].canti -= 1;
//                                   if (produCalcu[i].canti == 0) {
//                                     produCalcu.removeAt(i);
//                                   }
//                                   setState(() {});
//                                 },
//                                 icon: Icon(Icons.exposure_minus_1_outlined))
//                           ],
//                         ),
//                       ],
//                     ),
//                   );
//                 })));
//   }