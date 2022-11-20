import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modalcrud/main.dart';
import 'package:modalcrud/services/authentication_services/auth_services.dart';
import 'package:provider/provider.dart';

class emailVerifyPage extends StatefulWidget {
  emailVerifyPage({Key? key}) : super(key: key);

  @override
  _emailVerifyPageState createState() => _emailVerifyPageState();
}

class _emailVerifyPageState extends State<emailVerifyPage> {
  User? userpresent = FirebaseAuth.instance.currentUser;
  
  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthServices>(context);
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFF114B5F), Color(0xFF88d498)],
              begin: FractionalOffset(0.0, 0.5),
              end: FractionalOffset(0.0, 1.0))),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Verifica tu correo electrónico y vuelve a ingresar",style: TextStyle(color: Color(0xFFf3e9d2)),),
            SizedBox(
              height: 20.0,
            ),
            IconButton(
                onPressed: () async{
                   await loginProvider.logout();
                },
                icon: Icon(Icons.exit_to_app,color: Colors.white,))
          ],
        )),
      ),
    );
  }
}
