import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_app/components/widgets.dart';
import 'package:flutter_chat_app/constants.dart';
import 'package:flutter_chat_app/models/user_data.dart';
import 'package:flutter_chat_app/screens/chat_screen.dart';
import 'package:flutter_chat_app/services/auth_services.dart';
import 'package:flutter_chat_app/services/get_user_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Auth Service
  AuthService authService = AuthService();
  // Firebase Service
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  /////////////////////////////////////
  ////////////// Lists ////////////////
  /////////////////////////////////////
  List usersList = [];

  /////////////////////////////////////
  ///////////// Objects ///////////////
  /////////////////////////////////////
  UserData? userData;

  // InitState
  @override
  void initState() {
    loadProfile();
    super.initState();
  }

  /////////////////////////////////////
  ///////////// Functions /////////////
  /////////////////////////////////////
  // Generator ChatRoomId
  String chatRoomId(String user1, String user2) {
    if (user1.toLowerCase().codeUnits[0] > user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  // Load Data Profile
  loadProfile() {
    final user = Provider.of<auth.User?>(context, listen: false);
    ServicesDBget.getUser(user!.uid).then((value) {
      setState(() {
        userData = value.first;
      });
    });
  }

  /////////////////////////////////////
  ///////// Controllers Index /////////
  /////////////////////////////////////
  // Selector
  int _selectedIndex = 0;
  // Page list
  List<Widget> get _pages => <Widget>[
        conversations(),
        discover(),
        profile(),
      ];

  // Dispose
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
      appBar: AppBar(
        foregroundColor: secondaryColor,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        shadowColor: Colors.grey.shade100,
        elevation: 1,
        title: Column(
          children: [
            if (_selectedIndex == 0)
              Row(
                children: const [
                  Icon(Icons.question_answer),
                  SizedBox(
                    width: 2,
                  ),
                  Text('Conversaciones'),
                ],
              ),
            if (_selectedIndex == 1)
              Row(
                children: const [
                  Icon(Icons.travel_explore),
                  SizedBox(
                    width: 2,
                  ),
                  Text('Descubrir Personas'),
                ],
              ),
            if (_selectedIndex == 2)
              Row(
                children: const [
                  Icon(Icons.person),
                  SizedBox(
                    width: 2,
                  ),
                  Text('Perfil'),
                ],
              ),
          ],
        ),
      ),
      body: _pages.elementAt(_selectedIndex),
      extendBody: true,
      bottomNavigationBar: BottomNavigationBar(
        elevation: 1,
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        selectedItemColor: secondaryColor,
        unselectedItemColor: Colors.grey.shade400,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w300),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w300),
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.question_answer),
            label: "Conversaciones",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.travel_explore),
            label: "Descubrir Personas",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Perfil",
          ),
        ],
      ),
    );
  }

  /////////////////////////////////////
  //////////// DISCOVER ///////////////
  /////////////////////////////////////
  Center discover() {
    final user = Provider.of<auth.User?>(context, listen: false);
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 50, maxWidth: 450),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('users')
                    .where("idUser", isNotEqualTo: user!.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    default:
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          //data
                          var data = snapshot.data!.docs[index];

                          //Generator ChatRoomId
                          String chatId = chatRoomId(user.uid, data['idUser']);

                          return ChatListItem(
                              onTap: () {
                                nextScreen(
                                    context,
                                    ChatScreen(
                                      chatId: chatId,
                                      nameReciever: data['fullName'],
                                      nameSender: userData!.fullName,
                                      idReciever: data['idUser'],
                                    ));
                                setState(() {
                                  _selectedIndex = 0;
                                });
                              },
                              fullname: data['fullName']);
                        },
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /////////////////////////////////////
  ////////// CONVERSATIONS ////////////
  /////////////////////////////////////
  Center conversations() {
    final user = Provider.of<auth.User?>(context, listen: false);
    var idUser = user!.uid;
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 50, maxWidth: 450),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: firestore
                    .collection('users')
                    .doc(idUser)
                    .collection('chats')
                    .orderBy("time", descending: true)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  switch (snapshot.connectionState) {
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    default:
                      return ListView.builder(
                        physics: const BouncingScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          //data
                          var data = snapshot.data!.docs[index];

                          //Generator ChatRoomId
                          String chatId =
                              chatRoomId(user.uid, data['idReciever']);

                          //Format Time Message
                          var time =
                              DateTime.fromMillisecondsSinceEpoch(data['time']);
                          var hora = DateFormat('hh:mm a').format(time);

                          return ConversationListItem(
                            onTap: () {
                              nextScreen(
                                  context,
                                  ChatScreen(
                                    chatId: chatId,
                                    nameReciever: data['fullName'],
                                    nameSender: userData!.fullName,
                                    idReciever: data['idReciever'],
                                  ));
                            },
                            fullname: data['fullName'],
                            message: data['message'],
                            time: hora.toString(),
                          );
                        },
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /////////////////////////////////////
  ///////////// PROFILE ///////////////
  /////////////////////////////////////
  Center profile() {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(minWidth: 50, maxWidth: 450),
        child: userData != null
            ? Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(defaultPadding * 4),
                      child: CircleAvatar(
                        radius: 35,
                        backgroundColor: secondaryColor,
                        foregroundColor: primaryColor,
                        child: Text(
                          userData!.fullName[0].toUpperCase(),
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: defaultPadding,
                    ),
                    Column(
                      children: [
                        Text(
                          userData!.fullName.toUpperCase(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: secondaryColor,
                          ),
                        ),
                        Text(
                          userData!.userMail.toLowerCase(),
                          style: const TextStyle(
                            fontSize: 13,
                            color: secondaryColor,
                          ),
                        ),
                        Text(
                          'Edad: ${userData!.userAge.toString()}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: secondaryColor,
                          ),
                        ),
                        const SizedBox(
                          height: defaultPadding,
                        ),
                      ],
                    ),
                    ListTile(
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(width: 1, color: Colors.black12),
                        borderRadius: BorderRadius.all(
                          Radius.circular(defaultPadding / 2),
                        ),
                      ),
                      title: const Text('Cerrar sesión'),
                      leading: const Icon(
                        Icons.power_settings_new_rounded,
                        color: Colors.red,
                      ),
                      onTap: () {
                        logOut();
                      },
                    ),
                  ],
                ),
              )
            : const CircularProgressIndicator(),
      ),
    );
  }

  /////////////////////////////////////
  //// Function Change Selector ///////
  /////////////////////////////////////
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (_selectedIndex == 2) {
      loadProfile();
    }
  }

  /////////////////////////////////////
  ///////// Function Logout ///////////
  /////////////////////////////////////
  logOut() async {
    await authService.signOut().then((value) {
      showSnackBar(context, secondaryColor, '¡Sesión cerrada!');
    });
  }
}
