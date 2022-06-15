import 'dart:async';

import 'package:catat_app/authentication.dart';
import 'package:catat_app/colors.dart';
import 'package:catat_app/firestore.dart';
import 'package:catat_app/page/loading_page.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BantuanListPage extends StatefulWidget {
  BantuanListPage({Key? key}) : super(key: key);

  @override
  State<BantuanListPage> createState() => _BantuanListPageState();
}

class _BantuanListPageState extends State<BantuanListPage> {
  var dataList;

  @override
  void initState() {
    dataList = FirebaseFirestore.instance
        .collection('help')
        .where('uid', isEqualTo: currentUser?.uid)
        .orderBy('time', descending: true)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Bantuan"),
          foregroundColor: primaryColor,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Stream(
          userAct: "General",
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: primaryColor,
          child: Icon(Icons.help_outline_rounded),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BantuanPage(),
              ),
            );
          },
        ));
  }
}

// class Future extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     // <1> Use FutureBuilder
//     return FutureBuilder<QuerySnapshot>(
//         // <2> Pass `Future<QuerySnapshot>` to future
//         future: FirebaseFirestore.instance.collection('posts').get(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             // <3> Retrieve `List<DocumentSnapshot>` from snapshot
//             final List<DocumentSnapshot> documents = snapshot.data!.docs;
//             return ListView(
//                 children: documents
//                     .map((doc) => Card(
//                           child: ListTile(
//                             title: Text(doc['text']),
//                             subtitle: Text(doc['email']),
//                           ),
//                         ))
//                     .toList());
//           } else {
//             return Text('It\'s Error!');
//           }
//         });
//   }
// }

class Stream extends StatelessWidget {
  Stream({
    required this.userAct,
    Key? key,
  }) : super(key: key);

  String userAct;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: userAct == "General"
          ? getHelpListUser(uid: currentUser?.uid)
          : getHelpListCrew(),
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot> snapshot,
      ) {
        if (snapshot.hasData) {
          return SizedBox(
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> notes =
                    document.data()! as Map<String, dynamic>;
                return ListTile(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: ((context) => BantuanDetailPage(
                                  dataBantuan: notes,
                                  userAct: userAct,
                                ))));
                  },
                  leading: const Icon(Icons.question_answer_rounded),
                  title: Text(notes['CaseID'] ?? "Loading..."),
                  subtitle: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.circle,
                        size: 8,
                        color: notes['status'] == "OPEN"
                            ? Colors.green
                            : Colors.red,
                      ),
                      Text(" ${notes['status']}",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: notes['status'] == "OPEN"
                                  ? Colors.green
                                  : Colors.red)),
                    ],
                  ),
                );
              }).toList(),
            ),
          );
          // if (!snapshot.hasData) {
          // return Row(
          //   crossAxisAlignment: CrossAxisAlignment.center,
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Center(
          //       child: SizedBox(
          //         width: MediaQuery.of(context).size.width * 0.5,
          //         child: Text(
          //           "Kamu belum pernah meminta Bantuan! Silahkan klik tombol dibawah ini untuk meminta Bantuan.",
          //           textAlign: TextAlign.center,
          //         ),
          //       ),
          //     ),
          //   ],
          // );
        } else if (snapshot.hasError) {
          return Center(
            child: Text("Error: ${snapshot.error}"),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasData && snapshot.data?.size == 0) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Center(
                child: Text(
                  "Kamu belum pernah meminta Bantuan! Silahkan klik tombol dibawah ini untuk meminta Bantuan.",
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );
        } else {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    "Kamu belum pernah meminta Bantuan! Silahkan klik tombol dibawah ini untuk meminta Bantuan.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          );
          // return SizedBox(
          //   child: ListView(
          //     physics: NeverScrollableScrollPhysics(),
          //     scrollDirection: Axis.vertical,
          //     shrinkWrap: true,
          //     children: snapshot.data!.docs.map((DocumentSnapshot document) {
          //       Map<String, dynamic> notes =
          //           document.data()! as Map<String, dynamic>;
          //       return ListTile(
          //         onTap: () => print('Tapped'),
          //         trailing: Icon(Icons.question_answer_rounded),
          //         title: Text(notes['title'] ?? "Loading..."),
          //         subtitle: Text(notes['status'] ?? "Loading"),
          //       );
          //     }).toList(),
          //   ),
          // );
        }
      },
    );
  }
}

