import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modalcrud/busqueda.dart';
import 'package:modalcrud/busquedaCalcu.dart';
import 'package:modalcrud/improvements/wrapper.dart';
import 'package:modalcrud/models/claselistacalcu.dart';
import 'package:modalcrud/pages/login.dart';
import 'package:modalcrud/pages/pageCalculo.dart';
import 'package:modalcrud/services/authentication_services/auth_services.dart';
import 'package:modalcrud/widgets/alerts.dart';
import 'package:provider/provider.dart';
import 'package:modalcrud/widgets/drawer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _init = Firebase.initializeApp();
    return FutureBuilder(
        future: _init,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorWidget();
          } else if (snapshot.hasData) {
            return MultiProvider(
              providers: [
                ChangeNotifierProvider<AuthServices>.value(
                    value: AuthServices()),
                StreamProvider<User?>.value(
                  value: AuthServices().user,
                  initialData: null,
                )
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                home: Wrapper(),
                theme: ThemeData(textTheme: GoogleFonts.montserratTextTheme()),
                routes: {
                  CalculoPage.route: (_) => CalculoPage(),
                  BusquedaCalcu.route: (_) => BusquedaCalcu(),
                  Home.route: (_) => Home(),
                  Login.route: (_) => Login()
                },
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}

class Home extends StatefulWidget {
  static final String route = "homepage";
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _controlName = TextEditingController(text: "");
  TextEditingController _controlPrice = TextEditingController(text: "");
  TextEditingController _controlQr = TextEditingController(text: "");
  TextEditingController searchController = TextEditingController(text: "");
  String searchString = "";
  String _entry = "";
  String _value = "";
  bool addDotZero = false;
  void addDot() {
    if (!_controlPrice.text.contains(".")) {
      _controlPrice.text += ".00";
      addDotZero = true;
    }
  }

  void addZero() {
    if (_controlPrice.text
            .substring(
                _controlPrice.text.indexOf(".") + 1, _controlPrice.text.length)
            .length <=
        1) {
      _controlPrice.text += "0";
    }
    print(_controlPrice.text
        .substring(_controlPrice.text.indexOf("."), _controlPrice.text.length)
        .length);
  }

  _scannerBar() async {
    await FlutterBarcodeScanner.scanBarcode(
            "#004297", "Cancel", true, ScanMode.BARCODE)
        .then((value) => setState(() => _controlQr.text = value));

    // if (_entry == "-1") {
    //   print("no se pudo imprimir");
    // } else {
    //   _value = _entry;
    // }
  }

  final firebase = FirebaseFirestore.instance;
  String uid = FirebaseAuth.instance.currentUser!.uid;
  String email = FirebaseAuth.instance.currentUser!.email.toString();
  User? user = FirebaseAuth.instance.currentUser;
  create(String name) async {
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

  update(String qr) async {
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

  void limpiar() {
    _controlName.clear();
    _controlPrice.clear();
    _controlQr.clear();
  }

  verificar() async {
    if (user != null && user!.emailVerified) {
      await user!.sendEmailVerification();
      print("verification email");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.black, content: Text("verification email")));
    }
  }

  String ii = "";
  Future filtroaddd(String code) async {
    setState(() {
      firebase.collection(uid).doc(code).get().then((DocumentSnapshot doc) {
        setState(() {});
        if (doc.get("CodigoQr") == code) {
          ii = doc.get("CodigoQr");
        }
      });
    });
  }

  Future amountTotal() async {
    firebase
        .collection(uid)
        .get()
        .then((value) => amountProducts = value.size.toString());
  }

  @override
  void initState() {
    setState(() {});
    super.initState();
  }

  late QuerySnapshot snapshotData;
  late bool isExcecuted = false;
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
        appBar: AppBar(
          title: Text(
            "Mi Tienda" + amountProducts,
          ),
          backgroundColor: Color(0xFF114b5f),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Busqueda()));
                },
                icon: Icon(Icons.search)),
          ],
        ),
        drawer: drawerMain(context),
        // body: isExcecuted ? searchData() : listarfirebase(),
        body: listarfirebase(),

        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: () {
                print(amountProducts);
                _buttonPressedAdd(context);
              },
              child: Icon(
                Icons.add_circle,
                color: Colors.black,
              ),
              backgroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  void _buttonPressedAdd(context) {
    final _formkey = GlobalKey<FormState>();
    showModalBottomSheet(
        backgroundColor: Color(0xFFf3e9d2),
        enableDrag: false,
        isDismissible: false,
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        "Agregar Producto",
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Helvetica',
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(18.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (val) =>
                            val!.isNotEmpty ? null : "Ingrese un codigo",
                        controller: _controlQr,
                        onChanged: (text) {
                          filtroaddd(_controlQr.text);
                          print(ii);
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Codigo de Barra"),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(18.0),
                      child: TextFormField(
                        validator: (val) =>
                            val!.isNotEmpty ? null : "Ingrese un nombre",
                        controller: _controlName,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: "Nombre de producto"),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(18.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (val) =>
                            val!.isNotEmpty ? null : "Ingrese un precio",
                        controller: _controlPrice,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(), hintText: "Precio"),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF114b5f)),
                              onPressed: () {
                                if (_formkey.currentState!.validate()) {
                                  setState(() {});
                                  if (_controlQr.text == ii) {
                                    showDialog(
                                        context: context,
                                        builder: (_) =>
                                            alerdialogCodeRepeat(context));
                                  } else {
                                    addDot();
                                    addZero();
                                    create(_controlName.text);
                                    Navigator.pop(context);
                                    setState(() {});
                                    clearText();
                                  }
                                }
                              },
                              child: Text("Agregar")),
                          SizedBox(
                            width: 10.0,
                          ),
                          _buttonBack(context),
                          SizedBox(
                            width: 10.0,
                          ),
                          IconButton(
                              onPressed: () {
                                _scannerBar();
                              },
                              icon: Image.asset('assets/barcode.png')),
                          SizedBox(
                            width: 10.0,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _buttonPressedEdit(
      context, int inde, String codeq, String name, String price) {
    showModalBottomSheet(
        backgroundColor: Color(0xFFf3e9d2),
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(18.0),
                    child: Text(
                      "Modificar Producto",
                      style: TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Helvetica',
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(18.0),
                    child: TextFormField(
                      controller: _controlQr,
                      enabled: false,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), hintText: codeq),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(18.0),
                    child: TextFormField(
                      controller: _controlName,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), hintText: name),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(18.0),
                    child: TextFormField(
                      controller: _controlPrice,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), hintText: price),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Color(0xFF114b5f)),
                            onPressed: () {
                              if (_controlName.text == "") {
                                _controlName.text = name;
                              }
                              if (_controlPrice.text == "") {
                                _controlPrice.text = price;
                              }
                              addDot();
                              addZero();
                              update(codeq);
                              Navigator.pop(context);
                              clearText();
                            },
                            child: Text("Guardar")),
                        SizedBox(
                          width: 10.0,
                        ),
                        _buttonBack(context),
                        SizedBox(
                          width: 10.0,
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  // Widget drawerMain() {
  //   return Drawer(
  //     child: Container(
  //       color: Color(0xFFf3e9d2),
  //       height: double.infinity,
  //       child: Column(
  //         children: [
  //           UserAccountsDrawerHeader(
  //             decoration: BoxDecoration(color: Color(0xFF114B5F)),
  //             accountName: Text(email.substring(0, email.indexOf('@'))),
  //             accountEmail: Text(email),
  //             currentAccountPicture: CircleAvatar(
  //               backgroundColor: Color(0xFFf3e9d2),
  //               child: Text(
  //                 email.substring(0, 1),
  //                 style: TextStyle(
  //                     fontSize: 40.0,
  //                     fontWeight: FontWeight.bold,
  //                     color: Color(0xFF114B5F)),
  //               ),
  //             ),
  //           ),
  //           ListTile(
  //             title: Text("Realizar venta"),
  //             leading: Icon(Icons.sell),
  //             selected: seleccaclcu,
  //             onTap: () {
  //               Navigator.pushNamed(context, CalculoPage.route);
  //             },
  //           ),
  //           ListTile(
  //             title: Text("Tutorial"),
  //             leading: Icon(Icons.video_call),
  //             onTap: () {},
  //           )
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget alerdialog(String code) {
    return CupertinoAlertDialog(
      title: Text("Eliminara un producto"),
      content: Text("¿Esta seguro de querer eliminar el producto?"),
      actions: [
        TextButton(
            onPressed: () {
              delete(code);
              Navigator.pop(context);
            },
            child: Text("SI")),
        TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("NO")),
      ],
    );
  }

  Widget _buttonBack(context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Color(0xFF114b5f),
      ),
      onPressed: () {
        clearText();
        Navigator.pop(context);
      },
      child: Text("Cancelar"),
    );
  }

  Widget listarfirebase() {
    return SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: StreamBuilder<QuerySnapshot>(
            stream: firebase.collection(uid).orderBy("Nombre").snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (contex, i) {
                      QueryDocumentSnapshot x = snapshot.data!.docs[i];

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(x["Nombre"]),
                          tileColor: Colors.white,
                          subtitle: Text("S/" +
                              x["Precio"] +
                              "\n" +
                              "Codigo :" +
                              x["CodigoQr"]),
                          isThreeLine: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0)),
                          leading: IconButton(
                              onPressed: () => showDialog(
                                  context: context,
                                  builder: (_) => alerdialog(x["CodigoQr"]),
                                  barrierDismissible: false),
                              icon: Icon(Icons.delete)),
                          trailing: IconButton(
                              onPressed: () {
                                _buttonPressedEdit(
                                  context,
                                  i,
                                  x["CodigoQr"],
                                  x["Nombre"],
                                  x["Precio"],
                                );
                              },
                              icon: Icon(Icons.edit)),
                        ),
                      );
                    });
              } else {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        ));
  }

  void clearText() {
    _controlQr.text = "";
    _controlName.text = "";
    _controlPrice.text = "";
  }
}

class ErrorWidget extends StatelessWidget {
  const ErrorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [Icon(Icons.error), Text("Something went wrong!")],
        ),
      ),
    );
  }
}

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
