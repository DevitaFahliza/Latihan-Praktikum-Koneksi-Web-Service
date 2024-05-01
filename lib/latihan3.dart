import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(MyApp());
}

// Kelas untuk merepresentasikan data universitas
class University {
  final String name; // Nama universitas
  final String website; // Situs web universitas

  University({required this.name, required this.website});

  // Factory method untuk membuat objek University dari JSON
  factory University.fromJson(Map<String, dynamic> json) {
    return University(
      name: json['name'],
      website: json['web_pages'][0], // Mengambil situs pertama jika ada
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late Future<List<University>> futureUniversities;

  @override
  void initState() {
    super.initState();
    futureUniversities = fetchUniversities(); // Memuat data universitas saat initState
  }

  // Fungsi untuk mengambil data universitas dari API
  Future<List<University>> fetchUniversities() async {
    final response = await http.get(Uri.parse(
        'http://universities.hipolabs.com/search?country=Indonesia'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      List<University> universities = data
          .map((dynamic item) => University.fromJson(item))
          .toList();
      return universities;
    } else {
      throw Exception('Failed to load universities');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Indonesian Universities'), // Judul aplikasi
        ),
        body: Center(
          child: FutureBuilder<List<University>>(
            future: futureUniversities,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                // Jika data tersedia, tampilkan ListView dari universitas
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        _launchURL(snapshot.data![index].website); // Buka situs universitas saat item diklik
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch, // Rata tengah semua teks
                        children: [
                          ListTile(
                            title: Text(
                              snapshot.data![index].name, // Tampilkan nama universitas
                              textAlign: TextAlign.center, // Teks rata tengah
                            ),
                            subtitle: Text(
                              snapshot.data![index].website, // Tampilkan situs web universitas
                              textAlign: TextAlign.center, // Teks rata tengah
                              style: TextStyle(
                                color: Colors.blue, // Warna biru untuk tautan
                                decoration: TextDecoration.none, // Hilangkan garis bawah
                              ),
                            ),
                          ),
                          Divider( // Tampilkan garis samar di antara setiap item
                            color: Colors.grey[300],
                            thickness: 1,
                            height: 0,
                          ),
                        ],
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                // Jika terjadi kesalahan, tampilkan pesan kesalahan
                return Text("${snapshot.error}");
              }
              // Jika data masih dimuat, tampilkan indikator loading
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }

  // Fungsi untuk membuka URL dalam browser
  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