class BantuanDetailPage extends StatelessWidget {
  BantuanDetailPage(
      {required this.userAct, required this.dataBantuan, Key? key})
      : super(key: key);
  final dataBantuan;
  String userAct;
  TextEditingController chat = TextEditingController();
  bool status = true;

  @override
  Widget build(BuildContext context) {
    if (dataBantuan['status'] == "OPEN") {
      status = true;
    } else {
      status = false;
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text("Detail"),
          foregroundColor: primaryColor,
          backgroundColor: Colors.white,
          elevation: 0,
          actions: userAct == "Crew"
              ? [
                  //icon horizontal circle dot
                  IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: Column(
                                children: [
                                  ListTile(
                                    leading:
                                        const Icon(Icons.dangerous_rounded),
                                    title: const Text("Tutup Tiket"),
                                    onTap: () {
                                      updateHelpStatus(
                                          status: "CLOSED",
                                          caseID: dataBantuan['CaseID']);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.refresh),
                                    title: const Text("Re-Buka Tiket"),
                                    onTap: () {
                                      updateHelpStatus(
                                          status: "OPEN",
                                          caseID: dataBantuan['CaseID']);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(
                                        Icons.delete_forever_rounded),
                                    title: const Text("Hapus Tiket (30 hari)"),
                                    onTap: () {
                                      deleteHelpCase(
                                          caseID: dataBantuan['CaseID']);
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                  ),
                ]
              : [],
        ),
        backgroundColor: Colors.grey[100],
        resizeToAvoidBottomInset: true,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.82,
              child: ListView(
                // physics: const NeverScrollableScrollPhysics(),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          dataBantuan['title'],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Case ID : ${dataBantuan['CaseID']}",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 12),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.circle,
                              size: 8,
                              color: dataBantuan['status'] == "OPEN"
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            Text(
                              " ${dataBantuan['status']}",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: dataBantuan['status'] == "OPEN"
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Text(dataBantuan['detail']),
                        const SizedBox(
                          height: 30,
                        ),
                        const Center(
                          child: Text(
                            "=============== BALASAN AKAN ADA DI BAWAH ===============",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    ),
                  ),
                  //read chat
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 24.0, right: 24.0, bottom: 0),
                    child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection("help")
                          .where("CaseID", isEqualTo: dataBantuan['CaseID'])
                          .orderBy("time", descending: true)
                          .snapshots(),
                      builder: (
                        BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot,
                      ) {
                        if (snapshot.hasData) {
                          var i = 0;
                          return ListView(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            children: snapshot.data!.docs.map((chat) {
                              return ListView(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                children: List.generate(
                                  List.from(chat['chat']).length,
                                  (i) {
                                    if (chat['chat'][i]['user'] ==
                                            currentUser?.displayName ||
                                        chat['chat'][i]['user'] ==
                                            "CS - ${currentUser?.displayName}") {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            chat['chat'][i]['user'],
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            decoration: BoxDecoration(
                                              color: userChatColor,
                                              borderRadius:
                                                  const BorderRadius.only(
                                                topLeft: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                chat['chat'][i]['chat']
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "${chat['chat'][i]['time'].toString().substring(11, 16)}"
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      );
                                    } else {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            chat['chat'][i]['user'],
                                            style: const TextStyle(
                                                fontSize: 13,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),

                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.only(
                                                topRight: Radius.circular(10),
                                                bottomLeft: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10),
                                              ),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Text(
                                                chat['chat'][i]['chat']
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            "${chat['chat'][i]['time'].toString().substring(11, 16)}"
                                                .toString(),
                                            style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          // ListTile(
                                          //   title: Text(chat['chat'][i]['chat']
                                          //       .toString()),
                                          //   subtitle: Text(
                                          //       "${chat['chat'][i]['time'].toString().substring(11, 16)}"
                                          //           .toString()),
                                          // ),
                                        ],
                                      );
                                    }
                                  },
                                ),
                              );
                            }).toList(),
                          );
                        } else if (snapshot.hasError) {
                          TextEditingController error = TextEditingController(
                              text: snapshot.error.toString());
                          return Center(
                            // child: Text("Error: ${snapshot.error}"),
                            child: TextField(
                              controller: error,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Tulis Pesan",
                              ),
                            ),
                          );
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasData &&
                            snapshot.data?.size == 0) {
                          return const Center(
                            child: Text(
                                "Kami akan mengirim pesan secepatnya! Mohon tunggu sesaat..."),
                          );
                        } else if (!snapshot.hasData) {
                          return const Center(
                            child: Text(
                                "Kami akan mengirim pesan secepatnya! Mohon tunggu sesaat..."),
                          );
                        } else {
                          return const Center(
                            child: Text("No data"),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (status) ...[
              Padding(
                padding: const EdgeInsets.only(
                    left: 24.0, right: 24.0, bottom: 24.0),
                child: Row(
                  children: [
                    Container(
                      height: 75,
                      width: MediaQuery.of(context).size.width * 0.8 - 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        // color: Colors.yellow.shade300
                        border: Border.all(
                          color: primaryColor,
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: GestureDetector(
                          child: TextField(
                            controller: chat,
                            enabled: true,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: "Silahkan Tulis Pesan Disini~",
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),

                    //send icon woth container background color green and circle
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: primaryColor,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          chatHelp(
                              userAct: userAct,
                              caseID: dataBantuan['CaseID'],
                              chatText: chat.text);
                          chat.clear();
                        },
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ] else ...[
              Padding(
                padding: const EdgeInsets.only(
                    left: 24.0, right: 24.0, bottom: 24.0),
                child: Row(
                  children: [
                    Container(
                      height: 75,
                      width: MediaQuery.of(context).size.width * 0.8 - 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        // color: Colors.yellow.shade300
                        border: Border.all(
                          color: primaryColor,
                          width: 2,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: GestureDetector(
                          child: TextField(
                            controller: chat,
                            enabled: false,
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText:
                                  "Kasus sudah ditutup, Kamu tidak bisa mengirim pesan",
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),

                    //send icon woth container background color green and circle
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: Colors.grey,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          // chatHelp(
                          //     caseID: dataBantuan['CaseID'], chatText: chat.text);
                          // chat.clear();
                        },
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ],
        ));
  }
}

class BantuanPage extends StatelessWidget {
  BantuanPage({Key? key}) : super(key: key);

  TextEditingController nama = TextEditingController();
  TextEditingController subjek = TextEditingController();
  TextEditingController detail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Input Bantuan"),
        foregroundColor: primaryColor,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: MediaQuery.of(context).size.width >= 1200
            ? EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.3,
                right: MediaQuery.of(context).size.width * 0.3)
            : const EdgeInsets.only(left: 35.0, right: 35.0),
        child: Column(
          children: [
            const SizedBox(height: 15),
            const Text(
              "Silahkan isi formulir ini secara lengkap dan benar, agar mudah diproses~!\nPertanyaan atau Permintaan Anda akan direspon melalui fitur Chat pada aplikasi ini! Mohon selalu cek status permintaan Anda di halaman Bantuan!\n\nTerima Kasih!",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 50),
            Column(
              children: [
                // TextField(
                //   controller: nama,
                //   decoration: InputDecoration(
                //     labelText: "Nama/Panggilan",
                //     hintText: "Contoh : Ko, Conan, Nao, dll",
                //     border: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(10),
                //       borderSide: BorderSide(
                //         color: primaryColor,
                //       ),
                //     ),
                //   ),
                // ),
                // const SizedBox(
                //   height: 30,
                // ),
                TextField(
                  controller: subjek,
                  decoration: InputDecoration(
                    labelText: "Subjek",
                    hintText:
                        "Contoh : Permintaan Menghapus Data, Permintaan Migrasi Data, dll",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextField(
                  controller: detail,
                  maxLines: 10,
                  decoration: InputDecoration(
                    labelText: "Detail",
                    hintText:
                        "Contoh : Saya ingin memindahkan seluruh data Saya ke email yang baru ini, apakah bisa?",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                if (
                    // nama.text.isEmpty ||
                    subjek.text.isEmpty || detail.text.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Formulir tidak lengkap!"),
                        content: const Text(
                            "Mohon isi formulir secara lengkap dan benar!"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "OK",
                              style: TextStyle(color: primaryColor),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  createHelp(
                      uid: currentUser?.uid,
                      name: currentUser?.displayName,
                      title: subjek.text,
                      detail: detail.text);
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Terima Kasih!"),
                        content: const Text(
                            "Pertanyaan atau permintaan Anda akan direspon melalui fitur Chat pada aplikasi ini! Mohon selalu cek status permintaan Anda di halaman Bantuan!"),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "OK",
                              style: TextStyle(color: primaryColor),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                }
              },
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
                    'Kirim!',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
