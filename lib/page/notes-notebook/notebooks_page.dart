import 'package:catat_app/page/notes-notebook/add_noted.dart';
import 'package:catat_app/appbar-navbar.dart';
import 'package:catat_app/authentication.dart';
import 'package:catat_app/firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReadNotebooksPage extends StatefulWidget {
  const ReadNotebooksPage({
    required this.notebooksName,
    // required this.notebooksTheme,
    Key? key,
  }) : super(key: key);

  final notebooksName;
  // final notebooksTheme;
  @override
  State<ReadNotebooksPage> createState() => ReadNotebooksPageState();
}

class ReadNotebooksPageState extends State<ReadNotebooksPage> {
  TextEditingController notebooks = TextEditingController();
  TextEditingController notebookstheme = TextEditingController();
  @override
  void initState() {
    super.initState();
    notebooks.text = widget.notebooksName;
    // notebookstheme.text = widget.notebooksTheme;
  }

  Stream<QuerySnapshot> getNotes(
      {required String? uid, required String notebook}) {
    return FirebaseFirestore.instance
        .collection('users/$uid/notes')
        .orderBy('time', descending: true)
        .where('label', isEqualTo: notebook)
        .snapshots();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  // var color = Colors.yellow.shade300;

  @override
  Widget build(BuildContext context) {
    // if (notebookstheme.text == null ||
    //     notebookstheme.text == "default" ||
    //     widget.notebooksTheme == null) {
    //   color = color;
    // } else if (notebookstheme.text == "blue") {
    //   color = Colors.blue.shade300;
    // }
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(notebooks.text),
      //   backgroundColor: Colors.yellow.shade300,
      //   foregroundColor: Colors.black,
      //   elevation: 0.5,
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.add),
      //       onPressed: () {
      //         Navigator.push(
      //             context,
      //             MaterialPageRoute(
      //                 builder: ((context) => AddNotesPage(
      //                       labels: notebooks.text,
      //                     ))));
      //       },
      //     ),
      //     IconButton(
      //       icon: Icon(Icons.delete),
      //       onPressed: () {
      //         alertDialogNotebookDelete(
      //             context: context, notebook: notebooks.text);
      //       },
      //     ),
      //   ],
      // ),
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          toolbarHeight: 100,
          flexibleSpace: AppBarA(title: notebooks.text)),
      bottomNavigationBar:
          BottomNavCreate(scaffoldKey: _scaffoldKey, page: notebooks.text),
      key: _scaffoldKey,
      body: SingleChildScrollView(
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
            //   child: Padding(
            //     padding: const EdgeInsets.only(left: 10.0, top: 15),
            //     // child:
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
                      height: MediaQuery.of(context).size.height - 110,
                      child: ListView(
                        // physics: NeverScrollableScrollPhysics(),
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
                                              ReadNotesPage(notes: notes))));
                                },
                                child: Container(
                                  height: 150,
                                  width: MediaQuery.of(context).size.width,
                                  // decoration: BoxDecoration(
                                  //   borderRadius: BorderRadius.circular(10),
                                  //   color: Colors.yellow.shade300,
                                  // ),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 0.07,
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Column(
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
                                                // overflow: TextOverflow.clip,
                                              ),
                                            ],
                                          ),
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
      drawer: const DrawerWidget(pageActive: "Notebook"),
    );
  }
}

Future<void> addNotebookAlert({required context}) {
  TextEditingController newNotebook = TextEditingController();
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
                controller: newNotebook,
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
              if (newNotebook.text.isEmpty) {
                final snackBar = SnackBar(
                  backgroundColor: Colors.red.shade300,
                  content: const Text(
                    'Hey, Kamu gak punya nama? Bisa cek KTP ya klo lupa!',
                    style: TextStyle(color: Colors.black),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } else {
                addNotebooks(notebook: newNotebook.text, uid: currentUser?.uid);
                Navigator.pop(context);
              }
            },
            child: const Text("Ubah"),
          ),
        ],
      );
    },
  );
}

Future<void> alertDialogNotebookDelete({required context, required notebook}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Hapus $notebook ?'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                  'Kamu yakin ingin menghapus Notebook \"$notebook\" ini? Perlu diingat menghapus Notebook ini sama dengan menghapus seluruh catatan yang ada di Notebook ini.'),
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
              FirebaseFirestore.instance
                  .collection(
                      'users/${FirebaseAuth.instance.currentUser?.uid}/notebooks')
                  .doc(notebook)
                  .delete();
              FirebaseFirestore.instance
                  .collection(
                      "users/${FirebaseAuth.instance.currentUser?.uid}/notes")
                  .where("label", isEqualTo: notebook)
                  .get()
                  .then((value) {
                value.docs.forEach((element) {
                  FirebaseFirestore.instance
                      .collection(
                          "users/${FirebaseAuth.instance.currentUser?.uid}/notes")
                      .doc(element.id)
                      .delete()
                      .then((value) {
                    print("Success!");
                  });
                });
              });
              final snackBar = SnackBar(
                backgroundColor: Colors.yellow.shade300,
                content: const Text(
                  'Notebook dan Seluruh Catatan yang ada di Notebook ini telah dihapus!',
                  style: TextStyle(color: Colors.black),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              Navigator.pop(context);
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}
