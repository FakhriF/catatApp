import 'package:catat_app/authentication.dart';
import 'package:catat_app/class.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Declare
final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//Write ScratchPad
Future addScratchPad({
  required String isi,
}) async {
  final docUser = _firestore
      .collection('users/${currentUser?.uid}/scratch-pad')
      .doc('scratch-pad');
  final userData = AddScratchPad(isi: isi);

  final json = userData.toJson();

  await docUser.set(json);
}

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

Future deleteNotes({
  required String? uid,
  required String unotes,
}) async {
  await FirebaseFirestore.instance
      .collection('users/$uid/notes')
      .doc(unotes)
      .delete();
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

//Write Notebook
Future addNotebooks({required String notebook, required String? uid}) async {
  final docUser = _firestore.collection('users/$uid/notebooks').doc(notebook);
  final notebookData = NotebookList(
    notebookName: notebook.toString(),
    timeCreated:
        "${DateTime.now().day.toString()}/${DateTime.now().month.toString()}/${DateTime.now().year.toString()}",
    timeModif:
        "${DateTime.now().day.toString()}/${DateTime.now().month.toString()}/${DateTime.now().year.toString()}",
  );
  final json = notebookData.toJson();

  await docUser.set(json);
}

//update Notebooks
Future updateNotebooks(
    {required String notebook,
    required String? uid,
    required String timeCreated}) async {
  final docUser = _firestore.collection('users/$uid/notebooks').doc(notebook);
  final notebookData = NotebookList(
    notebookName: notebook.toString(),
    timeCreated: timeCreated,
    timeModif:
        "${DateTime.now().day.toString()}/${DateTime.now().month.toString()}/${DateTime.now().year.toString()}",
  );
  final json = notebookData.toJson();

  await docUser.set(json);
}

//update Note
Future updateNotes({
  required String? uid,
  required String unotes,
  required String judul,
  required String isi,
  required String label,
}) async {
  await _firestore.collection('users/$uid/notes').doc(unotes).update({
    'title': judul,
    'content': isi,
    'time': FieldValue.serverTimestamp(),
    'label': label,
    'timeModif':
        "${DateTime.now().day.toString()}/${DateTime.now().month.toString()}/${DateTime.now().year.toString()}",
  });
}

Future createHelp({
  required String? uid,
  required String? name,
  required String title,
  required String detail,
}) async {
  String? threeName;
  threeName = "";
  for (var i = 0; i < 2; i++) {
    threeName = threeName! + "${name![i].toUpperCase()}";
  }
  String? caseID = "H${threeName}-${DateTime.now().millisecondsSinceEpoch}";
  await _firestore.collection('help').doc(caseID).set({
    'name': name,
    'uid': uid,
    'CaseID': caseID,
    'chat': [],
    'status': "OPEN",
    'email': currentUser?.email,
    'title': title,
    'detail': detail,
    'time': FieldValue.serverTimestamp(),
  });
}

//update Help Status
Future updateHelpStatus({
  required String? status,
  required String? caseID,
}) async {
  await _firestore.collection('help').doc(caseID).update({
    'status': status,
  });
}

//delete HelpCase
Future deleteHelpCase({
  required String? caseID,
}) async {
  await _firestore.collection('help').doc(caseID).delete();
}

//add user
Future addUser({
  required String? uid,
  required String name,
  required String? email,
  required String alasan,
  required bool? newsletter,
  required String? gender,
  required String know,
}) async {
  final docUser = FirebaseFirestore.instance.collection('users').doc(uid);
  final userData = UserData(
      name: name,
      email: email,
      know: know,
      gender: gender,
      newsletter: newsletter,
      alasan: alasan,
      time: FieldValue.serverTimestamp());

  final json = userData.toJson();

  await docUser.set(json);
}

Future chatHelp({
  required String? caseID,
  required String chatText,
  required String userAct,
}) async {
  FirebaseFirestore.instance.collection('help').doc(caseID).update({
    'chat': FieldValue.arrayUnion([
      {
        'user': userAct != "Crew"
            ? currentUser?.displayName
            : "CS - ${currentUser?.displayName}",
        'chat': chatText,
        'time': DateTime.now().toString(),
      },
    ]),
  });
}

//read Bantuan for Users
Stream<QuerySnapshot> getHelpListUser({required String? uid}) {
  return FirebaseFirestore.instance
      .collection('help')
      .where('uid', isEqualTo: uid)
      .orderBy('time', descending: true)
      .snapshots();
}

//read Bantuan for Crew
Stream<QuerySnapshot> getHelpListCrew() {
  return FirebaseFirestore.instance
      .collection('help')
      .orderBy('time', descending: true)
      .snapshots();
}

//Last Access
Future LastAccessUser() async {
  final uid = currentUser?.uid;
  final docUser = FirebaseFirestore.instance.collection('users').doc(uid);
  final LastAccess = FieldValue.serverTimestamp();
  final json = {
    'LastAccess': LastAccess,
  };
  await docUser.update(json);
}
