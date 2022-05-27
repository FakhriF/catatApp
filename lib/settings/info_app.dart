import 'package:catat_app/colors.dart';
import 'package:flutter/material.dart';

class VersionApp extends StatelessWidget {
  const VersionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Versi Aplikasi"),
        foregroundColor: primaryColor,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              height: 100,
            ),
            Column(
              children: [
                Image.asset(
                  'assets/icon/ic_launcher.png',
                  width: 80,
                ),
                const SizedBox(
                  height: 50,
                ),
                Column(
                  children: const [
                    Text(
                      "Versi Aplikasi",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "1.0.0",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                "Aplikasi Catat! Oleh FakhriF",
                style: TextStyle(color: Colors.grey.shade600, letterSpacing: 3),
              ),
            )
          ],
        ),
      ),
    );
  }
}
