import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late Future<int> respPost; // Future untuk menampung respons dari permintaan HTTP
  String url = "http://127.0.0.1:8000/delete_mhs/"; // URL endpoint untuk menghapus data mahasiswa

  // Fungsi untuk mengirim permintaan HTTP DELETE untuk menghapus data mahasiswa
  Future<int> fetchData() async {
    // Data nim mahasiswa yang akan dihapus
    String nim = "13594022";
    // Mengirim permintaan DELETE ke server dengan menyertakan nim mahasiswa dalam URL
    final response = await http.delete(Uri.parse(url + nim)); 
    // Mengembalikan kode status respons, misalnya 200 jika sukses
    return response.statusCode; 
  }

  @override
  void initState() {
    super.initState();
    respPost = Future.value(0); // Inisialisasi nilai awal untuk Future
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
                    // Ketika tombol ditekan, jalankan fetchData untuk menghapus data
                    respPost = fetchData();
                  });
                },
                child: const Text('Klik untuk delete data'),
              ),
              Text("Hasil:"), // Teks untuk menampilkan hasil dari permintaan HTTP
              FutureBuilder<int>(
                future: respPost,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    // Jika data respons tersedia
                    if (snapshot.data! == 200) {
                      // Jika kode status adalah 200 (sukses)
                      return Text("Proses delete berhasil!");
                    }
                    if (snapshot.data! == 0) {
                      // Jika nilai awal
                      return Text("");
                    } else {
                      // Jika ada kesalahan dalam proses delete
                      return Text("Proses delete gagal");
                    }
                  }
                  // Menampilkan indikator loading selama data belum tersedia
                  return const CircularProgressIndicator();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
