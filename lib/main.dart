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
  String url = "http://127.0.0.1:8000/tambah_mhs/"; // URL endpoint untuk menambahkan data mahasiswa

  // Fungsi untuk mengirim data mahasiswa baru ke server
  Future<int> insertData() async {
    final response = await http.post(
      Uri.parse(url), // URL endpoint
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8' // Header untuk menentukan tipe konten
      },
      body: """
      {"nim": "13594022", // Data mahasiswa yang akan ditambahkan
      "nama": "Sandra Permana",
      "id_prov": "12",
      "angkatan": "2020",
      "tinggi_badan": 190}
      """,
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
                    respPost = insertData(); // Memanggil fungsi untuk mengirim data mahasiswa
                  });
                },
                child: const Text('Klik Untuk Insert data (POST)'),
              ),
              Text("Hasil:"),
              FutureBuilder<int>(
                future: respPost,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data! == 201) {
                      return Text("Proses Insert Berhasil!"); // Pesan jika proses berhasil
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
