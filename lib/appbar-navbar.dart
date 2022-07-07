import 'dart:io';

import 'package:catat_app/crew/crew_beta.dart';
import 'package:catat_app/page/notes-notebook/add_noted.dart';
import 'package:catat_app/colors.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AppBarA extends StatelessWidget {
  final String title;
  const AppBarA({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey,
            width: 1,
          ),
        ),
      ),
      child: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 50),
          child: Builder(builder: (context) {
            if (title == "Catatan" || title == "Buku Catatan") {
              return Text(
                title,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              );
            } else {
              return Row(
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/icons/Notebook_ico.png",
                    width: 15,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ],
              );
            }
          })),
    );
  }
}

class BottomNavCreate extends StatelessWidget {
  String page;
  BottomNavCreate({
    required this.page,
    Key? key,
    required GlobalKey<ScaffoldState> scaffoldKey,
  })  : _scaffoldKey = scaffoldKey,
        super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey.shade300,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: <Widget>[
            Positioned(
              left: 30,
              // top: 10,
              child: GestureDetector(
                onTap: () {
                  _scaffoldKey.currentState!.openDrawer();
                },
                child: Image.asset(
                  "assets/icons/Menu_ico.png",
                  width: 20,
                ),
              ),
            ),
            // SizedBox(
            //   width: 110,
            // ),
            //container with litter upper with border circular 12 and child text new
            Positioned(
              //center
              // left: MediaQuery.of(context).size.width * 0.35,
              top: -20,
              child: GestureDetector(
                onTap: () {
                  if (page != "Buku Catatan" &&
                      page != "Catatan" &&
                      page != "Home") {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddNotesPage(
                                labels: page, judul: "", isi: "")));
                  } else {
                    Navigator.pushNamed(context, '/add');
                  }
                },
                child: Container(
                    width: 125,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(21),
                      color: primaryColor,
                    ),
                    child: const Center(
                      child: Text(
                        "+ Tambah",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerWidget extends StatelessWidget {
  final String pageActive;
  const DrawerWidget({
    required this.pageActive,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            leading: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Text("Wait..");
                  }
                  var userDocument = snapshot.data!;
                  return Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          filterQuality: FilterQuality.high,
                          image: userDocument['gender'] == "Laki-Laki"
                              ? const AssetImage(
                                  "assets/pic_prof/men1_prof.png")
                              : const AssetImage(
                                  "assets/pic_prof/women1_prof.png"),
                          fit: BoxFit.cover,
                        ),
                      ));
                }),
            title: Text("${FirebaseAuth.instance.currentUser?.displayName}"),
            subtitle: Text("${FirebaseAuth.instance.currentUser?.email}"),
            onTap: () {
              Navigator.pushNamed(context, '/account');
            },
          ),
          ListTile(
            leading: const Icon(Icons.home, color: Colors.black),
            title: const Text('Beranda'),
            onTap: () {
              if (pageActive == "Home") {
                Navigator.pop(context);
              } else {
                Navigator.pushNamed(context, '/app');
              }
            },
          ),
          ListTile(
            leading: Image.asset(
              "assets/icons/Notes_ico.png",
              width: 20,
              // color: Colors.grey,
            ),
            title: const Text('Catatan'),
            onTap: () {
              if (pageActive == "Catatan") {
                Navigator.pop(context);
              } else {
                Navigator.pushNamed(context, '/note-list');
              }
            },
          ),
          ListTile(
            leading: Image.asset(
              "assets/icons/Notebook_ico.png",
              // color: Colors.grey,
              width: 20,
            ),
            title: const Text('Buku catatan'),
            onTap: () {
              if (pageActive == "Buku Catatan") {
                Navigator.pop(context);
              } else {
                Navigator.pushNamed(context, '/notebook-list');
              }
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.settings,
              color: Colors.black,
            ),
            title: const Text('Pengaturan'),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          // ListTile(
          //   leading: const Icon(
          //     Icons.settings,
          //     color: Colors.black,
          //   ),
          //   title: const Text('Beta'),
          //   onTap: () {
          //     Navigator.push(context,
          //         MaterialPageRoute(builder: (context) => BetaHomePage()));
          //   },
          // ),
          // ListTile(
          //   leading: const Icon(
          //     Icons.settings,
          //     color: Colors.black,
          //   ),
          //   title: const Text('LogOUT'),
          //   onTap: () {
          //     FirebaseAuth.instance.signOut();
          //     Navigator.pop(context);
          //     Navigator.pushReplacementNamed(context, '/welcome');
          //     Navigator.pop(context);
          //   },
          // ),
          if (MediaQuery.of(context).size.width >= 1200) ...[
            ListTile(
              leading: const Icon(
                Icons.android_rounded,
                color: Colors.black,
              ),
              title: const Text('Dapatkan Aplikasinya!'),
              onTap: () {
                Navigator.pushNamed(context, '/404');
              },
            ),
          ]
        ],
      ),
    );
  }
}
