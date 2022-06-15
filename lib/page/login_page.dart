import 'package:catat_app/authentication.dart';
import 'package:catat_app/colors.dart';
import 'package:catat_app/firestore.dart';
import 'package:catat_app/responsive.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

TextEditingController email = TextEditingController();
TextEditingController password = TextEditingController();

// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   @override
//   Widget build(BuildContext context) {
//     if (user != "Umum") {
//       return loginGeneral();
//     } else {
//       return loginCrew();
//     }
//   }
// }

class loginGeneral extends StatelessWidget {
  const loginGeneral({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: MediaQuery.of(context).size.width >= 1200
            ? EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.3,
                right: MediaQuery.of(context).size.width * 0.3)
            : EdgeInsets.only(left: 35.0, right: 35.0),
        child: ListView(
          children: [
            const SizedBox(height: 70),
            const Text(
              "Masuk",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Silahkan masuk dengan email dan password yang terdaftar!",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 100),
            TextField(
              controller: email,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text(
                    "Lupa Password?",
                    style: TextStyle(
                        color: primaryColor, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 100),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  )),
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.6,
                child: const Center(
                  child: Text(
                    'Masuk!',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              onPressed: () async {
                if (email.text.isNotEmpty && password.text.isNotEmpty) {
                  Navigator.pushNamed(context, '/loading');
                  User? user = await loginEmailPassword(
                    email: email.text,
                    password: password.text,
                    context: context,
                  );
                  if (user != null) {
                    Navigator.pushReplacementNamed(context, '/home');
                    LastAccessUser();
                  } else {
                    Navigator.pop(context);
                    final snackBar = SnackBar(
                      backgroundColor: warningColor,
                      content: const Text(
                        'Email atau Password yang kamu masukkan tidak terdaftar!',
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                } else {
                  final snackBar = SnackBar(
                    backgroundColor: warningColor,
                    content: const Text(
                      'Tolong isi Email dan Passwordnya!',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Belum punya akun? ",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushReplacementNamed(context, '/register');
                      },
                    text: "Daftar!",
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class loginCrew extends StatelessWidget {
  const loginCrew({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: MediaQuery.of(context).size.width >= 1200
            ? EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.3,
                right: MediaQuery.of(context).size.width * 0.3)
            : EdgeInsets.only(left: 35.0, right: 35.0),
        child: ListView(
          children: [
            const SizedBox(height: 70),
            const Text(
              "Masuk",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Silahkan masuk dengan email dan password yang terdaftar!",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 100),
            TextField(
              controller: email,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),
            // const SizedBox(height: 20),
            // Column(
            //   crossAxisAlignment: CrossAxisAlignment.start,
            //   children: [
            //     TextButton(
            //       onPressed: () {},
            //       child: Text(
            //         "Lupa Password?",
            //         style: TextStyle(
            //             color: primaryColor, fontWeight: FontWeight.bold),
            //       ),
            //     ),
            //   ],
            // ),
            const SizedBox(height: 100),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  )),
              child: SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width * 0.6,
                child: const Center(
                  child: Text(
                    'Masuk!',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              onPressed: () async {
                if (email.text.isNotEmpty && password.text.isNotEmpty) {
                  Navigator.pushNamed(context, '/loading');
                  User? user = await loginEmailPassword(
                    email: email.text,
                    password: password.text,
                    context: context,
                  );
                  if (user != null) {
                    Navigator.pushReplacementNamed(context, '/crew/home');
                    LastAccessUser();
                  } else {
                    Navigator.pop(context);
                    final snackBar = SnackBar(
                      backgroundColor: warningColor,
                      content: const Text(
                        'Email atau Password yang kamu masukkan tidak terdaftar!',
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                } else {
                  final snackBar = SnackBar(
                    backgroundColor: warningColor,
                    content: const Text(
                      'Tolong isi Email dan Passwordnya!',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
            ),
            const SizedBox(height: 20),
            // RichText(
            //   text: TextSpan(
            //     children: [
            //       const TextSpan(
            //         text: "Belum punya akun? ",
            //         style: TextStyle(
            //           color: Colors.black,
            //         ),
            //       ),
            //       TextSpan(
            //         style: TextStyle(
            //           fontWeight: FontWeight.bold,
            //           color: primaryColor,
            //         ),
            //         recognizer: TapGestureRecognizer()
            //           ..onTap = () {
            //             Navigator.pushReplacementNamed(context, '/register');
            //           },
            //         text: "Daftar!",
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
