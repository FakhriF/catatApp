import 'package:catat_app/colors.dart';
import 'package:catat_app/page/settings/bantuan.dart';
import 'package:flutter/material.dart';

class CrewBantuanListPage extends StatefulWidget {
  CrewBantuanListPage({Key? key}) : super(key: key);

  @override
  State<CrewBantuanListPage> createState() => _CrewBantuanListPageState();
}

class _CrewBantuanListPageState extends State<CrewBantuanListPage> {
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
        userAct: "Crew",
      ),
    );
  }
}
