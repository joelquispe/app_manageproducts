import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordPage extends StatefulWidget {
  ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final k = GlobalKey<FormState>();
  TextEditingController _emailforgotpassword = TextEditingController(text: "");
  final FirebaseAuth _firebaseauth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFF114B5F), Color(0xFF88d498)],
              begin: FractionalOffset(0.0, 0.5),
              end: FractionalOffset(0.0, 1.0))),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    )),
                SizedBox(height: 150),
                Center(
                  child: Text("Recuperar contraseña",
                      style: TextStyle(
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFf3e9d2))),
                ),
                SizedBox(
                  height: 40.0,
                ),
                TextFormField(
                  controller: _emailforgotpassword,
                  cursorColor: Colors.white,
                  style: TextStyle(color: Colors.black),
                  validator: (val) =>
                      val!.isNotEmpty ? null : "Ingrese su correo electrónico",
                  key: k,
                  decoration: InputDecoration(
                      hintText: "Correo electrónico:",
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10.0, left: 10.0),
                    child: Text(
                      "Se le enviará un correo para realizar la recuperación de su cuenta",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Center(
                  child: ElevatedButton(
                      onPressed: () async {
                        resetPassword();
                      },
                      child: Text(
                        "Enviar",
                        style: TextStyle(color: Colors.white),
                      ),
                      style:
                          ElevatedButton.styleFrom(primary: Color(0xFF88d498))),
                ),
                SizedBox(height: 150),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final snackbar = SnackBar(
    content: Text("Correo electronico no registrado, no se puedo enviar"),
  );
  resetPassword() async {
    String email = _emailforgotpassword.text.toString();
    try {
      await _firebaseauth.sendPasswordResetEmail(email: email);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
    }
  }
}
