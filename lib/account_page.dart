import 'dart:async';

import 'package:catat_app/my_flutter_app_icons.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  // ignore: prefer_typing_uninitialized_variables
  var picprof;
  TextEditingController pic = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Akun"),
        foregroundColor: const Color.fromRGBO(18, 212, 146, 1),
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('users')
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const Text("Wait..");
                        }
                        var userDocument = snapshot.data!;
                        return Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                filterQuality: FilterQuality.high,
                                image: userDocument['gender'] == "Laki-laki"
                                    ? const AssetImage(
                                        "assets/pic_prof/men1_prof.png")
                                    : const AssetImage(
                                        "assets/pic_prof/women1_prof.png"),
                                fit: BoxFit.cover,
                              ),
                            ));
                      }),
                  //profil picture virlce
                  const SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${FirebaseAuth.instance.currentUser?.displayName}",
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text("${FirebaseAuth.instance.currentUser?.email}"),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            ListTile(
              leading: const Icon(
                CatatAppIcons.UName,
                size: 30,
              ),
              title: const Text('Ganti Username'),
              onTap: () {
                changeUName(context: context);
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.email,
                color: Colors.black,
              ),
              title: const Text('Ganti Email'),
              onTap: () {
                // changeEmail(context: context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => reAuthenticatePage(
                              status: "Email",
                            )));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.key_rounded,
                color: Colors.black,
              ),
              title: const Text('Ganti Password'),
              onTap: () {
                // changePass(context: context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => reAuthenticatePage(
                              status: "Password",
                            )));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.delete_forever,
                color: Colors.black,
              ),
              title: const Text('Hapus Akun'),
              onTap: () {
                deleteUser(context: context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Log Out'),
              onTap: () {
                alertDialogSignOut(context: context);
              },
            ),
          ],
        ),
      )),
    );
  }
}

Future<void> changeEmail({required context}) {
  TextEditingController newEmail = TextEditingController();
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Ganti Email'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              TextField(
                controller: newEmail,
                decoration: const InputDecoration(
                  labelText: 'Email Baru',
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Tidak"),
          ),
          TextButton(
            onPressed: () {
              updateEmail(newEmail: newEmail.text);
              Navigator.pop(context);
            },
            child: const Text("Ubah"),
          ),
        ],
      );
    },
  );
}

class reAuthenticatePage extends StatelessWidget {
  reAuthenticatePage({required this.status, Key? key}) : super(key: key);

  String status;

  Future deleteData({
    required String? uid,
  }) async {
    final instance = FirebaseFirestore.instance;
    final batch = instance.batch();
    final batch2 = instance.batch();
    var collectionNotes = instance.collection('users/$uid/notes');
    var collectionNotebook = instance.collection('users/$uid/notebooks');
    var snapshots = await collectionNotes.get();
    var snapshots2 = await collectionNotebook.get();
    for (var doc in snapshots.docs) {
      batch.delete(doc.reference);
    }
    for (var doc in snapshots2.docs) {
      batch2.delete(doc.reference);
    }
    await batch.commit();
    await batch2.commit();
    await instance.collection('users').doc(uid).delete();
  }

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 35.0, right: 35.0),
        child: ListView(
          children: [
            const SizedBox(height: 70),
            const Text(
              "LOGIN",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Kamu melakukan aktivitas yang sensitif, silahkan masukkan kembali email & password!",
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
            const SizedBox(height: 100),
            // ElevatedButton(
            //   child: const Text("LOGIN"),
            //   onPressed: () async {},
            // ),
            // const SizedBox(height: 20),
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
                    'Masuk!',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              onPressed: () async {
                Future<UserCredential>? user = FirebaseAuth.instance.currentUser
                    ?.reauthenticateWithCredential(
                  EmailAuthProvider.credential(
                    email: email.text,
                    password: password.text,
                  ),
                );

                if (user != null) {
                  if (status == "Delete") {
                    deleteData(uid: FirebaseAuth.instance.currentUser?.uid);
                    await FirebaseAuth.instance.currentUser?.delete();
                    //snackbar
                    final snackBar = SnackBar(
                      backgroundColor: Colors.yellow.shade300,
                      content: const Text(
                        'Akun Kamu berhasil Dihapus!\n\nTerima kasih telah menggunakkan aplikasi Catat!',
                        style: TextStyle(color: Colors.black),
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    Navigator.pushReplacementNamed(context, '/login');
                  } else {
                    Navigator.pop(context);
                    changeDataSen(context: context, status: status);
                  }
                } else {
                  final snackBar = SnackBar(
                    backgroundColor: Colors.yellow.shade300,
                    content: const Text(
                      'Oopps! Password atau Email mu tidak cocok!',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

Future UpdateUser() async {
  final user = FirebaseAuth.instance.currentUser;
  final uid = user?.uid;
  final docUser = FirebaseFirestore.instance.collection('users').doc(uid);
  final userName = user?.displayName;
  final userEmail = user?.email;
  final json = {
    'name': userName,
    'email': userEmail,
  };
  await docUser.update(json);
}

Future<void> deleteUser({required context}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Anda yakin ingin menghapus akun ini?'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text(
                  'Dengan menghapus akun ini, maka seluruh data catatan Kamu akan ikut terhapus. Selain itu juga, email Kamu akan terhapus dari aplikasi ini.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Tidak'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Ya'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => reAuthenticatePage(status: "Delete"),
                ),
              );
            },
          ),
        ],
      );
    },
  );
}

Future<void> changeUName({required context}) {
  TextEditingController newName = TextEditingController();
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Ganti Username'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              TextField(
                controller: newName,
                decoration: const InputDecoration(
                  labelText: 'Username Baru',
                ),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Tidak"),
          ),
          TextButton(
            onPressed: () {
              if (newName.text.isEmpty) {
                final snackBar = SnackBar(
                  backgroundColor: Colors.red.shade300,
                  content: const Text(
                    'Hey, Kamu gak punya nama? Bisa cek KTP ya klo lupa!',
                    style: TextStyle(color: Colors.black),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                updateName(newName: newName.text);
                Timer(
                  const Duration(seconds: 2),
                  () {
                    UpdateUser();
                  },
                );
                Navigator.pop(context);
                alertChange(context: context);
              }
            },
            child: const Text("Ubah"),
          ),
        ],
      );
    },
  );
}

