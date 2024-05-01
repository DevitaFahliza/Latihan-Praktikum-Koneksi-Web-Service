import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

// Kelas model untuk merepresentasikan aktivitas
class Activity {
  String activity; // Nama aktivitas
  String type; // Jenis aktivitas

  Activity({required this.activity, required this.type});

  // Factory method untuk membuat objek Activity dari JSON
  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      activity: json['activity'],
      type: json['type'],
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<Activity> futureActivity;
  String url = "https://www.boredapi.com/api/activity";

  @override
  void initState() {
    super.initState();
    futureActivity = fetchData();
  }

  // Fungsi untuk mengambil data aktivitas dari API
  Future<Activity> fetchData() async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return Activity.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal load');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Activity Recommendation"), // Judul aplikasi
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  futureActivity = fetchData(); // Memuat data aktivitas baru
                });
              },
              child: const Text("Saya bosan ..."), // Tombol untuk memuat aktivitas baru
            ),
            FutureBuilder<Activity>(
              future: futureActivity,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(snapshot.data!.activity), // Menampilkan nama aktivitas
                      Text("Jenis: ${snapshot.data!.type}") // Menampilkan jenis aktivitas
                    ],
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}'); // Menampilkan pesan kesalahan jika terjadi
                }
                return const CircularProgressIndicator(); // Tampilkan indikator loading ketika data sedang dimuat
              },
            ),
          ],
        ),
      ),
    );
  }
}
