import 'package:catat_app/colors.dart';
import 'package:catat_app/firestore.dart';
import 'package:catat_app/settings/settings_page.dart';
import 'package:flutter/material.dart';

class BantuanPage extends StatelessWidget {
  BantuanPage({Key? key}) : super(key: key);

  TextEditingController nama = TextEditingController();
  TextEditingController subjek = TextEditingController();
  TextEditingController detail = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Bantuan"),
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
            const SizedBox(height: 70),
            const Text(
              "Silahkan isi formulir ini secara lengkap dan benar, agar mudah diproses~!\nPertanyaan atau Permintaan Anda akan direspon dan dikirim melalui alamat email yang Anda gunakan saat ini\n\nTerima Kasih!",
              style: TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 50),
            Column(
              children: [
                TextField(
                  controller: nama,
                  decoration: InputDecoration(
                    labelText: "Nama/Panggilan",
                    hintText: "Contoh : Faki, Conan, Nao, dll",
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
                if (nama.text.isEmpty ||
                    subjek.text.isEmpty ||
                    detail.text.isEmpty) {
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
                      name: nama.text,
                      subjek: subjek.text,
                      detail: detail.text);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SettingPage()));
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Terima Kasih!"),
                        content: const Text(
                            "Pertanyaan atau permintaan Anda akan direspon dan dikirim melalui alamat email yang Anda gunakan saat ini"),
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
