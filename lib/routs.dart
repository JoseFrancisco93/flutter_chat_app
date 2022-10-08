import 'package:flutter/material.dart';
import 'package:flutter_chat_app/screens/splash_screen.dart';
import 'package:flutter_chat_app/screens/wrapper.dart';

/////////////////////////////////////
/////////////// Routs ///////////////
/////////////////////////////////////
final Map<String, WidgetBuilder> routes = {
  SplashScreen.routeName: (context) => const SplashScreen(),
  Wrapper.routeName: (context) => const Wrapper(),
};
