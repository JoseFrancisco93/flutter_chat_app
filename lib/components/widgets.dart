import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/constants.dart';

/////////////////////////////////////
////////////// Routes ///////////////
/////////////////////////////////////
void nextScreen(context, screen) {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => screen),
  );
}

void backScreen(context) {
  Navigator.pop(context);
}

/////////////////////////////////////
/////////// FormFields //////////////
/////////////////////////////////////
// Button Style
final buttonStyle = ButtonStyle(
  backgroundColor: MaterialStateProperty.all(secondaryColor),
  textStyle: MaterialStateProperty.all(
    const TextStyle(fontSize: 18),
  ),
  foregroundColor: MaterialStateProperty.all(Colors.white),
  padding: MaterialStateProperty.all(const EdgeInsets.symmetric(vertical: 16)),
  shape: MaterialStateProperty.all(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(defaultPadding * 2),
    ),
  ),
);
// Form Fields Decoration
final formFieldinputDecoration = InputDecoration(
  errorStyle: const TextStyle(
    height: 0.1,
    fontSize: 1,
  ),
  labelStyle: const TextStyle(
    color: Colors.black,
  ),
  hintStyle: const TextStyle(
    color: Colors.grey,
  ),
  focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(defaultPadding * 2),
      borderSide: const BorderSide(
        color: secondaryColor,
        width: 2,
      )),
  enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(defaultPadding * 2),
      borderSide: const BorderSide(
        color: secondaryColor,
        width: 2,
      )),
  errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(defaultPadding * 2),
      borderSide: const BorderSide(
        color: errorColor,
        width: 2,
      )),
);

// Form Error to Form Fields
class FormError extends StatelessWidget {
  const FormError({
    Key? key,
    required this.errors,
  }) : super(key: key);

  final List<String> errors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          errors.length, (index) => formErrorText(error: errors[index])),
    );
  }

  Padding formErrorText({required String error}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: defaultPadding / 2,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.error,
            color: errorColor,
          ),
          Expanded(
            child: Text(
              error,
              style: const TextStyle(
                color: errorColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//Separator Form Fields
class Separator extends StatelessWidget {
  const Separator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      height: defaultPadding,
    );
  }
}

// Already have a account Check
class AlreadyHaveAnAccountCheck extends StatelessWidget {
  final bool login;
  final GestureRecognizer recognizer;
  const AlreadyHaveAnAccountCheck({
    Key? key,
    this.login = true,
    required this.recognizer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Text.rich(
            TextSpan(
              text: login ? "¿No tienes una cuenta?" : "¿Ya tienes una cuenta?",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: login ? " Registrarse" : " Ingresar",
                  style: const TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                  recognizer: recognizer,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/////////////////////////////////////
////////// Snack Message ////////////
/////////////////////////////////////
// Snack Bar
void showSnackBar(context, color, message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(
      message,
      style: const TextStyle(
        fontSize: 14,
      ),
    ),
    backgroundColor: color,
    duration: const Duration(seconds: 2),
    action: SnackBarAction(
      label: 'Listo',
      onPressed: () {},
      textColor: Colors.white,
    ),
  ));
}

/////////////////////////////////////
////////////// Chats ////////////////
/////////////////////////////////////
// ChatListItem
class ChatListItem extends StatelessWidget {
  final String fullname;
  final Function()? onTap;
  const ChatListItem({Key? key, required this.onTap, required this.fullname})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        vertical: defaultPadding / 3,
        horizontal: defaultPadding / 2,
      ),
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: secondaryColor,
        foregroundColor: primaryColor,
        child: Text(
          fullname[0].toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        fullname,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      ),
    );
  }
}

// ConversationListItem
class ConversationListItem extends StatelessWidget {
  final String fullname;
  final String message;
  final String time;
  final Function()? onTap;
  const ConversationListItem(
      {Key? key,
      required this.onTap,
      required this.fullname,
      required this.message,
      required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: CircleAvatar(
        radius: 25,
        backgroundColor: secondaryColor,
        foregroundColor: primaryColor,
        child: Text(
          fullname[0].toUpperCase(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            fullname,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          Text(
            time,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
      subtitle: Text(
        message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
