import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modalcrud/services/authentication_services/auth_services.dart';
import 'package:provider/provider.dart';

class Pagesendverifyemail extends StatefulWidget {
  Pagesendverifyemail({Key? key}) : super(key: key);

  @override
  _PagesendverifyemailState createState() => _PagesendverifyemailState();
}

class _PagesendverifyemailState extends State<Pagesendverifyemail> {
  final k = GlobalKey<FormState>();
  TextEditingController _emailController = TextEditingController(text: "");
  TextEditingController _passwordController = TextEditingController(text: "");
  bool passwordeye = true;
  final FirebaseAuth _firebaseauth = FirebaseAuth.instance;
  User? userconf = FirebaseAuth.instance.currentUser;
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
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Form(
                key: k,
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
                      child: Text("Reenviar correo de verificación",
                          style: TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFf3e9d2))),
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    TextFormField(
                      controller: _emailController,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.black),
                      validator: (val) => val!.isNotEmpty
                          ? null
                          : "Ingrese su correo electronico",
                      decoration: InputDecoration(
                          hintText: "Correo electrónico:",
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      cursorColor: Colors.white,
                      style: TextStyle(color: Colors.black),
                      obscureText: passwordeye ? true : false,
                      validator: (val) =>
                          val!.isNotEmpty ? null : "Ingrese su contraseña",
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                              onPressed: () {
                                passwordeye = !passwordeye;
                                setState(() {});
                              },
                              icon: Icon(
                                Icons.remove_red_eye,
                                color: passwordeye ? Colors.black : Colors.blue,
                              )),
                          hintText: "Contraseña:",
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder()),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    SizedBox(
                      height: 40.0,
                    ),
                    Center(
                      child: ElevatedButton(
                          onPressed: () async {
                            if (k.currentState!.validate()) {
                              try{
                                loginProvider.login(_emailController.text.trim(),
                                  _passwordController.text.trim(), context);
                                  setState(() {
                                    
                                  });
                              }catch(e){
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error al enviar")));
                              }
                              
                            }

                            if (userconf!.emailVerified == false) {
                              
                              print("mierda");
                            }
                          },
                          child: Text(
                            "Enviar",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: Color(0xFF88d498))),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  final snackbar = SnackBar(
    content: Text("Correo electronico no registrado, no se pudo enviar"),
  );
}
