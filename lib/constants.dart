import 'package:flutter/material.dart';

// Constants to web app Firebase configuration
class Constants {
  static String apiKey = "AIzaSyDeOL_IjIr5A9KOW5GGgT6tPCBiFXYopbs";
  static String appId = "1:333476883772:web:c7921906cea8cae0c80239";
  static String messagingSenderId = "333476883772";
  static String projectId = "chatapp-8ad25";
}

// Constants
const primaryColor = Color(0xFF00DEDB);
const secondaryColor = Color(0xFF6B75DF);
const ksecondaryColor = Color.fromARGB(255, 235, 237, 255);
const errorColor = Color.fromARGB(255, 189, 13, 0);
const defaultPadding = 16.0;

// Constants to Error input in Text Fields
final RegExp emailValidatorRegExp =
    RegExp(r"^[a-zA-Z0-9._]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
const String emailNullError = "Por favor, ingresa el correo electrónico";
const String invalidEmailError = "Correo electrónico inválido";
const String passNullError = "Por favor, ingresa la contraseña";
const String shortPassError = "Contraseña muy corta (Debe contener más de 7 caracteres)";
const String nameNullError = "Por favor, ingrese su nombre";
const String shortnameError = "Ingrese su nombre completo";
const String ageNullError = "Por favor, ingrese su edad";
const String shortageError = "Ingrese su edad";
const String emptyFields = "Por favor, complete todos los campos";