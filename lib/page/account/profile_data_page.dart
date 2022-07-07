import 'package:catat_app/authentication.dart';
import 'package:catat_app/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";

class ProfileDataPage extends StatelessWidget {
  const ProfileDataPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profil"),
        foregroundColor: primaryColor,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(currentUser?.uid)
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Text("Wait..");
                      }
                      var userDocument = snapshot.data!;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: ((context) => ProfilePictureZoom(
                                      profPic: userDocument['gender']))));
                        },
                        child: Container(
                            width: 100,
                            height: 100,
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
                            )),
                      );
                    }),
              ),
              const SizedBox(
                height: 30,
              ),
              //Nama
              const Text(
                "Nama",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "${currentUser?.displayName}",
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //Email
              const Text(
                "Email",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "${currentUser?.email}",
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              //Gender
              const Text(
                "Gender",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser?.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Text("Wait..");
                    }
                    var userDocument = snapshot.data!;
                    return Text(
                      userDocument['gender'],
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  }),
              const SizedBox(
                height: 20,
              ),
              //Join
              const Text(
                "Terdaftar di Catat! Sejak",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('users')
                      .doc(currentUser?.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Text("Wait..");
                    }
                    var userDocument = snapshot.data!;
                    return Text(
                      DateTime.parse(userDocument['time'].toDate().toString())
                          .toString(),
                      style: const TextStyle(
                        fontWeight: FontWeight.w400,
                      ),
                    );
                  }),
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfilePictureZoom extends StatelessWidget {
  ProfilePictureZoom({required this.profPic, Key? key}) : super(key: key);
  String profPic;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //transparent appbar
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Container(
          width: 400,
          height: 400,
          decoration: BoxDecoration(
            // shape: BoxShape.square,
            image: DecorationImage(
              filterQuality: FilterQuality.high,
              image: profPic == "Laki-Laki"
                  ? const AssetImage("assets/pic_prof/men1_prof.png")
                  : const AssetImage("assets/pic_prof/women1_prof.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
