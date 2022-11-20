import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
final firebase = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String email = FirebaseAuth.instance.currentUser!.email.toString();
  User? user = FirebaseAuth.instance.currentUser;
  create(String name,TextEditingController _controlQr,
  TextEditingController _controlName,
  TextEditingController _controlPrice
   ) async {
    List<String> splitList = name.split(" ");
    List<String> indexList = [];

    for (int i = 0; i < splitList.length; i++) {
      for (int y = 1; y < splitList[i].length + 1; y++) {
        indexList.add(splitList[i].substring(0, y).toLowerCase());
      }
    }

    try {
      await firebase.collection(uid).doc(_controlQr.text).set({
        "Nombre": _controlName.text,
        "Precio": _controlPrice.text,
        "CodigoQr": _controlQr.text,
        'searchIndex': indexList
      });
    } catch (e) {
      print(e);
    }
  }

  update(String qr,TextEditingController _controlName,
  TextEditingController _controlPrice) async {
    try {
      firebase
          .collection(uid)
          .doc(qr)
          .update({"Nombre": _controlName.text, "Precio": _controlPrice.text});
    } catch (e) {
      print(e);
    }
  }

  delete(String qr) async {
    try {
      firebase.collection(uid).doc(qr).delete();
    } catch (e) {
      print(e);
    }
  }