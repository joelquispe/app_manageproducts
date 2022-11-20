
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modalcrud/pages/Pageforgotpassword.dart';
import 'package:modalcrud/services/authentication_services/auth_services.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  static final String route = "login";
  final Function? toggleScreen;
  const Login({Key? key, this.toggleScreen}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
    final loginProvider = Provider.of<AuthServices>(context);
    bool verify = true;
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
                      height: 320,
                      child: Center(
                        child: Column(
                          children: [
                            Text("MITIENDITA",style: GoogleFonts.oswald(color: Colors.red,fontSize: 45.0,fontWeight:FontWeight.bold,))
                            ,
                            Container(
                              height: 250,
                              width: 320,
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
                    SizedBox(height: 20.0,),
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
                        hintText: "Correo electronico",
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    
                    TextFormField(
                      controller: _passwordController,
                      style: TextStyle(color: Colors.white),
                      
                      validator: (val) => val!.length < 6
                          ? "Ingrese mas de 6 carácteres"
                          : null,
                      obscureText: passwordeye ? true : false,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(onPressed: (){
                          passwordeye = !passwordeye;
                          setState(() {
                              
                            });
                        }, icon: Icon(Icons.remove_red_eye,color:passwordeye ? Colors.white: Colors.blue ,)),
                        prefixIcon: Icon(
                          Icons.vpn_key,
                          color: Colors.white,
                        ),
                        hintText: "Contraseña",
                        fillColor: Colors.red,
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => ForgotPasswordPage()));
                            },
                            child: Text(
                              "Olvidé mi contraseña",
                              style: TextStyle(color: Color(0xFF88d498)),
                            ))
                      ],
                    ),
                    MaterialButton(
                      onPressed: () async {
                        if (_formkey.currentState!.validate()) {
                          loginProvider.login(_emailController.text.trim(),
                              _passwordController.text.trim(), context);
                        }
                      },
                      height: 70,
                      minWidth:
                          loginProvider.isLoading ? null : double.infinity,
                      color: Color(0xFF114b5f),
                      textColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: loginProvider.isLoading
                          ? CircularProgressIndicator()
                          : Text(
                              "Ingresar",
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
                          "¿No estas registrado?",
                          style: TextStyle(color: Color(0xFF114b5f)),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        TextButton(
                            style: TextButton.styleFrom(
                                primary: Color(0xFF114b5f)),
                            onPressed: () {
                              widget.toggleScreen!();
                            },
                            child: Text(
                              "Registrarse",
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
