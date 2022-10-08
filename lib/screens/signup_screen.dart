import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_chat_app/components/loading.dart';
import 'package:flutter_chat_app/components/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_chat_app/services/auth_services.dart';
import 'package:flutter_chat_app/services/create_user_services.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import '../helpers/keyboard.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Key to Form
  final formKey = GlobalKey<FormState>();
  // Auth Service
  AuthService authService = AuthService();

  /////////////////////////////////////
  ////////////// Lists ////////////////
  /////////////////////////////////////
  // Error List
  final List<String> errors = [];

  /////////////////////////////////////
  /////////////// BOOL ////////////////
  /////////////////////////////////////
  bool _showPassword = false;
  bool _loading = false;

  /////////////////////////////////////
  ///////////////// VAR ///////////////
  /////////////////////////////////////
  String userMail = "";
  String password = "";
  String fullName = "";
  int? userAge;

  /////////////////////////////////////
  ///////////// FUNCTIONS /////////////
  /////////////////////////////////////
  // Function Add Error to form
  void addError({required String error}) {
    if (!errors.contains(error)) {
      setState(() {
        errors.add(error);
      });
    }
  }

  // Function Remove Error to form
  void removeError({required String error}) {
    if (errors.contains(error)) {
      setState(() {
        errors.remove(error);
      });
    }
  }

  // Function show! password
  void _togglevisibility() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  /////////////////////////////////////
  //////////////// UI /////////////////
  /////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: secondaryColor,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: defaultPadding * 2,
              horizontal: defaultPadding,
            ),
            child: Form(
              key: formKey,
              child: ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 50, maxWidth: 450),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'REGISTRO DE USUARIOS',
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: secondaryColor,
                          ),
                    ),
                    const Separator(),
                    Image.asset(
                      'assets/images/signUp.png',
                      height: 100,
                    ),
                    const Separator(),
                    const Separator(),
                    fullNameTextField(),
                    const Separator(),
                    ageTextField(),
                    const Separator(),
                    emailTextField(),
                    const Separator(),
                    passTextField(),
                    const Separator(),
                    FormError(errors: errors),
                    SizedBox(
                      width: double.infinity,
                      child: _loading
                          ? const Loading()
                          : ElevatedButton(
                              style: buttonStyle,
                              onPressed: () {
                                register();
                              },
                              child: const Text(
                                'Registrarse',
                              ),
                            ),
                    ),
                    const Separator(),
                    AlreadyHaveAnAccountCheck(
                      login: false,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          backScreen(context);
                        },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /////////////////////////////////////
  ////// Text Field Full Name /////////
  /////////////////////////////////////
  TextFormField fullNameTextField() {
    return TextFormField(
      textCapitalization: TextCapitalization.words,
      cursorColor: secondaryColor,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.name,
      onSaved: (newValue) => fullName = newValue!,
      onChanged: (value) {
        if (value.length >= 4) {
          removeError(error: shortnameError);
        } else if (value.isNotEmpty) {
          removeError(error: nameNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: nameNullError);
          return "";
        } else if (value.length < 4) {
          addError(error: shortnameError);
          return "";
        }
        return null;
      },
      decoration: formFieldinputDecoration.copyWith(
        labelText: "Nombre Completo",
        hintText: "Ingrese su nombre completo",
        prefixIcon: const Icon(
          Icons.person_outlined,
          color: secondaryColor,
        ),
      ),
    );
  }

  /////////////////////////////////////
  //////// Text Field Age /////////////
  /////////////////////////////////////
  TextFormField ageTextField() {
    return TextFormField(
      cursorColor: secondaryColor,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.deny(RegExp('[\\-|\\ |\\,]')),
        FilteringTextInputFormatter.digitsOnly,
        FilteringTextInputFormatter.deny('  '),
      ],
      onSaved: (newValue) => userAge = int.parse(newValue!),
      onChanged: (value) {
        if (value.isNotEmpty) {
          removeError(error: shortageError);
        } else if (value.isNotEmpty) {
          removeError(error: ageNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: ageNullError);
          return "";
        } else if (value.isEmpty) {
          addError(error: shortageError);
          return "";
        }
        return null;
      },
      decoration: formFieldinputDecoration.copyWith(
        labelText: "Edad",
        hintText: "Ingrese su edad",
        prefixIcon: const Icon(
          Icons.event_available_outlined,
          color: secondaryColor,
        ),
      ),
    );
  }

  /////////////////////////////////////
  //////// Text Field Email ///////////
  /////////////////////////////////////
  TextFormField emailTextField() {
    return TextFormField(
      cursorColor: secondaryColor,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => userMail = newValue!,
      onChanged: (value) {
        if (emailValidatorRegExp.hasMatch(value)) {
          removeError(error: invalidEmailError);
        } else if (value.isNotEmpty) {
          removeError(error: emailNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: emailNullError);
          return "";
        } else if (!emailValidatorRegExp.hasMatch(value)) {
          addError(error: invalidEmailError);
          return "";
        }
        return null;
      },
      decoration: formFieldinputDecoration.copyWith(
        labelText: "Correo electrónico",
        hintText: "Ingrese su correo electrónico",
        prefixIcon: const Icon(
          Icons.email_outlined,
          color: secondaryColor,
        ),
      ),
    );
  }

  /////////////////////////////////////
  ///////// Text Field Pass ///////////
  /////////////////////////////////////
  TextFormField passTextField() {
    return TextFormField(
      cursorColor: secondaryColor,
      textInputAction: TextInputAction.next,
      obscureText: !_showPassword,
      onSaved: (newValue) => password = newValue!,
      onChanged: (value) {
        if (value.length >= 8) {
          removeError(error: shortPassError);
        } else if (value.isNotEmpty) {
          removeError(error: passNullError);
        }
        return;
      },
      validator: (value) {
        if (value!.isEmpty) {
          addError(error: passNullError);
          return "";
        } else if (value.length < 8) {
          addError(error: shortPassError);
          return "";
        }
        return null;
      },
      decoration: formFieldinputDecoration.copyWith(
        labelText: "Contraseña",
        hintText: "Ingrese una contraseña ",
        prefixIcon: const Icon(
          Icons.lock_outlined,
          color: secondaryColor,
        ),
        suffixIcon: GestureDetector(
          onTap: () {
            _togglevisibility();
          },
          child: Icon(
            _showPassword ? Icons.visibility : Icons.visibility_off,
            color: secondaryColor,
          ),
        ),
      ),
    );
  }

  /////////////////////////////////////
  //////// Function Register //////////
  /////////////////////////////////////
  register() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      KeyboardUtil.hideKeyboard(context);

      // Loading State in Button
      setState(() => _loading = true);

      // Sign Up Services
      await authService
          .signUpUserWithEmailAndPass(userMail, password, fullName)
          .then((value) {
        if (value == true) {
          final user = Provider.of<auth.User?>(context, listen: false);
          if (user != null) {
            ServicesDBpost.adduser(user.uid, fullName, userAge!, userMail)
                .then((value) {
              if (value == 'success') {
                showSnackBar(
                    context, secondaryColor, '¡Usuario registrado con exito!');
                // Loading State in Button
                setState(() {
                  _loading = false;
                });
                //Go to Sign In Screen
                backScreen(context);
              }
            });
          } else {
            showSnackBar(
                context, Colors.redAccent, 'Error al Registrar usuario');
            // Loading State in Button
            setState(() {
              _loading = false;
            });
          }
        } else {
          // Errors in Sign Up
          switch (value) {
            case 'email-already-in-use':
              {
                showSnackBar(context, Colors.red,
                    'Ya existe una cuenta creada con este correo electrónico');
                // Loading State in Button
                setState(() {
                  _loading = false;
                });
              }
              break;
            default:
              {
                showSnackBar(
                    context, Colors.redAccent, 'Error al Registrar usuario');
                // Loading State in Button
                setState(() {
                  _loading = false;
                });
              }
              break;
          }
        }
      });
    }
  }
}
