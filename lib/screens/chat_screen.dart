import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/constants.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter_chat_app/helpers/keyboard.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String nameReciever;
  final String nameSender;
  final String idReciever;

  const ChatScreen(
      {Key? key,
      required this.chatId,
      required this.nameReciever,
      required this.nameSender,
      required this.idReciever})
      : super(
          key: key,
        );

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // Firebase Service
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  /////////////////////////////////////
  ///////// TextContoller /////////////
  /////////////////////////////////////
  final TextEditingController message = TextEditingController();

  /////////////////////////////////////
  /////////////// BOOL ////////////////
  /////////////////////////////////////
  bool emojiShowing = false;

  // Dispose
  @override
  void dispose() {
    message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<auth.User?>(context, listen: false);
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: const EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: secondaryColor,
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                CircleAvatar(
                  backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                  backgroundImage: const AssetImage("assets/images/signIn.png"),
                  maxRadius: 20,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.nameReciever,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(
                        height: 6,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Center(
        child: Container( 
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg-chat.png"),
              fit: BoxFit.cover,
            ),
          ),        
          constraints: const BoxConstraints(minWidth: 50, maxWidth: 450),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: firestore
                      .collection('chatRoom')
                      .doc(widget.chatId)
                      .collection('chats')
                      .orderBy("timeSystem", descending: true)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.data != null) {
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        reverse: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          Map<String, dynamic> map = snapshot.data!.docs[index]
                              .data() as Map<String, dynamic>;
                          return messageBubble(size, map, user!.uid);
                        },
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: defaultPadding,
                  vertical: defaultPadding / 2,
                ),
                margin: const EdgeInsets.only(
                  bottom: defaultPadding / 2,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    defaultPadding,
                  ),
                  color: Colors.white,
                ),
                height: 60,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (!kIsWeb)
                    IconButton(
                      icon: const Icon(
                        Icons.emoji_emotions,
                        color: secondaryColor,
                      ),
                      onPressed: () {
                        setState(() {
                          emojiShowing = !emojiShowing;
                        });
                        KeyboardUtil.hideKeyboard(context);
                      },
                    ),
                    Flexible(
                      child: TextField(
                        controller: message,
                        onTap: () {
                          setState(() {
                            emojiShowing = false;
                          });
                        },
                        decoration: const InputDecoration(
                            hintText: "Escribe un mensaje aquí",
                            hintStyle: TextStyle(color: Colors.black54),
                            border: InputBorder.none),
                      ),
                    ),
                    FloatingActionButton(
                      tooltip: 'Enviar mensaje',
                      backgroundColor: secondaryColor,
                      elevation: 0,
                      hoverElevation: 10,
                      onPressed: () {
                        onSendMessage();
                        message.clear();
                      },
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ],
                ),
              ),
              if (!kIsWeb)
              Offstage(
                offstage: !emojiShowing,
                child: SizedBox(
                  height: 250,
                  child: EmojiPicker(
                    textEditingController: message,
                    config: const Config(
                      columns: 7,
                      emojiSizeMax: 32 * 1.0,
                      verticalSpacing: 0,
                      horizontalSpacing: 0,
                      gridPadding: EdgeInsets.zero,
                      bgColor: Color(0xFFF2F2F2),
                      indicatorColor: Colors.blue,
                      iconColor: Colors.grey,
                      iconColorSelected: Colors.blue,
                      backspaceColor: Colors.blue,
                      skinToneDialogBgColor: Colors.white,
                      skinToneIndicatorColor: Colors.grey,
                      enableSkinTones: true,
                      showRecentsTab: true,
                      recentsLimit: 28,
                      replaceEmojiOnLimitExceed: false,
                      noRecents: Text(
                        'No hay recientes',
                        style: TextStyle(fontSize: 20, color: Colors.black26),
                        textAlign: TextAlign.center,
                      ),
                      loadingIndicator: SizedBox.shrink(),
                      tabIndicatorAnimDuration: kTabScrollDuration,
                      categoryIcons: CategoryIcons(),
                      buttonMode: ButtonMode.MATERIAL,
                      checkPlatformCompatibility: true,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  /////////////////////////////////////
  ////////// Message Bubble ///////////
  /////////////////////////////////////
  Widget messageBubble(Size size, Map<String, dynamic> map, String userId) {
    //Format Time Message
    var time = DateTime.fromMillisecondsSinceEpoch(map['time']);
    var hora = DateFormat('hh:mm a').format(time);

    return Container(
      alignment: map['idSender'] == userId
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        constraints: const BoxConstraints(minWidth: 50, maxWidth: 250),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(defaultPadding),
          color: map['idSender'] == userId ? secondaryColor : ksecondaryColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: map['idSender'] == userId
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            Text(
              map['message'],
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color:
                    map['idSender'] == userId ? Colors.white : Colors.black87,
              ),
            ),
            Text(
              hora.toString(),
              textAlign: TextAlign.end,
              style: TextStyle(
                fontSize: 11,
                color:
                    map['idSender'] == userId ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /////////////////////////////////////
  /////// Function Send Message ///////
  /////////////////////////////////////
  onSendMessage() async {
    final user = Provider.of<auth.User?>(context, listen: false);
    var contentMessage = message.text;

    if (message.text.isNotEmpty) {
      Map<String, dynamic> dataMessage = {
        "idSender": user!.uid,
        "message": contentMessage,
        "time": DateTime.now().millisecondsSinceEpoch,
        "timeSystem": FieldValue.serverTimestamp(),
        "idReceiver": widget.idReciever,
      };
      await firestore
          .collection('chatRoom')
          .doc(widget.chatId)
          .collection('chats')
          .add(dataMessage)
          .then(
        (value) {
          firestore
              .collection('users')
              .doc(user.uid)
              .collection('chats')
              .doc(widget.chatId)
              .set(
            {
              "fullName": widget.nameReciever,
              "idReciever": widget.idReciever,
              "message": contentMessage,
              "time": DateTime.now().millisecondsSinceEpoch,
            },
          );
          firestore
              .collection('users')
              .doc(widget.idReciever)
              .collection('chats')
              .doc(widget.chatId)
              .set(
            {
              "fullName": widget.nameSender,
              "idReciever": user.uid,
              "message": contentMessage,
              "time": DateTime.now().millisecondsSinceEpoch,
            },
          );
        },
      );
    }
  }
}
