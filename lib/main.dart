// import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:catat_app/account_page.dart';
import 'package:catat_app/add_noted.dart';
import 'package:catat_app/home_page.dart';
import 'package:catat_app/loading_page.dart';
import 'package:catat_app/login_page.dart';
import 'package:catat_app/note_book_list_page.dart';
import 'package:catat_app/register_page.dart';
import 'package:catat_app/settings/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized;
  // await Firebase.initializeApp();
  runApp(const MyApp());
}

// class MyApp extends StatefulWidget {
//   const MyApp({Key? key}) : super(key: key);

//   // This widget is the root of your application.

//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> {
//   late StreamSubscription<User?> user;
//   @override
//   void initState() {
//     super.initState();
//     user = FirebaseAuth.instance.authStateChanges().listen((user) {
//       if (user == null) {
//         print('User is currently signed out!');
//       } else {
//         print('User is signed in!');
//       }
//     });
//   }

//   @override
//   void dispose() {
//     user.cancel();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       /// check if user is signed (Open Chat page ) if user is not signed in (open welcome page)
//       initialRoute:
//           FirebaseAuth.instance.currentUser == null ? '/welcome' : '/home',

//       ///key value pair
//       routes: {
//         '/welcome': (context) => const WelcomePage(),
//         '/login': (context) => const LoginPage(),
//         '/register': (context) => const RegisterPage(),
//         '/home': (context) => const HomePage(),
//       },
//       home: const WelcomePage(),
//     );
//   }
// }

// ...

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // late StreamSubscription<User?> user;
  // @override
  // void initState() {
  //   super.initState();
  //   user = FirebaseAuth.instance.authStateChanges().listen((user) {
  //     if (user == null) {
  //       print('User is currently signed out!');
  //     } else {
  //       print('User is signed in!');
  //     }
  //   });
  // }

  // @override
  // void dispose() {
  //   user.cancel();
  //   super.dispose();
  // }

  // final uid = FirebaseAuth.instance.currentUser?.uid;

  // Future LastAccessUser() async {
  //   final docUser = FirebaseFirestore.instance.collection('users').doc(uid);
  //   final LastAccess = FieldValue.serverTimestamp();
  //   final json = {
  //     'LastAccess': LastAccess,
  //   };
  //   await docUser.set(json);
  // }

  Future<FirebaseApp> _initializeFirebase() async {
    FirebaseApp firebaseApp = await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    return firebaseApp;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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

                Navigator.pushReplacementNamed(context, '/home');
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
        //   // '/': (context) => const LoginPage(),
        '/loading': (context) => const LoadingPage(),
        '/welcome': (context) => const WelcomePage(),
        '/login': (context) => const LoginPage(),
        '/register': (context) => const RegisterPage(),
        '/register/2': (context) => const Register2Page(),
        '/home': (context) => HomePage(),
        '/note-list': (context) => const NotesListPage(),
        '/account': (context) => const AccountPage(),
        '/notebook-list': (context) => const NotebookListPage(),
        '/add': (context) =>
            AddNotesPage(labels: "My Notebook", judul: "", isi: ""),
        '/settings': (context) => const SettingPage(),
      },
    );
  }
}

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/images/get-start.jpg'),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.7),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
                  child: Text(
                    'Catatlah cerita, catatan sekolah, atau kenangan yang tak mau dilupakan di aplikasi Catat!',
                    style: TextStyle(
                      // fontFamily: 'Roboto',
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 100),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: const Color.fromRGBO(18, 212, 146, 1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      )),
                  child: SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: const Center(
                      child: Text(
                        'Mari Mulai!',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed('/login');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class CreateSignPage extends StatefulWidget {
//   const CreateSignPage({Key? key}) : super(key: key);

//   @override
//   State<CreateSignPage> createState() => CreateSignPageState();
// }

// class CreateSignPageState extends State<CreateSignPage> {
//   Stream<User?> get user {
//     return FirebaseAuth.instance.authStateChanges().listen((User? user) {
//       if (user == null) {
//         return LoginPage();
//       } else {
//         print('User is signed in!');
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }
