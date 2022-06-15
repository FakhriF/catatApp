import 'package:catat_app/page/notes-notebook/add_noted.dart';
import 'package:catat_app/appbar-navbar.dart';
import 'package:catat_app/firestore.dart';
import 'package:catat_app/page/notes-notebook/notebooks_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../my_flutter_app_icons.dart';

class NotesListPage extends StatefulWidget {
  const NotesListPage({Key? key}) : super(key: key);

  @override
  State<NotesListPage> createState() => NotesListPageState();
}

class NotesListPageState extends State<NotesListPage> {
  TextEditingController notebooks = TextEditingController();

  Stream<QuerySnapshot> getNotes(
      {required String? uid, required String notebook}) {
    return FirebaseFirestore.instance
        .collection('users/$uid/notes')
        .orderBy('time', descending: true)
        .snapshots();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          toolbarHeight: 100,
          flexibleSpace: const AppBarA(
            title: "Catatan",
          ),
        ),
        bottomNavigationBar:
            BottomNavCreate(scaffoldKey: _scaffoldKey, page: "Catatan"),
        key: _scaffoldKey,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: ScrollPhysics(),
            child: Column(
              children: [
                // Container(
                //   height: 70,
                //   width: MediaQuery.of(context).size.width,
                //   decoration: const BoxDecoration(
                //     border: Border(
                //       bottom: BorderSide(
                //         color: Colors.grey,
                //         width: 1,
                //       ),
                //     ),
                //   ),
                //   child: const Padding(
                //     padding: EdgeInsets.only(left: 10.0, top: 26),
                //     child: Text(
                //       "Catatan",
                //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                //     ),
                //   ),
                // ),
                StreamBuilder(
                    stream: getNotes(
                        uid: FirebaseAuth.instance.currentUser?.uid,
                        notebook: notebooks.text),
                    builder: (
                      BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot,
                    ) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: Text(
                              "Oops! Tidak ada catatan ditemukan! Jika menurut Kamu ini merupakan kesalahan, silahkan hubungi developer."),
                        );
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasData && snapshot.data?.size == 0) {
                        return const Padding(
                          padding: EdgeInsets.fromLTRB(16.0, 50, 16, 16),
                          child: Center(
                            child: Text(
                              "Kamu tidak memiliki Catatan pada Notebook ini! Silahkan klik \"+\" lalu ubah \"My Notebook\" ke nama yang Kamu inginkan!\n\nJika menurut Kamu ini merupakan kesalahan, silahkan hubungi developer. ",
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      } else {
                        return SizedBox(
                          // height: MediaQuery.of(context).size.height - 110,
                          child: ListView(
                            physics: NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              Map<String, dynamic> notes =
                                  document.data()! as Map<String, dynamic>;
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: ((context) =>
                                                  ReadNotesPage(
                                                      notes: notes))));
                                    },
                                    child: Container(
                                      height: 150,
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                          width: 0.07,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  notes['title'],
                                                  style: const TextStyle(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  notes['content'],
                                                  maxLines: 4,
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade500),
                                                  // overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "Last Modified : ${notes['timeModif']}",
                                              style: TextStyle(
                                                  color: Colors.grey.shade500),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 15,
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        );
                      }
                    }),
              ],
            ),
          ),
        ),
        drawer: const DrawerWidget(
          pageActive: "Catatan",
        ));
  }
}

class NotebookListPage extends StatefulWidget {
  const NotebookListPage({Key? key}) : super(key: key);

  @override
  State<NotebookListPage> createState() => _NotebookListPageState();
}

class _NotebookListPageState extends State<NotebookListPage> {
  Stream<QuerySnapshot> getNotebooks({required String? uid}) {
    return FirebaseFirestore.instance
        .collection('users/$uid/notebooks')
        .orderBy('Notebook', descending: false)
        .snapshots();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: AppBar(
        //   title: const Text("Notebooks"),
        //   backgroundColor: Colors.yellow.shade300,
        //   foregroundColor: Colors.black,
        //   actions: [
        //     IconButton(
        //       icon: const Icon(Icons.add),
        //       onPressed: () {
        //         createNotebook(context: context);
        //       },
        //     ),
        //   ],
        // ),
        bottomNavigationBar:
            BottomNavCreate(scaffoldKey: _scaffoldKey, page: "Buku Catatan"),
        appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            toolbarHeight: 100,
            flexibleSpace: AppBarA(title: "Buku Catatan")),
        key: _scaffoldKey,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              // physics: NeverScrollableScrollPhysics(),
              children: [
                // Container(
                //   height: 70,
                //   width: MediaQuery.of(context).size.width,
                //   decoration: const BoxDecoration(
                //     border: Border(
                //       bottom: BorderSide(
                //         color: Colors.grey,
                //         width: 1,
                //       ),
                //     ),
                //   ),
                //   child: const Padding(
                //     padding: EdgeInsets.only(left: 10.0, top: 26),
                //     child: Text(
                //       "Buku Catatan",
                //       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                //     ),
                //   ),
                // ),
                SizedBox(
                  // height: MediaQuery.of(context).size.height * 1,
                  child: SingleChildScrollView(
                    physics: ScrollPhysics(),
                    child: Column(
                      children: [
                        StreamBuilder(
                          stream: getNotebooks(
                              uid: FirebaseAuth.instance.currentUser?.uid),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else if (snapshot.hasData &&
                                snapshot.data?.size == 0) {
                              return const Center(
                                child: Text(
                                  "Kamu tidak memiliki Notebook apapun! Sentuh tombol \"+\" dibawah untuk membuat catatan dan beri nama Notebookmu!",
                                  textAlign: TextAlign.center,
                                ),
                              );
                            } else if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return SizedBox(
                                // height: MediaQuery.of(context).size.height * 0.75,
                                child: ListView(
                                  // alignment: WrapAlignment.start,
                                  // crossAxisAlignment: WrapCrossAlignment.center,
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  children: snapshot.data!.docs
                                      .map((DocumentSnapshot document) {
                                    Map<String, dynamic> notebooks = document
                                        .data()! as Map<String, dynamic>;
                                    return GestureDetector(
                                      onLongPress: () {
                                        alertDialogNotebookDelete(
                                            context: context,
                                            notebook: notebooks['Notebook']);
                                      },
                                      child: ListTile(
                                        leading: Image.asset(
                                          "assets/icons/Notebook_ico.png",
                                          // color: Colors.grey,
                                          width: 20,
                                        ),
                                        title: Text(notebooks['Notebook']),
                                        subtitle: Text(
                                            "Terakhir Diubah : ${notebooks['timeModif']}"),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: ((context) =>
                                                  ReadNotebooksPage(
                                                    notebooksName:
                                                        notebooks['Notebook'],
                                                    // notebooksTheme: notebooks['theme'],
                                                  )),
                                            ),
                                          );
                                        },
                                      ),
                                    );
                                  }).toList(),
                                ),
                              );
                            }
                          },
                        ),
                        ListTile(
                          leading: const Icon(
                            CatatAppIcons.add_notebook,
                            size: 25,
                            color: Color.fromRGBO(18, 212, 146, 1),
                          ),
                          title: Text(
                            "Tambah Buku Catatan",
                            style: TextStyle(
                                color: Color.fromRGBO(18, 212, 146, 1)),
                          ),
                          onTap: () {
                            createNotebook(context: context);
                          },
                        ),
                        SizedBox(
                          height: 20,
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        drawer: DrawerWidget(
          pageActive: "Buku Catatan",
        ));
  }
}

Future<void> createNotebook({required context}) {
  TextEditingController notebook = TextEditingController();
  return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Buat Notebook'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                TextField(
                  controller: notebook,
                  decoration: const InputDecoration(
                    labelText: 'Nama Notebook',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () {
                addNotebooks(
                    notebook: notebook.text,
                    uid: FirebaseAuth.instance.currentUser?.uid);
                Navigator.pop(context);
              },
              child: const Text("Buat"),
            ),
          ],
        );
      });
}
