import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:wallyapp/config/config.dart';
import 'package:wallyapp/pages/homepage.dart';
import 'package:wallyapp/pages/signin_screen.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
      theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: primaryColor,
          fontFamily: "productsans"),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  // @override
  // void initState() {

  //   _firebaseMessaging.configure(
  //     onMessage: (Map<String, dynamic> message) async {
  //       print("onMessage: $message");
  //       String title = message["notification"]["title"] ?? "";
  //       String body = message["notification"]["body"] ?? "";

  //       print(title);
  //       print(body);

  //       _showDialog(
  //         title: title,
  //         body: body
  //       );
  //     },
  //     onLaunch: (Map<String, dynamic> message) async {
  //       print("onLaunch: $message");
  //       String title = message["notification"]["title"] ?? "";
  //       String body = message["notification"]["body"] ?? "";

  //       print(title);
  //       print(body);

  //       _showDialog(
  //         title: title,
  //         body: body
  //       );
  //     },
  //     onResume: (Map<String, dynamic> message) async {
  //       print("onResume: $message");
  //       String title = message["notification"]["title"] ?? "";
  //       String body = message["notification"]["body"] ?? "";

  //       print(title);
  //       print(body);

  //       _showDialog(
  //         title: title,
  //         body: body
  //       );
  //     },
  //   );

  //   _firebaseMessaging.subscribeToTopic("promotion");

  //   this.initDynamicLinks();

  //   super.initState();
  // }

  // void initDynamicLinks() async {

  //   FirebaseDynamicLinks.instance.onLink(
  //     onSuccess: (PendingDynamicLinkData dynamicLink) async {
  //       final Uri deepLink = dynamicLink?.link;

  //       if (deepLink != null) {
  //         print(deepLink);
  //       }
  //     },
  //     onError: (OnLinkErrorException e) async {
  //       print('onLinkError');
  //       print(e.message);
  //     }
  //   );

  // }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _auth.authStateChanges(),
      builder: (ctx, AsyncSnapshot<User> snapshot) {
        if (snapshot.hasData) {
          User user = snapshot.data;
          if (user != null) {
            return HomePage();
          } else {
            return SignInScreen();
          }
        }

        return SignInScreen();
      },
    );
  }
}
