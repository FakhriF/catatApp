import 'dart:async';

import 'package:catat_app/add_noted.dart';
import 'package:catat_app/appbar-navbar.dart';
import 'package:catat_app/authentication.dart';
import 'package:catat_app/colors.dart';
import 'package:catat_app/firestore.dart';
import 'package:catat_app/notebooks_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
  Future LastAccessUser() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    final docUser = FirebaseFirestore.instance.collection('users').doc(uid);
    final LastAccess = FieldValue.serverTimestamp();
    final json = {
      'LastAccess': LastAccess,
    };
    await docUser.update(json);
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Stream<QuerySnapshot> getNotes({required String? uid}) {
    return FirebaseFirestore.instance
        .collection('users/$uid/notes')
        .orderBy('time', descending: true)
        .snapshots();
  }

  Stream<QuerySnapshot> getNotebooks({required String? uid}) {
    return FirebaseFirestore.instance
        .collection('users/$uid/notebooks')
        .orderBy('Notebook', descending: false)
        .limit(4)
        .snapshots();
  }

//   @override
// void initState() {
//   super.initState();
//   post = buildStream();
// }

  //read firestore
  Stream<DocumentSnapshot<Map<String, dynamic>>> getUser(
      {required String? uid}) {
    return FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    // LastAccessUser();
    return Scaffold(
        extendBodyBehindAppBar: true,
        key: _scaffoldKey,
        // floatingActionButton: FloatingActionButton(
        //   foregroundColor: Colors.black,
        //   backgroundColor: Colors.yellow.shade300,
        //   onPressed: () {
        //     Navigator.pushNamed(context, '/add');
        //   },
        //   child: const Icon(Icons.add),
        // ),
        // appBar: AppBar(
        //   //appbar color transparent
        //   elevation: 0,

        //   leading: IconButton(
        //     onPressed: () {
        //       _scaffoldKey.currentState!.openDrawer();
        //     },
        //     icon: Icon(Icons.more_horiz, color: Colors.yellow.shade300),
        //   ),
        //   backgroundColor: Colors.transparent,
        //   foregroundColor: Colors.transparent,
        // ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: 155,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      "assets/images/Home-thumb.jpg",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 0, 0, 25),
                      child: Text(
                        "Halo, ${FirebaseAuth.instance.currentUser?.displayName}",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // const SizedBox(height: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  "Catatan Kamu",
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(context, '/note-list');
                                  },
                                  child: Icon(
                                    Icons.navigate_next,
                                    color: primaryColor, // size: 23,
                                  ),
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, '/add');
                              },
                              child: const Icon(
                                Icons.add,
                                // size: 23,
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        constraints: const BoxConstraints(
                          minHeight: 150.0,
                          maxHeight: 200.0,
                        ),
                        child: StreamBuilder(
                          stream: getNotes(
                              uid: FirebaseAuth.instance.currentUser?.uid),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData &&
                                snapshot.data?.size == 0) {
                              return const Padding(
                                padding: EdgeInsets.fromLTRB(16.0, 0, 16, 0),
                                child: Center(
                                  child: Text(
                                    "Kamu tidak memiliki Catatan! Sentuh tombol \"+\" dibawah untuk membuat catatan baru!",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return ListView(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                children: snapshot.data!.docs
                                    .map((DocumentSnapshot document) {
                                  Map<String, dynamic> notes =
                                      document.data()! as Map<String, dynamic>;
                                  // var color = Colors.yellow.shade300;
                                  // if (notes['theme'] == null ||
                                  //     notes['theme'] == "default") {
                                  //   color = color;
                                  // } else if (notes['theme'] == "blue") {
                                  //   color = Colors.blue.shade300;
                                  // } else if (notes['theme'] == "green") {
                                  //   color = Colors.green.shade200;
                                  // } else if (notes['theme'] == "red") {
                                  //   color = Colors.red.shade200;
                                  // }
                                  return Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 16.0),
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: ((context) =>
                                                        ReadNotesPage(
                                                            notes: notes))));
                                          },
                                          child: Container(
                                            height: 200,
                                            width: 150,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                color: primaryColor,
                                                width: 2,
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    notes['title'],
                                                    maxLines: 2,
                                                    style: const TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    notes['content'],
                                                    maxLines: 7,
                                                    // overflow: TextOverflow.ellipsis,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Scratch Pad"),
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection(
                                      'users/${currentUser?.uid}/scratch-pad')
                                  .doc('scratch-pad')
                                  .snapshots(),
                              builder: (context,
                                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                                var userDocument = snapshot.data;
                                String? teks;

                                if (snapshot.data?.exists == false) {
                                  teks = 'Tulis sesuatu...';
                                } else {
                                  teks = userDocument?['content'];
                                }
                                TextEditingController isi =
                                    TextEditingController(text: teks);
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddNotesPage(
                                                labels: "My Notebook",
                                                judul:
                                                    "ScratchPad-${DateTime.now().month}/${DateTime.now().day}-${DateTime.now().hour}:${DateTime.now().minute}",
                                                isi: isi.text)));
                                    addScratchPad(isi: "");
                                  },
                                  child: Icon(
                                    Icons.navigate_next,
                                    color: primaryColor, // size: 23,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection(
                                    'users/${currentUser?.uid}/scratch-pad')
                                .doc('scratch-pad')
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              var userDocument = snapshot.data;
                              String? teks;

                              if (snapshot.data?.exists == false) {
                                teks = 'Tulis sesuatu...';
                              } else if (snapshot.hasData) {
                                teks = userDocument?['content'];
                              }
                              TextEditingController isi =
                                  TextEditingController(text: teks);
                              // bool read = false;
                              // TextEditingController isi = TextEditingController(
                              //   text: userDocument?['content'] ??
                              //       'Tulis sesuatu...',
                              // );
                              // TextEditingController isi =
                              //     TextEditingController();
                              // @override
                              // void initState() {
                              //   super.initState();
                              //   isi.text = userDocument?['content'] ?? '';
                              // }

                              return Container(
                                height: 150,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  // color: Colors.yellow.shade300
                                  border: Border.all(
                                    color: primaryColor,
                                    width: 2,
                                  ),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: GestureDetector(
                                    // onDoubleTap: () {
                                    //   setState(() {
                                    //     read = !read;
                                    //   });
                                    // },
                                    child: TextField(
                                      controller: isi,
                                      onTap: () {
                                        Future.delayed(
                                            Duration(milliseconds: 250), () {
                                          addScratchPad(isi: isi.text);
                                        });
                                      },
                                      // onChanged: (text) {
                                      //   Future.delayed(Duration(seconds: 5),
                                      //       () {
                                      //     addScratchPad(isi: text);
                                      //   });
                                      // },
                                      enabled: true,
                                      maxLines: null,
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: "Tulis sesuatu...",
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
                  ),

                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Row(
                  //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //         children: [
                  //           const Text("Notebook Kamu"),
                  //           GestureDetector(
                  //             onTap: () {
                  //               Navigator.pushNamed(context, '/notebook-list');
                  //             },
                  //             child: const Icon(
                  //               Icons.navigate_next,
                  //               size: 23,
                  //             ),
                  //           )
                  //         ],
                  //       ),
                  //       const SizedBox(
                  //         height: 10,
                  //       ),
                  //       Container(
                  //         // constraints: const BoxConstraints(
                  //         //   minHeight: 150.0,
                  //         //   maxHeight: 400.0,
                  //         // ),
                  //         child: StreamBuilder(
                  //           stream: getNotebooks(
                  //               uid: FirebaseAuth.instance.currentUser?.uid),
                  //           builder: (BuildContext context,
                  //               AsyncSnapshot<QuerySnapshot> snapshot) {
                  //             if (snapshot.hasError) {
                  //               return Text('Error: ${snapshot.error}');
                  //             } else if (snapshot.hasData &&
                  //                 snapshot.data?.size == 0) {
                  //               return const Center(
                  //                 child: Text(
                  //                   "Kamu tidak memiliki Notebook apapun! Sentuh tombol \"+\" dibawah untuk membuat catatan dan beri nama Notebookmu!",
                  //                   textAlign: TextAlign.center,
                  //                 ),
                  //               );
                  //             } else if (snapshot.connectionState ==
                  //                 ConnectionState.waiting) {
                  //               return const Center(
                  //                 child: CircularProgressIndicator(),
                  //               );
                  //             } else {
                  //               return Wrap(
                  //                 // physics: NeverScrollableScrollPhysics(),
                  //                 children: [
                  //                   Center(
                  //                     child: Wrap(
                  //                       alignment: WrapAlignment.start,
                  //                       crossAxisAlignment:
                  //                           WrapCrossAlignment.center,
                  //                       // scrollDirection: Axis.horizontal,
                  //                       // shrinkWrap: true,
                  //                       children: snapshot.data!.docs
                  //                           .map((DocumentSnapshot document) {
                  //                         Map<String, dynamic> notebooks =
                  //                             document.data()!
                  //                                 as Map<String, dynamic>;
                  //                         // var color = Colors.yellow.shade200;
                  //                         // if (notebooks['theme'] == null ||
                  //                         //     notebooks['theme'] == "default") {
                  //                         //   color = color;
                  //                         // } else if (notebooks['theme'] ==
                  //                         //     "blue") {
                  //                         //   color = Colors.blue.shade200;
                  //                         // }
                  //                         return Wrap(
                  //                           crossAxisAlignment:
                  //                               WrapCrossAlignment.center,
                  //                           children: [
                  //                             GestureDetector(
                  //                               onTap: () {
                  //                                 Navigator.push(
                  //                                     context,
                  //                                     MaterialPageRoute(
                  //                                         builder: ((context) =>
                  //                                             ReadNotebooksPage(
                  //                                               notebooksName:
                  //                                                   notebooks[
                  //                                                       'Notebook'],
                  //                                               // notebooksTheme:
                  //                                               //     notebooks[
                  //                                               //         'theme'],
                  //                                             ))));
                  //                               },
                  //                               child: Container(
                  //                                 margin:
                  //                                     const EdgeInsets.fromLTRB(
                  //                                         0, 8, 8, 8),
                  //                                 height: 150,
                  //                                 width: 150,
                  //                                 decoration: BoxDecoration(
                  //                                   borderRadius:
                  //                                       BorderRadius.circular(
                  //                                           10),
                  //                                   color:
                  //                                       Colors.yellow.shade300,
                  //                                 ),
                  //                                 child: Padding(
                  //                                   padding:
                  //                                       const EdgeInsets.all(
                  //                                           10.0),
                  //                                   child: Column(
                  //                                     mainAxisAlignment:
                  //                                         MainAxisAlignment
                  //                                             .center,
                  //                                     crossAxisAlignment:
                  //                                         CrossAxisAlignment
                  //                                             .center,
                  //                                     children: [
                  //                                       Center(
                  //                                         child: Text(
                  //                                           notebooks[
                  //                                               'Notebook'],
                  //                                           style:
                  //                                               const TextStyle(
                  //                                             fontSize: 18,
                  //                                             fontWeight:
                  //                                                 FontWeight
                  //                                                     .w700,
                  //                                           ),
                  //                                         ),
                  //                                       ),
                  //                                       // const SizedBox(
                  //                                       //   height: 10,
                  //                                       // ),
                  //                                       // Text(
                  //                                       //   notes['content'],
                  //                                       //   overflow: TextOverflow.ellipsis,
                  //                                       // ),
                  //                                     ],
                  //                                   ),
                  //                                 ),
                  //                               ),
                  //                             ),
                  //                             const SizedBox(
                  //                               width: 15,
                  //                             ),
                  //                           ],
                  //                         );
                  //                       }).toList(),
                  //                     ),
                  //                   ),
                  //                 ],
                  //               );
                  //             }
                  //           },
                  //         ),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavCreate(
          scaffoldKey: _scaffoldKey,
          page: "Home",
        ),
        drawer: DrawerWidget(
          pageActive: "Home",
        ));
  }
}
