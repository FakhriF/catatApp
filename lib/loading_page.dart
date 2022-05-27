import 'dart:async';

import 'package:catat_app/authentication.dart';
import 'package:catat_app/colors.dart';
import 'package:catat_app/firestore.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Tunggu Sebentar ya!",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 80),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(
                primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LoadingLoginRegisterPage extends StatefulWidget {
  const LoadingLoginRegisterPage({Key? key}) : super(key: key);

  @override
  State<LoadingLoginRegisterPage> createState() =>
      _LoadingLoginRegisterPageState();
}

class _LoadingLoginRegisterPageState extends State<LoadingLoginRegisterPage> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 1), () {
      StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users/${currentUser?.uid}/scratch-pad')
              .doc('scratch-pad')
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (!snapshot.data!.exists || !snapshot.hasData) {
              addScratchPad(isi: "");
            } else {
              addScratchPad(isi: snapshot.data?['isi']);
            }
            return Container();
          });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Tunggu Sebentar ya!",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 80),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(
                primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
