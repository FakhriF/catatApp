import 'package:catat_app/authentication.dart';
import 'package:catat_app/page/home_page.dart';
import 'package:catat_app/page/notes-notebook/add_noted.dart';
import 'package:catat_app/page/notes-notebook/note_book_list_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DekstopHomePage extends StatefulWidget {
  DekstopHomePage({Key? key}) : super(key: key);

  @override
  State<DekstopHomePage> createState() => _DekstopHomePageState();
}

class _DekstopHomePageState extends State<DekstopHomePage> {
  int _currentPageIndex = 0;

  final pages = [HomeWidget(), DekstopNotesListWidget(), NotebookListWidget()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.black,
              child: Center(
                child: ListView(
                  children: [
                    ListTile(
                      leading: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .doc(currentUser?.uid)
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<DocumentSnapshot> snapshot) {
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
                      title: Text(
                        "${currentUser?.displayName}",
                        style: TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        "${currentUser?.email}",
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/account');
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.home, color: Colors.white),
                      title: const Text(
                        'Beranda',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        setState(() {
                          _currentPageIndex = 0;
                        });

                        //   if (pageActive == "Home") {
                        //     Navigator.pop(context);
                        //   \} else {
                        //     Navigator.pushNamed(context, '/home');
                        //   \}
                      },
                    ),
                    ListTile(
                      leading: Image.asset(
                        "assets/icons/Notes_ico.png",
                        width: 20,
                        color: Colors.white,
                      ),
                      title: const Text(
                        'Catatan',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        setState(() {
                          _currentPageIndex = 1;
                        });
                        // if (pageActive == "Catatan") {
                        //   Navigator.pop(context);
                        // \} else {
                        //   Navigator.pushNamed(context, '/note-list');
                        // \}
                      },
                    ),
                    ListTile(
                      leading: Image.asset(
                        "assets/icons/Notebook_ico.png",
                        color: Colors.white,
                        width: 20,
                      ),
                      title: const Text(
                        'Buku catatan',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        setState(() {
                          _currentPageIndex = 2;
                        });
                        // if (pageActive == "Buku Catatan") {
                        //   Navigator.pop(context);
                        // \} else {
                        //   Navigator.pushNamed(context, '/notebook-list');
                        // \}
                      },
                    ),
                    ListTile(
                      leading: const Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                      title: const Text(
                        'Pengaturan',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, '/settings');
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (MediaQuery.of(context).size.width > 1000 &&
              MediaQuery.of(context).size.width < 1500) ...[
            Expanded(
              flex: 3,
              child: Container(
                color: Colors.white,
                child: pages[_currentPageIndex],
              ),
            ),
          ] else ...[
            Expanded(
              flex: 5,
              child: Container(
                color: Colors.white,
                child: pages[_currentPageIndex],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class DekstopNotesListWidget extends StatelessWidget {
  const DekstopNotesListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(flex: 2, child: NotesListWidget()),
        Expanded(
            flex: 2,
            child: notesDekstopData == null
                ? Center(
                    child: Text("Buka Catatan!"),
                  )
                : ReadNotesPage(notes: notesDekstopData)),
      ],
    );
  }
}
