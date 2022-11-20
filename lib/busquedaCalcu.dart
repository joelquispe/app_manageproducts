import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:modalcrud/models/claseCalculo.dart';
import 'package:modalcrud/models/claselistacalcu.dart';
import 'package:modalcrud/pages/pageCalculo.dart';
import 'package:modalcrud/widgets/alerts.dart';

class BusquedaCalcu extends StatefulWidget {
  static final String route = "busquecalcu";
  BusquedaCalcu({Key? key}) : super(key: key);

  @override
  _BusquedaCalcuState createState() => _BusquedaCalcuState();
}

TextEditingController searchController = TextEditingController(text: "");
String searchString = "";

final firebase = FirebaseFirestore.instance;
String uid = FirebaseAuth.instance.currentUser!.uid;
produadd(String code, String nom, double pric, int canti) {
  produCalcu.add(ProduCalcu(code, nom, pric, canti));
}

bool existsproduct = false;
String filteraddCalcu(String cod) {
  for (ProduCalcu a in produCalcu) {
    if (a.code == cod) {
      return a.code;
    } 
  }
  return "as";
}

class _BusquedaCalcuState extends State<BusquedaCalcu> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color(0xFFf3e9d2)),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                searchController.clear();
                searchString = "";
                Navigator.pushReplacementNamed(context, CalculoPage.route);
              },
              icon: Icon(Icons.arrow_back)),
          backgroundColor: Color(0xFF114b5f),
          title: TextField(
            style: TextStyle(color: Colors.white),
            autofocus: true,
            controller: searchController,
            onChanged: (value) {
              setState(() {
                searchString = value.toLowerCase();
              });
            },
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: (searchString == null || searchString.trim() == "")
              ? firebase.collection(uid).snapshots()
              : firebase
                  .collection(uid)
                  .where('searchIndex', arrayContains: searchString)
                  .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) return Text("erro: ${snapshot.error}");
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      var te = snapshot.data!.docs[index];
                      return ListTile(
                        title: Text(te['Nombre']),
                        subtitle: Text(te['Precio']),
                        trailing: IconButton(
                            onPressed: () {
                              
                              if (filteraddCalcu(te['CodigoQr']) == te['CodigoQr']) {
                                showDialog(
                                    context: context,
                                    builder: (_) =>
                                        alerdialogProductRepeat(context));
                              } else {
                                produadd(te['CodigoQr'], te['Nombre'],
                                    double.parse(te['Precio']), 1);
                                suma += double.parse((te['Precio']));
                                searchString = "";
                                searchController.text = "";
                                setState(() {
                                  Navigator.pushReplacementNamed(
                                      context, CalculoPage.route);
                                });
                              }
                            },
                            icon: Icon(Icons.add_circle)),
                      );
                    });
            }
          },
        ),
      ),
    );
  }
}
