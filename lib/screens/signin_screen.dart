import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/components/loading.dart';
import 'package:flutter_chat_app/components/widgets.dart';
import 'package:flutter_chat_app/constants.dart';
import 'package:flutter_chat_app/screens/signup_screen.dart';
import 'package:flutter_chat_app/services/auth_services.dart';
import '../helpers/keyboard.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
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
  String email = "";
  String password = "";

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
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              showDialogWithFields();
            },
            icon: const Icon(
              Icons.help_rounded,
              color: secondaryColor,
            ),
          ),
        ],
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
                      'INICIO DE SESIÓN',
                      style: Theme.of(context).textTheme.headline5!.copyWith(
                            fontWeight: FontWeight.bold,
                            color: secondaryColor,
                          ),
                    ),
                    const Separator(),
                    Image.asset(
                      'assets/images/signIn.png',
                      height: 100,
                    ),
                    const Separator(),
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
                                login();
                              },
                              child: const Text(
                                'Ingresar',
                              ),
                            ),
                    ),
                    const Separator(),
                    AlreadyHaveAnAccountCheck(
                      login: true,
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          nextScreen(context, const SignUpScreen());
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
  TextFormField emailTextField() {
    return TextFormField(
      cursorColor: secondaryColor,
      textInputAction: TextInputAction.next,
      keyboardType: TextInputType.emailAddress,
      onSaved: (newValue) => email = newValue!,
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
  /////// Text Field Password /////////
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
        hintText: "Ingrese su contraseña",
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
  login() async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      KeyboardUtil.hideKeyboard(context);

      // Loading State in Button
      setState(() => _loading = true);

      // Sign Up Services
      await authService
          .signInUserWithEmailAndPass(email, password)
          .then((value) {
        if (value == true) {
          showSnackBar(context, secondaryColor, '¡Inicio de sesión exitoso!');
          // Loading State in Button
          setState(() {
            _loading = false;
          });
        } else {
          // Errors in Sign Up
          switch (value) {
            case 'wrong-password':
              {
                showSnackBar(context, Colors.red, 'Contraseña incorrecta');
                // Loading State in Button
                setState(() {
                  _loading = false;
                });
              }
              break;
            case 'user-not-found':
              {
                showSnackBar(context, Colors.red, 'Usuario no registrado');
                // Loading State in Button
                setState(() {
                  _loading = false;
                });
              }
              break;
            default:
              {
                showSnackBar(context, Colors.redAccent, value);
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

  /////////////////////////////////////
  ////// Function Recovery Pass ///////
  /////////////////////////////////////
  void showDialogWithFields() {
    showDialog(
      context: context,
      builder: (_) {
        var emailController = TextEditingController();
        return AlertDialog(
          title: const Text(
            'Recuperar contraseña',
            style: TextStyle(
              color: secondaryColor,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: emailController,
                decoration: formFieldinputDecoration.copyWith(
                  labelText: "Correo electrónico",
                  hintText: "Ingrese su correo electrónico",
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: secondaryColor,
                  ),
                ),
              ),
              const Separator(),
              const Text(
                  '¡Le seran enviados los pasos para restablecer su contraseña a su correo! Revisar bandeja de Spam')
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancelar',
                style: TextStyle(
                  color: secondaryColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () async {
                await authService.resetPassword(emailController.text).then((value) {
                  Navigator.pop(context);
                });
              },
              child: const Text(
                'Enviar',
                style: TextStyle(
                  color: secondaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
