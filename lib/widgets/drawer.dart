import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modalcrud/main.dart';
import 'package:modalcrud/pages/login.dart';
import 'package:modalcrud/pages/pageCalculo.dart';
import 'package:modalcrud/services/authentication_services/auth_services.dart';
import 'package:provider/provider.dart';

String email = FirebaseAuth.instance.currentUser!.email.toString();
bool seleccaclcu = false;
bool selecthome = true;
Widget drawerMain(BuildContext contex) {
  final loginProvider = Provider.of<AuthServices>(contex);
  return Drawer(
    child: Container(
      color: Color(0xFFf3e9d2),
      height: double.infinity,
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: BoxDecoration(color: Color(0xFF114B5F)),
            accountName: Text(email.substring(0, email.indexOf('@'))),
            accountEmail: Text(email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Color(0xFFf3e9d2),
              child: Text(
                email.substring(0, 1),
                style: TextStyle(
                    fontSize: 40.0,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF114B5F)),
              ),
            ),
          ),
          ListTile(
            title: Text("Productos"),
            selectedTileColor: Colors.grey,
            leading: Icon(Icons.list_alt),
            selected: selecthome,
            onTap: () {
              if (!selecthome) {
                Navigator.pushReplacementNamed(contex, Home.route);
              }
              selecthome = true;
              seleccaclcu = false;
            },
          ),
          ListTile(
            title: Text("Realizar venta"),
            leading: Icon(Icons.sell),
            selected: seleccaclcu,
            
            onTap: () {
              if (!seleccaclcu) {
                Navigator.pushReplacementNamed(contex, CalculoPage.route);
              }
              seleccaclcu = true;
              selecthome = false;
            },
          ),
          ListTile(
            title: Text("Cerrar sesió"),
            leading: Icon(Icons.logout),
            
            onTap: () async {
              await loginProvider.logout();
              
              
            },
          ),
          ListTile(
            title: Text("Tutorial"),
            leading: Icon(Icons.video_call),
            onTap: () {
              
            },
          ),
          
        ],
      ),
    ),
  );
}
