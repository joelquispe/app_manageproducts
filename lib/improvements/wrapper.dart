
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modalcrud/main.dart';
import 'package:modalcrud/pages/Authentication.dart';
import 'package:modalcrud/pages/pageVerifyemail.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  @override
  Widget build(BuildContext context) {
    
    User? userpresent = FirebaseAuth.instance.currentUser;
    final user = Provider.of<User?>(context);
    if (user != null) {
      return userpresent!.emailVerified ? Home():emailVerifyPage() ;
    }else{
      return Authentication();
    }
  }
}
