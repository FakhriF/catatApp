import 'dart:async';

import 'package:catat_app/account_page.dart';
import 'package:catat_app/colors.dart';
import 'package:catat_app/login_page.dart';
import 'package:catat_app/my_flutter_app_icons.dart';
import 'package:catat_app/settings/bantuan.dart';
import 'package:catat_app/settings/info_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:catat_app/my_flutter_app_icons.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // ignore: prefer_typing_uninitialized_variables
  var picprof;
  TextEditingController pic = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengaturan"),
        foregroundColor: primaryColor,
        backgroundColor: Colors.white,
        elevation: 0.5,
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(
                Icons.person,
                color: Colors.black,
              ),
              title: const Text('Akun'),
              onTap: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.support_agent_rounded,
                color: Colors.black,
              ),
              title: const Text('Bantuan'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BantuanPage(),
                  ),
                );
              },
            ),
            // ListTile(
            //   leading: Image.asset(
            //   "assets/icons/Notebook_ico.png",
            //   // color: Colors.grey,
            //   width: 20,
            // ),
            //   title: const Text('Buku Catatan'),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => AccountPage(),
            //       ),
            //     );
            //   },
            // ),
            ListTile(
              leading: const Icon(
                Icons.feedback_outlined,
                color: Colors.black,
              ),
              title: const Text('Feedback Hub'),
              onTap: () {
                Navigator.pushNamed(context, '/404');
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.info_outline_rounded,
                color: Colors.black,
              ),
              title: const Text('Info Aplikasi'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VersionApp(),
                  ),
                );
              },
            ),
          ],
        ),
      )),
    );
  }
}
