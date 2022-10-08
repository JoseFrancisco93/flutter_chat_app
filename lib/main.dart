import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_chat_app/constants.dart';
import 'package:flutter_chat_app/provider/provider_notify.dart';
import 'package:flutter_chat_app/routs.dart';
import 'package:flutter_chat_app/screens/splash_screen.dart';
import 'package:flutter_chat_app/services/auth_services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Condition to App Mobile or Web
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
      apiKey: Constants.apiKey,
      appId: Constants.appId,
      messagingSenderId: Constants.messagingSenderId,
      projectId: Constants.projectId,
    ));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<auth.User?>.value(
          value: AuthService().authState,
          initialData: null,
        ),
        ChangeNotifierProvider(create: (context) => Globals()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.routeName,
        routes: routes,
      ),
    );
  }
}
