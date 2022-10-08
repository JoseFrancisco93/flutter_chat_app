import 'package:flutter/material.dart';
import 'package:flutter_chat_app/screens/home_screen.dart';
import 'package:flutter_chat_app/screens/signin_screen.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class Wrapper extends StatefulWidget {
  static String routeName = "/wrapper";
  const Wrapper({Key? key}) : super(key: key);

  @override
  State<Wrapper> createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  
  /////////////////////////////////////
  /////////// Wrapper /////////////////
  /////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<auth.User?>(context);
    
    if (user == null) {
      return const SignInScreen();
    } else {
      return const HomeScreen();
    }
  }
}