Future<void> changeDataSen({required context, required String status}) {
  TextEditingController newPass = TextEditingController();
  TextEditingController newMail = TextEditingController();
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Ganti $status'),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              if (status == "Email")
                TextField(
                  controller: newMail,
                  decoration: const InputDecoration(
                    labelText: 'Email Baru',
                  ),
                ),
              if (status == "Password")
                TextField(
                  controller: newPass,
                  decoration: InputDecoration(
                    labelText: '$status Baru',
                  ),
                ),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Tidak"),
          ),
          TextButton(
            onPressed: () {
              if (status == "Email") {
                if (newMail.text.isEmpty) {
                  final snackBar = SnackBar(
                    backgroundColor: Colors.red.shade300,
                    content: const Text(
                      'Maaf Email ini harus diisi! Ga bisa menjomblo',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  updateEmail(newEmail: newMail.text);
                  Timer(
                    const Duration(seconds: 2),
                    () {
                      UpdateUser();
                    },
                  );
                  Navigator.pop(context);
                  alertChange(context: context);
                }
              } else if (status == "Password") {
                if (newPass.text.isEmpty) {
                  final snackBar = SnackBar(
                    backgroundColor: Colors.red.shade300,
                    content: const Text(
                      'Maaf password ini harus diisi! Ga bisa menjomblo',
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else {
                  updatePassword(newPass: newPass.text);
                  Navigator.pop(context);
                  alertChange(context: context);
                }
              }
            },
            child: const Text("Ubah"),
          ),
        ],
      );
    },
  );
}

Future updateName({required String newName}) async {
  await FirebaseAuth.instance.currentUser?.updateDisplayName(newName);
}

Future updateEmail({required String newEmail}) async {
  await FirebaseAuth.instance.currentUser?.updateEmail(newEmail);
}

Future updatePassword({required String newPass}) async {
  await FirebaseAuth.instance.currentUser?.updatePassword(newPass);
}

Future<void> alertChange({required context}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Berhasil!'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text(
                  'Datamu sudah diubah! Perlu diingat, memperlukan beberapa waktu untuk sinkronisasi data.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Ya'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

Future<void> alertDialogSignOut({required context}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Log Out'),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text(
                  'Apakah kamu yakin ingin keluar? Tenang saja catatan Kamu tidak akan terhapus dikarenakan sudah tersimpan di cloud. Log in kembali dengan akun email yang sama jika ingin mengakses catatan sekarang!'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Tidak'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            child: const Text('Ya'),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pop();
              Navigator.pushReplacementNamed(context, '/welcome');
            },
          ),
        ],
      );
    },
  );
}
