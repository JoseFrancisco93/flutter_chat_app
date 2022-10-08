import 'package:flutter/material.dart';
import 'package:flutter_chat_app/components/widgets.dart';
import 'package:flutter_chat_app/constants.dart';
import 'package:flutter_chat_app/screens/wrapper.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = "/splash";
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    load();
    super.initState();
  }

  // Loading Splash - 1.5 seconds
  load() {
    Future.delayed(const Duration(milliseconds: 1500), () {
      Navigator.of(context).pushReplacementNamed(Wrapper.routeName);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  /////////////////////////////////////
  //////////////// UI /////////////////
  /////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/logo.png',
              height: 200,
            ),
            const Separator(),
            const SizedBox(
              height: 20.0,
              width: 20.0,
              child: CircularProgressIndicator(
                color: primaryColor,
                strokeWidth: 1.0,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
