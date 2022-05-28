import 'package:catat_app/authentication.dart';
import 'package:catat_app/class.dart';
import 'package:catat_app/colors.dart';
import 'package:catat_app/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddNotes {
  final String judul;
  final String isi;
  final dynamic time;
  final String label;
  final String unotes;
  final String timeCreated;
  final String timeModif;
  // final String theme;
  AddNotes({
    required this.judul,
    required this.isi,
    required this.time,
    required this.label,
    required this.unotes,
    required this.timeCreated,
    required this.timeModif,
    // required this.theme,
  });

  Map<String, dynamic> toJson() => {
        'title': judul,
        'content': isi,
        'label': label,
        'time': time,
        'unotes': unotes,
        'timeCreated': timeCreated,
        'timeModif': timeModif,
        // 'theme': theme,
      };
}

Future addNotes({
  required String? uid,
  required String judul,
  required String isi,
  required String label,
}) async {
  final docUser = FirebaseFirestore.instance.collection('users/$uid/notes').doc(
      'notes-${DateTime.now().microsecondsSinceEpoch.toString()}${judul[0]}');
  final userData = AddNotes(
    // theme: "default",
    judul: judul,
    isi: isi,
    label: label,
    time: FieldValue.serverTimestamp(),
    unotes: docUser.id,
    timeCreated:
        "${DateTime.now().day.toString()}/${DateTime.now().month.toString()}/${DateTime.now().year.toString()}",
    timeModif:
        "${DateTime.now().day.toString()}/${DateTime.now().month.toString()}/${DateTime.now().year.toString()}",
  );

  final json = userData.toJson();

  await docUser.set(json);
}

class AddNotesPage extends StatefulWidget {
  AddNotesPage(
      {required this.labels, required this.judul, required this.isi, Key? key})
      : super(key: key);

  String labels;
  String judul;
  String isi;

  @override
  State<AddNotesPage> createState() => _AddNotesPageState();
}

// Stream<QuerySnapshot> getNotes({required String? uid, required String label}) {
//   return FirebaseFirestore.instance
//       .collection('users/$uid/notes')
//       .orderBy('time', descending: true)
//       .snapshots();
// }

// int Notesid = 0;

class _AddNotesPageState extends State<AddNotesPage> {
  TextEditingController label = TextEditingController();
  TextEditingController judul = TextEditingController();
  TextEditingController isi = TextEditingController();

