import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late Future<int> respPost; // Variabel untuk menyimpan respons dari permintaan HTTP
  String url = "http://127.0.0.1:8000/update_mhs_patch/"; // URL endpoint untuk mengupdate data mahasiswa

  // Fungsi untuk mengirim permintaan PATCH untuk memperbarui data mahasiswa
  Future<int> fetchData() async {
    // Data mahasiswa yang akan diperbarui disimpan di body permintaan
    String nim = "13594022"; // NIM mahasiswa yang akan diperbarui
    final response = await http.patch(
      Uri.parse(url + nim), // URL endpoint ditambahkan dengan NIM
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8' // Header untuk menentukan tipe konten
      },
      body: """
      {
      "nama": "Sandra Aulia"} """, // Hanya mengganti nama mahasiswa
    );
    return response.statusCode; // Mengembalikan status code dari respons HTTP
  }

  @override
  void initState() {
    super.initState();
    respPost = Future.value(0); // Menginisialisasi nilai respons dengan 0
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My App',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('My App'),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    respPost = fetchData(); // Memanggil fungsi untuk memperbarui data mahasiswa
                  });
                },
                child: const Text('Klik untuk update data (patch)'),
              ),
              Text("Hasil:"),
              FutureBuilder<int>(
                future: respPost,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data! == 200) {
                      return Text("Proses Update patch Berhasil!"); // Pesan jika proses berhasil
                    }
                    if (snapshot.data! == 0) {
                      return Text(""); // Teks kosong jika tidak ada respons
                    } else {
                      return Text("Proses insert gagal"); // Pesan jika proses gagal
                    }
                  }
                  // Default: menampilkan spinner loading.
                  return const CircularProgressIndicator();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
