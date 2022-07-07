import 'package:catat_app/crew/crew_bantuan.dart';
import 'package:catat_app/crew/crew_homePage.dart';
import 'package:catat_app/main.dart';
import 'package:catat_app/page/account/account_page.dart';
import 'package:catat_app/page/account/profile_data_page.dart';
import 'package:catat_app/page/settings/bantuan.dart';
import 'package:catat_app/page/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'firebase_options.dart';
import 'package:catat_app/page/home_page.dart';
import 'package:catat_app/page/loading_page.dart';
import 'package:catat_app/page/login_page.dart';
import 'package:catat_app/page/notes-notebook/note_book_list_page.dart';
import 'package:catat_app/page/register_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:catat_app/page/notes-notebook/add_noted.dart';
import 'package:catat_app/page/notfound_page.dart';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scrollBehavior: MaterialScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
          PointerDeviceKind.unknown
        },
      ),
      title: 'Catat!',
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _initializeFirebase(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            FirebaseAuth.instance.authStateChanges().listen((User? user) {
              if (user == null) {
                // print('User is currently signed out!');
                Navigator.pushNamed(context, '/loading');

                Navigator.pushReplacementNamed(context, '/welcome');
              } else {
                // print('User is signed in!');
                // LastAccessUser();
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => LoadingPage()));

                Navigator.pushReplacementNamed(context, '/app');
              }
            });
            return const WelcomePage();
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      // initialRoute:
      //     FirebaseAuth.instance.currentUser == null ? '/welcome' : '/home',
      routes: {
        // '/': (context) => const LoginPage(),
        //CREW
        '/crew/login': (context) => const loginCrew(),
        '/crew/home': (context) => const CrewHomePage(),
        '/crew/bantuan': (context) => CrewBantuanListPage(),
        //GENERAL
        '/404': (context) => const NotFoundPage(),
        '/loading': (context) => const LoadingPage(),
        '/welcome': (context) => const WelcomePage(),
        '/login': (context) => const loginGeneral(),
        '/register': (context) => const RegisterPage(),
        '/register/data': (context) => const Register2Page(),
        '/app': (context) => HomePage(),
        '/note-list': (context) => const NotesListPage(),
        '/account': (context) => const AccountPage(),
        '/notebook-list': (context) => const NotebookListPage(),
        '/profile': (context) => const ProfileDataPage(),
        '/bantuan': (context) => BantuanListPage(),
        '/add': (context) =>
            AddNotesPage(labels: "My Notebook", judul: "", isi: ""),
        '/settings': (context) => const SettingPage(),
      },
    );
  }
}
