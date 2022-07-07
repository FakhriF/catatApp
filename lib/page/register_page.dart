import 'package:catat_app/class.dart';
import 'package:catat_app/firestore.dart';
import 'package:catat_app/page/home_page.dart';
import 'package:catat_app/page/loading_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:catat_app/my_flutter_app_icons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  static Future<User?> createUserEmailPass(
      {required String email,
      required String password,
      required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      print(e);
      return null;
    }
  }

  //stream firebase auth authstatechanged

  bool? isAgree = false;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  // TextEditingController userName = TextEditingController();

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
            //Register Page with name, email, password, confirm password
            const SizedBox(height: 70),
            const Text(
              "Daftar",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Silahkan isi data dibawah ini secara valid, agar dapat menggunakkan aplikasi Catat!",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 50),
            // TextField(
            //   controller: userName,
            //   decoration: const InputDecoration(
            //     labelText: "Nama Kamu",
            //     border: OutlineInputBorder(),
            //   ),
            // ),
            // const SizedBox(height: 20),
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
            TextField(
              controller: confirmPassword,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Konfirmasi Password",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            //i agree with privacy policy
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                //circle checkbox
                Container(
                  width: 15,
                  height: 15,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Checkbox(
                      fillColor:
                          MaterialStateProperty.resolveWith<Color>((states) {
                        if (states.contains(MaterialState.disabled)) {
                          return const Color.fromRGBO(18, 212, 146, 1);
                        }
                        return const Color.fromRGBO(18, 212, 146, 1);
                      }),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      value: isAgree,
                      onChanged: (value) {
                        setState(() {
                          isAgree = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                const Text(
                  "Saya setuju dengan",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                ),
                const SizedBox(width: 5),
                GestureDetector(
                  onTap: () {
                    // Navigator.pushNamed(context, '/privacy_policy');
                  },
                  child: const Text(
                    "Kebijakan Privasi",
                    style: TextStyle(
                      fontSize: 15,
                      color: Color.fromRGBO(18, 212, 146, 1),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 50),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: const Color.fromRGBO(18, 212, 146, 1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  )),
              onPressed: () async {
                if (password.text != confirmPassword.text) {
                  final snackBar = SnackBar(
                    backgroundColor: Colors.red.shade300,
                    content: const Text(
                      'Password dan Confirm Password tidak sama!',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else if (email.text.isEmpty || password.text.isEmpty) {
                  final snackBar = SnackBar(
                    backgroundColor: Colors.red.shade300,
                    content: const Text(
                      'Tolong isi Email atau Password!',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else if (password.text.length <= 6) {
                  final snackBar = SnackBar(
                    backgroundColor: Colors.red.shade300,
                    content: const Text(
                      'Minimal Password harus 6 kombinasi!',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else if (isAgree == false) {
                  final snackBar = SnackBar(
                    backgroundColor: Colors.red.shade300,
                    content: const Text(
                      'Tolong setuju dengan Kebijakan Privasi! Apabila ada yang ingin ditanyakan silahkan hubungi kami!',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  Navigator.pushNamed(context, '/loading');
                  User? user = await createUserEmailPass(
                    email: email.text,
                    password: password.text,
                    context: context,
                  );

                  if (user != null) {
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacementNamed(context, '/register/data');
                  } else {
                    Navigator.pop(context);
                    final snackBar = SnackBar(
                      backgroundColor: Colors.red.shade300,
                      content: const Text(
                        'Email sudah terdaftar!\nSilahkan pilih opsi Lupa Sandi pada halaman login!',
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                }
              },
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
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: "Sudah punya akun? ",
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                  TextSpan(
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(18, 212, 146, 1),
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushReplacementNamed(context, '/login');
                      },
                    text: "Masuk!",
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

class Register2Page extends StatefulWidget {
  const Register2Page({Key? key}) : super(key: key);

  @override
  State<Register2Page> createState() => _Register2PageState();
}

class _Register2PageState extends State<Register2Page> {
  final uid = FirebaseAuth.instance.currentUser?.uid;

  String? _gender = "";
  bool? isAgree = false;

  TextEditingController nama = TextEditingController();
  TextEditingController alasan = TextEditingController();
  TextEditingController know = TextEditingController();
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
            //Register Page with name, email, password, confirm password
            const SizedBox(height: 70),
            const Text(
              "SEDIKIT LAGI~!",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Email kamu sudah terdaftar! Agar aplikasi ini terasa lebih dekat dengan Kami, silahkan isi data di bawah ini!",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 50),
            TextField(
              controller: nama,
              decoration: const InputDecoration(
                labelText: "Nama Panggilan",
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Color.fromRGBO(18, 212, 146, 1),
                )),
                hintText: "Contoh : Ko, Conan, Ryuu, etc",
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: alasan,
              decoration: const InputDecoration(
                labelText: "Alasan",
                border: OutlineInputBorder(),
                hintText: "Contoh: Untuk catatan Game, Sekolah, etc",
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: know,
              decoration: const InputDecoration(
                labelText: "Darimana kamu mengetahui tentang aplikasi ini?",
                border: OutlineInputBorder(),
                hintText: "Contoh: Rekomendasi, Dipaksa Ujicoba, etc",
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Apakah Kamu...",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  //radiobutton between two option
                  children: [
                    //radio
                    Radio(
                        //fillcolor green
                        activeColor: Color.fromRGBO(18, 212, 146, 1),
                        value: "Laki-Laki",
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value.toString();
                          });
                        }),
                    const Text("Laki-Laki"),
                    SizedBox(
                      width: 20,
                    ),
                    Radio(
                        activeColor: Color.fromRGBO(18, 212, 146, 1),
                        value: "Perempuan",
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value.toString();
                          });
                        }),
                    const Text("Perempuan"),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 15,
                  height: 15,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Checkbox(
                      fillColor:
                          MaterialStateProperty.resolveWith<Color>((states) {
                        if (states.contains(MaterialState.disabled)) {
                          return const Color.fromRGBO(18, 212, 146, 1);
                        }
                        return const Color.fromRGBO(18, 212, 146, 1);
                      }),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      value: isAgree,
                      onChanged: (value) {
                        setState(() {
                          isAgree = value;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                const Text(
                  "Apakah ingin berlangganan dengan Surel bulanan Kami?\n(Optional)",
                  softWrap: true,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      showDetailData(context);
                    },
                    child: const Icon(
                      Icons.question_mark_rounded,
                      size: 20,
                    )),
                const Text(
                  "Mengapa harus diisi?",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              //change color elevated to green
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
              onPressed: () async {
                if (nama.text.isEmpty) {
                  final snackBar = SnackBar(
                    backgroundColor: Colors.red.shade300,
                    content: const Text(
                      'Tolong isi namanya ya~!',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else if (alasan.text.isEmpty) {
                  final snackBar = SnackBar(
                    backgroundColor: Colors.red.shade300,
                    content: const Text(
                      'Alasan nya jangan lupa ya~',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else if (_gender != "Laki-Laki" && _gender != "Perempuan") {
                  final snackBar = SnackBar(
                    backgroundColor: Colors.red.shade300,
                    content: const Text(
                      'Emmm, mas? mba? Eh, maaf kak!',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  addUser(
                    gender: _gender,
                    know: know.text,
                    uid: uid,
                    newsletter: isAgree,
                    name: nama.text,
                    email: FirebaseAuth.instance.currentUser?.email,
                    alasan: alasan.text,
                  );

                  await FirebaseAuth.instance.currentUser?.updateDisplayName(
                    nama.text,
                  );
                  Navigator.pushReplacementNamed(context, '/app');
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

//show alert dialog
Future<void> showDetailData(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("Kenapa harus diisi?"),
        content: const Text(
            "Aplikasi Catat! masih dalam pengembangan agar kedepannya lebih baik. Pengisian data ini dibuat agar pengembangan aplikasi ini dapat menyesuaikan kebutuhan para pengguna. Tenang saja, data yang kalian masukkan tidak akan dipublikasikan, dan akan tersimpan aman."),
        actions: <Widget>[
          ElevatedButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class Register2PageWebDekstop extends StatefulWidget {
  const Register2PageWebDekstop({Key? key}) : super(key: key);

  @override
  State<Register2PageWebDekstop> createState() =>
      _Register2PageWebDekstopState();
}

class _Register2PageWebDekstopState extends State<Register2PageWebDekstop> {
  final uid = FirebaseAuth.instance.currentUser?.uid;

  String? _gender = "";
  bool? isAgree = false;

  TextEditingController nama = TextEditingController();
  TextEditingController alasan = TextEditingController();
  TextEditingController know = TextEditingController();
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
            //Register Page with name, email, password, confirm password
            const SizedBox(height: 70),
            const Text(
              "SEDIKIT LAGI~!",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "Email kamu sudah terdaftar! Agar aplikasi ini terasa lebih dekat dengan Kami, silahkan isi data di bawah ini!",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 50),
            TextField(
              controller: nama,
              decoration: const InputDecoration(
                labelText: "Nama Panggilan",
                border: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Color.fromRGBO(18, 212, 146, 1),
                )),
                hintText: "Contoh : Ko, Conan, Ryuu, etc",
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: alasan,
              decoration: const InputDecoration(
                labelText: "Alasan",
                border: OutlineInputBorder(),
                hintText: "Contoh: Untuk catatan Game, Sekolah, etc",
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: know,
              decoration: const InputDecoration(
                labelText: "Darimana kamu mengetahui tentang aplikasi ini?",
                border: OutlineInputBorder(),
                hintText: "Contoh: Rekomendasi, Dipaksa Ujicoba, etc",
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Apakah Kamu...",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  //radiobutton between two option
                  children: [
                    //radio
                    Radio(
                        //fillcolor green
                        activeColor: Color.fromRGBO(18, 212, 146, 1),
                        value: "Laki-Laki",
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value.toString();
                          });
                        }),
                    const Text("Laki-Laki"),
                    SizedBox(
                      width: 20,
                    ),
                    Radio(
                        activeColor: Color.fromRGBO(18, 212, 146, 1),
                        value: "Perempuan",
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value.toString();
                          });
                        }),
                    const Text("Perempuan"),
                  ],
                )
              ],
            ),
            const SizedBox(height: 20),

            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  width: 15,
                  height: 15,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Center(
                    child: Checkbox(
                      fillColor:
                          MaterialStateProperty.resolveWith<Color>((states) {
                        if (states.contains(MaterialState.disabled)) {
                          return const Color.fromRGBO(18, 212, 146, 1);
                        }
                        return const Color.fromRGBO(18, 212, 146, 1);
                      }),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      value: isAgree,
                      onChanged: (value) {
                        setState(() {
                          isAgree = value;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                const Text(
                  "Apakah ingin berlangganan dengan Surel bulanan Kami?\n(Optional)",
                  softWrap: true,
                  maxLines: 2,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
            Row(
              children: [
                GestureDetector(
                    onTap: () {
                      showDetailData(context);
                    },
                    child: const Icon(
                      Icons.question_mark_rounded,
                      size: 20,
                    )),
                const Text(
                  "Mengapa harus diisi?",
                  style: TextStyle(
                    fontSize: 15,
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              //change color elevated to green
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
              onPressed: () async {
                if (nama.text.isEmpty) {
                  final snackBar = SnackBar(
                    backgroundColor: Colors.red.shade300,
                    content: const Text(
                      'Tolong isi namanya ya~!',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else if (alasan.text.isEmpty) {
                  final snackBar = SnackBar(
                    backgroundColor: Colors.red.shade300,
                    content: const Text(
                      'Alasan nya jangan lupa ya~',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else if (_gender != "Laki-Laki" && _gender != "Perempuan") {
                  final snackBar = SnackBar(
                    backgroundColor: Colors.red.shade300,
                    content: const Text(
                      'Emmm, mas? mba? Eh, maaf kak!',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  addUser(
                    gender: _gender,
                    know: know.text,
                    uid: uid,
                    newsletter: isAgree,
                    name: nama.text,
                    email: FirebaseAuth.instance.currentUser?.email,
                    alasan: alasan.text,
                  );
                  await FirebaseAuth.instance.currentUser?.updateDisplayName(
                    nama.text,
                  );
                  Navigator.pushReplacementNamed(context, '/app');
                  alertRefresh(context: context);

                  //   Navigator.push(context,
                  //       MaterialPageRoute(builder: (context) => LoadingPage()));
                }
                // Navigator.pop(context);
                // Navigator.push(context,
                //     MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> alertRefresh({required context}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Data Berhasil Disimpan'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text('Mohon Refresh Halaman ini untuk mengakses aplikasi Catat!'),
            ],
          ),
        ),
        actions: <Widget>[],
      );
    },
  );
}
