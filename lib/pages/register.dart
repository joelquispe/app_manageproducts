import 'package:flutter/material.dart';

import 'package:modalcrud/pages/pageresendverifyemail.dart';
import 'package:modalcrud/services/authentication_services/auth_services.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  final Function toggleScreen;
  const Register({Key? key, required this.toggleScreen}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  final _formkey = GlobalKey<FormState>();
  bool passwordeye = true;
  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginprovider = Provider.of<AuthServices>(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('assets/bodegacharalla.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.7), BlendMode.darken))),
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 250,
                      child: Center(
                        child: Column(
                          children: [
                            Container(
                              height: 250,
                              width: 300,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image:
                                          AssetImage('assets/logo.png'),
                                      fit: BoxFit.cover)),
                            )
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 90.0,
                    ),
                    TextFormField(
                      controller: _emailController,
                      style: TextStyle(color: Colors.white),
                      validator: (val) => val!.isNotEmpty
                          ? null
                          : "Ingresar un correo electrónico",
                      decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.person_sharp,
                            color: Colors.white,
                          ),
                          hintText: "Correo electrónico",
                          hintStyle: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      style: TextStyle(color: Colors.white),
                      validator: (val) => val!.length < 6
                          ? "Ingresar mas de 6 carácteres"
                          : null,
                      obscureText: passwordeye ? true : false,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(onPressed: (){
                            passwordeye = !passwordeye;
                            setState(() {
                              
                            });
                          }, icon: Icon(Icons.remove_red_eye,color:passwordeye ? Colors.white: Colors.blue ,)),
                          prefixIcon: Icon(Icons.vpn_key, color: Colors.white),
                          hintText: "Contraseña",
                          hintStyle: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        Text(
                          "¿No te llegó el email de verificación?",
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          width: 10.0,
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => Pagesendverifyemail()));
                            },
                            child: Text(
                              "Reenviar",
                              style: TextStyle(color: Color(0xFF88d498)),
                            ))
                      ],
                    ),
                    MaterialButton(
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          print("email: ${_emailController.text}");
                          print("email: ${_passwordController.text}");
                          await loginprovider.register(
                              _emailController.text.trim(),
                              _passwordController.text.trim(),
                              context);
                        }
                      },
                      height: 70,
                      minWidth:
                          loginprovider.isLoading ? null : double.infinity,
                      color: Color(0xFF114b5f),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: loginprovider.isLoading
                          ? CircularProgressIndicator()
                          : Text(
                              "Registrarse",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "¿Ya estás registrado?",
                          style: TextStyle(color: Color(0xFF114b5f)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        TextButton(
                            style: TextButton.styleFrom(
                                primary: Color(0xFF114b5f)),
                            onPressed: () {
                              widget.toggleScreen();
                            },
                            child: Text(
                              "Ingresar",
                              style: TextStyle(color: Color(0xFF88d498)),
                            )),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