  @override
  void initState() {
    super.initState();
    label.text = widget.labels;
    judul.text = widget.judul;
    isi.text = widget.isi;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: const Icon(Icons.check),
                      onTap: () {
                        if (judul.text.isNotEmpty && isi.text.isNotEmpty) {
                          // Notesid++;
                          addNotes(
                            label: label.text,
                            uid: FirebaseAuth.instance.currentUser?.uid,
                            judul: judul.text,
                            isi: isi.text,
                          );
                          addNotebooks(
                            notebook: label.text,
                            uid: FirebaseAuth.instance.currentUser?.uid,
                          );
                          final snackBar = SnackBar(
                            backgroundColor: Colors.yellow.shade300,
                            content: const Text(
                              'Catatan Kamu Ditambahkan!',
                              style: TextStyle(color: Colors.black),
                            ),
                            // action: SnackBarAction(
                            //   label: 'Undo',
                            //   onPressed: () {
                            //     // Some code to undo the change.
                            //   },
                            // ),
                          );

                          // Find the ScaffoldMessenger in the widget tree
                          // and use it to show a SnackBar.
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);

                          Navigator.pop(context);
                        } else {
                          final snackBar = SnackBar(
                            backgroundColor: Colors.yellow.shade300,
                            content: const Text(
                              'Oops! Catatan Kamu Tidak Tertambah!\n\nMohon isi Judul atau Isi Catatan!',
                              style: TextStyle(color: Colors.black),
                            ),
                            // action: SnackBarAction(
                            //   label: 'Undo',
                            //   onPressed: () {
                            //     // Some code to undo the change.
                            //   },
                            // ),
                          );

                          // Find the ScaffoldMessenger in the widget tree
                          // and use it to show a SnackBar.
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                    ),
                    GestureDetector(
                      child: const Icon(Icons.more_horiz),
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  controller: label,
                  decoration: const InputDecoration(
                    hintText: 'Label/Kategori',
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                TextField(
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  controller: judul,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Judul",
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: isi,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Mulai menulis",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ReadNotesPage extends StatefulWidget {
  const ReadNotesPage({required this.notes, Key? key}) : super(key: key);

  final notes;

  @override
  State<ReadNotesPage> createState() => _ReadNotesPageState();
}

class _ReadNotesPageState extends State<ReadNotesPage> {
  Future updateTheme({
    required String unotes,
    required String theme,
  }) async {
    await FirebaseFirestore.instance
        .collection('users/${FirebaseAuth.instance.currentUser?.uid}/notes')
        .doc(unotes)
        .update({
      'theme': theme,
    });
  }

  Future deleteNotes({
    required String? uid,
    required String time,
  }) async {
    await FirebaseFirestore.instance
        .collection('users/$uid/notes')
        .doc('notes-$time')
        .delete();
  }

  TextEditingController judul = TextEditingController();
  TextEditingController isi = TextEditingController();
  TextEditingController unotes = TextEditingController();
  TextEditingController label = TextEditingController();
  // TextEditingController theme = TextEditingController();
  TextEditingController timeCreated = TextEditingController();

  @override
  void initState() {
    super.initState();
    judul.text = widget.notes['title'];
    isi.text = widget.notes['content'];
    unotes.text = widget.notes['unotes'];
    label.text = widget.notes['label'];
    timeCreated.text = widget.notes['timeCreated'];

    // theme.text = widget.notes['theme'];
  }

  // bool colorVis = false;

  // var color = Colors.yellow.shade200;

  @override
  Widget build(BuildContext context) {
    // if (theme.text == null || theme.text == "default") {
    //   color = Colors.yellow.shade200;
    // } else if (theme.text == "blue") {
    //   color = Colors.blue.shade200;
    // } else if (theme.text == "green") {
    //   color = Colors.green.shade200;
    // } else if (theme.text == "red") {
    //   color = Colors.red.shade200;
    // }

    return Scaffold(
      // backgroundColor: color,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: Icon(
                        Icons.arrow_back_ios,
                        color: primaryColor,
                      ),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    Row(
                      children: [
                        // GestureDetector(
                        //   child: Icon(
                        //     Icons.color_lens,
                        //     // color: color,
                        //   ),
                        //   onTap: () {
                        //     setState(() {
                        //       colorVis = !colorVis;
                        //     });
                        //   },
                        // ),
                        // const SizedBox(
                        //   width: 30,
                        // ),
                        // GestureDetector(
                        //   child: Icon(
                        //     Icons.edit,
                        //     // color: color,
                        //   ),
                        //   onTap: () {
                        //     Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) =>
                        //             UpdateNotesPage(notes: widget.notes),
                        //       ),
                        //     );
                        //   },
                        // ),
                        // const SizedBox(
                        //   width: 30,
                        // ),
                        GestureDetector(
                          child: Icon(
                            Icons.delete,
                            color: primaryColor,
                          ),
                          onTap: () {
                            // deleteNotes(
                            //     uid: FirebaseAuth.instance.currentUser?.uid,
                            //     time: unotes.text);
                            // Navigator.pop(context);
                            showAlertDeleteDialog(
                                context: context,
                                // title: judul.text,
                                uid: FirebaseAuth.instance.currentUser?.uid,
                                unotes: unotes.text);
                          },
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.info_outline,
                            color: primaryColor,
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: ((context) => Notesinfo(
                                          dataNotes: widget.notes,
                                        ))));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                // Visibility(
                //     child: Container(
                //       color: Colors.grey.shade200,
                //       height: 35,
                //       padding: EdgeInsets.all(6),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //         children: [
                //           Text("Color (Experimental)",
                //               style: TextStyle(
                //                   fontSize: 12, fontWeight: FontWeight.w700)),
                //           Row(
                //             children: [
                //               GestureDetector(
                //                 onTap: () {
                //                   setState(() {
                //                     theme.text = "default";
                //                   });
                //                   updateTheme(
                //                       unotes: unotes.text, theme: theme.text);
                //                 },
                //                 child: Container(
                //                   height: 20,
                //                   width: 20,
                //                   color: Colors.yellow.shade300,
                //                 ),
                //               ),
                //               SizedBox(
                //                 width: 10,
                //               ),
                //               GestureDetector(
                //                 onTap: () {
                //                   setState(() {
                //                     theme.text = "blue";
                //                   });
                //                   updateTheme(
                //                       unotes: unotes.text, theme: theme.text);
                //                 },
                //                 child: Container(
                //                   height: 20,
                //                   width: 20,
                //                   color: Colors.blue.shade300,
                //                 ),
                //               ),
                //               SizedBox(
                //                 width: 10,
                //               ),
                //               GestureDetector(
                //                 onTap: () {
                //                   setState(() {
                //                     theme.text = "green";
                //                   });
                //                   updateTheme(
                //                       unotes: unotes.text, theme: theme.text);
                //                 },
                //                 child: Container(
                //                   height: 20,
                //                   width: 20,
                //                   color: Colors.green.shade300,
                //                 ),
                //               ),
                //               SizedBox(
                //                 width: 10,
                //               ),
                //               GestureDetector(
                //                 onTap: () {
                //                   setState(() {
                //                     theme.text = "red";
                //                   });
                //                   updateTheme(
                //                       unotes: unotes.text, theme: theme.text);
                //                 },
                //                 child: Container(
                //                   height: 20,
                //                   width: 20,
                //                   color: Colors.red.shade300,
                //                 ),
                //               ),
                //             ],
                //           )
                //         ],
                //       ),
                //     ),
                //     visible: colorVis),
                // const SizedBox(
                //   height: 20,
                // ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Label/Kategori',
                        border: InputBorder.none,
                      ),
                      controller: label,
                      onTap: () {
                        Future.delayed(const Duration(milliseconds: 500), () {
                          updateNotebooks(
                              notebook: judul.text,
                              uid: currentUser?.uid,
                              timeCreated: timeCreated.text);
                        });
                      },
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    // TextField(
                    //   style: const TextStyle(
                    //     fontSize: 12,
                    //     fontWeight: FontWeight.w700,
                    //   ),
                    //   controller: label,
                    //   decoration: const InputDecoration(
                    //     hintText: 'Label/Kategori',
                    //     border: InputBorder.none,
                    //   ),
                    // ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Judul',
                        border: InputBorder.none,
                      ),
                      controller: judul,
                      maxLines: null,
                      onTap: () {
                        Future.delayed(Duration(seconds: 1), () {
                          updateNotes(
                              uid: currentUser?.uid,
                              unotes: unotes.text,
                              judul: judul.text,
                              isi: isi.text,
                              label: label.text);
                        });
                      },
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    // TextField(
                    //   style: const TextStyle(
                    //     fontSize: 18,
                    //     fontWeight: FontWeight.w700,
                    //   ),
                    //   controller: judul,
                    //   maxLines: null,
                    //   decoration: const InputDecoration(
                    //     border: InputBorder.none,
                    //     hintText: "Judul",
                    //   ),
                    // ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Mulai Menulis',
                        border: InputBorder.none,
                      ),
                      maxLines: null,
                      controller: isi,
                      onTap: () {
                        Future.delayed(Duration(seconds: 1), () {
                          updateNotes(
                              uid: currentUser?.uid,
                              unotes: unotes.text,
                              judul: judul.text,
                              isi: isi.text,
                              label: label.text);
                        });
                      },
                      style: const TextStyle(
                        fontSize: 14,
                        // fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                // TextField(
                //   controller: isi,
                //   maxLines: null,
                //   decoration: const InputDecoration(
                //     border: InputBorder.none,
                //     hintText: "Mulai menulis",
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class UpdateNotesPage extends StatefulWidget {
  const UpdateNotesPage({required this.notes, Key? key}) : super(key: key);

  final notes;

  @override
  State<UpdateNotesPage> createState() => _UpdateNotesPageState();
}

class _UpdateNotesPageState extends State<UpdateNotesPage> {
  TextEditingController judul = TextEditingController();
  TextEditingController isi = TextEditingController();
  TextEditingController unotes = TextEditingController();
  TextEditingController label = TextEditingController();
  TextEditingController timeCreated = TextEditingController();

  @override
  void initState() {
    super.initState();
    judul.text = widget.notes['title'];
    isi.text = widget.notes['content'];
    unotes.text = widget.notes['unotes'];
    label.text = widget.notes['label'];
    timeCreated.text = widget.notes['timeCreated'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      child: const Icon(Icons.check),
                      onTap: () {
                        if (judul.text.isNotEmpty && isi.text.isNotEmpty) {
                          updateNotes(
                              isi: isi.text,
                              judul: judul.text,
                              label: label.text,
                              uid: FirebaseAuth.instance.currentUser?.uid,
                              unotes: unotes.text);
                          updateNotebooks(
                            timeCreated: timeCreated.text,
                            notebook: label.text,
                            uid: FirebaseAuth.instance.currentUser?.uid,
                          );
                          final snackBar = SnackBar(
                            backgroundColor: Colors.yellow.shade300,
                            content: const Text(
                              'Catatan Kamu Telah Diubah!',
                              style: TextStyle(color: Colors.black),
                            ),
                          );

                          ScaffoldMessenger.of(context).showSnackBar(snackBar);

                          Navigator.pop(context);
                          Navigator.pushReplacementNamed(context, '/home');
                        } else {
                          final snackBar = SnackBar(
                            backgroundColor: Colors.yellow.shade300,
                            content: const Text(
                              'Oops! Catatan Kamu Tidak Tertambah!\n\nMohon isi Judul atau Isi Catatan!',
                              style: TextStyle(color: Colors.black),
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }
                      },
                    ),
                    GestureDetector(
                      child: const Icon(Icons.more_horiz),
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                TextField(
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                  controller: label,
                  decoration: const InputDecoration(
                    hintText: 'Label/Kategori',
                    border: InputBorder.none,
                  ),
                ),
                const SizedBox(
                  height: 1,
                ),
                TextField(
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  controller: judul,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Judul",
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                TextField(
                  controller: isi,
                  maxLines: null,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Mulai menulis",
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future deleteNotes({
  required String? uid,
  required String unotes,
}) async {
  await FirebaseFirestore.instance
      .collection('users/$uid/notes')
      .doc(unotes)
      .delete();
}

Future<void> showAlertDeleteDialog({
  required context,
  // required String title,
  required String? uid,
  required String unotes,
}) async {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Peringatan'),
        content: const Text('Anda yakin ingin menghapus catatan ini?'),
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
              deleteNotes(uid: uid, unotes: unotes);
              Navigator.pushReplacementNamed(context, '/home');
              final snackBar = SnackBar(
                backgroundColor: Colors.yellow.shade300,
                content: const Text(
                  'Catatan Kamu Dihapus!',
                  style: TextStyle(color: Colors.black),
                ),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
        ],
      );
    },
  );
}

class Notesinfo extends StatelessWidget {
  const Notesinfo({required this.dataNotes, Key? key}) : super(key: key);

  final dataNotes;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.close,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "Note Info",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    dataNotes['title'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  //Notebook
                  const Text(
                    "Notebook",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    dataNotes['label'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //Dibuat
                  const Text(
                    "Dibuat",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    dataNotes['timeCreated'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //Dibuat Oleh
                  const Text(
                    "Dibuat Oleh",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${FirebaseAuth.instance.currentUser?.displayName}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //Update
                  const Text(
                    "Diperbaharui",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    dataNotes['timeModif'],
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //Update by
                  const Text(
                    "Diperbaharui Oleh",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "${FirebaseAuth.instance.currentUser?.displayName}",
                    style: const TextStyle(
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      )),
    );
  }
}
