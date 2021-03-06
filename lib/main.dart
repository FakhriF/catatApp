// import 'dart:async';
import 'package:catat_app/main_myApp.dart';

import 'package:catat_app/responsive.dart';
import 'package:flutter/material.dart';
import 'package:url_strategy/url_strategy.dart';

// const apiKey = 'AIzaSyDv2srrn3QfejUEPR2ae5oLxPbz4l9MctE';
// const projectId = 'catat-a4880';

void main() {
  // Firestore.initialize(projectId);
  // WidgetsFlutterBinding.ensureInitialized;
  // await Firebase.initializeApp();
  setPathUrlStrategy();

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
                  child: Builder(builder: (context) {
                    return Responsive(
                        mobile: SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: const Center(
                            child: Text(
                              'Mari Mulai!',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        tablet: SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: const Center(
                            child: Text(
                              'Mari Mulai!',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ),
                        dekstop: SizedBox(
                          height: 50,
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: const Center(
                            child: Text(
                              'Mari Mulai!',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        ));
                  }),
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
