import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  final String codeqr;
  final String name;
  final String price;
  late DocumentReference reference;

  Product({required this.codeqr, required this.name, required this.price});

  

  Product.fromMap(Map<String, dynamic> map, {required this.reference})
      : codeqr = map['codeqr'],
        name = map['name'],
        price = map['price'];

  Map<String, dynamic> toJson() {
    return {'codeqr': codeqr, 'name': name, 'price': price};
  }
}
