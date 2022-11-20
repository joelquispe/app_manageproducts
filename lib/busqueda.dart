import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:modalcrud/improvements/addFeaturesVoids.dart';
import 'package:modalcrud/widgets/editProduct.dart';

class Busqueda extends StatefulWidget {
  Busqueda({Key? key}) : super(key: key);

  @override
  _BusquedaState createState() => _BusquedaState();
}

TextEditingController searchController = TextEditingController(text: "");
String searchString = "";

final firebase = FirebaseFirestore.instance;
String uid = FirebaseAuth.instance.currentUser!.uid;

class _BusquedaState extends State<Busqueda> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Color(0xFFf3e9d2)),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF114b5f),
          leading: IconButton(
              onPressed: () {
                searchController.clear();
                searchString = "";
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
          title: TextField(
            autofocus: true,
            style: TextStyle(color: Colors.white),
            controller: searchController,
            decoration: InputDecoration(),
            onChanged: (value) {
              setState(() {
                searchString = value.toLowerCase();
              });
            },
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: (searchString == null || searchString.trim() == "")
              ? firebase.collection(uid).orderBy("Nombre").snapshots()
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
                        leading: IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (_) => ImproveAlerdialog(
                                      context, te['CodigoQr']));
                            },
                            icon: Icon(Icons.delete)),
                        trailing: IconButton(
                            onPressed: () {
                              buttonPressedEdit(
                                context,
                                index,
                                te['CodigoQr'],
                                te['Nombre'],
                                te['Precio'],
                              );
                            },
                            icon: Icon(Icons.edit)),
                        title: Text(te['Nombre']),
                        subtitle: Text(te['Precio']),
                      );
                    });
            }
          },
        ),
      ),
    );
  }
}
