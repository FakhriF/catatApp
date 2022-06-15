import 'package:catat_app/colors.dart';
import 'package:flutter/material.dart';

class CrewHomePage extends StatelessWidget {
  const CrewHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Crew"),
          foregroundColor: primaryColor,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Wrap(
              children: [
                //container circle with child icon
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/crew/bantuan');
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          //border
                          border: Border.all(
                              color: Colors.blue.shade300,
                              width: 4,
                              style: BorderStyle.solid),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.support_agent_rounded,
                          size: 50,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        "Bantuan/Help",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
