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
  required String name,
  required String subjek,
  required String detail,
}) async {
  await _firestore.collection('help').add({
    'name': name,
    'email': currentUser?.email,
    'subject': subjek,
    'detail': detail,
    'time': FieldValue.serverTimestamp(),
  });
}
