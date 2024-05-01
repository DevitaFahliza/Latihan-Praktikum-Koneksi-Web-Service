import 'dart:convert';

void main() {
  // Data JSON yang disimpan sebagai string
  String jsonString = '''
  {
    "mahasiswa": {
      "nama": "Anita Lestari",
      "nim": "A111222",
      "prodi": "Ilmu Komputer",
      "universitas": "Universitas Nusantara"
    },
    "transkrip": [
      {
        "kode_mk": "IK101",
        "nama_mk": "Pengantar Ilmu Komputer",
        "sks": 2,
        "nilai": "A"
      },
      {
        "kode_mk": "IK102",
        "nama_mk": "Algoritma dan Struktur Data",
        "sks": 3,
        "nilai": "B"
      },
      {
        "kode_mk": "IK103",
        "nama_mk": "Pemrograman Lanjut",
        "sks": 3,
        "nilai": "A-"
      },
      {
        "kode_mk": "IK104",
        "nama_mk": "Basis Data",
        "sks": 3,
        "nilai": "B+"
      }
    ]
  }
  ''';

  // Menguraikan JSON ke dalam objek Map untuk memudahkan akses data
  Map<String, dynamic> parsedJson = jsonDecode(jsonString);

  // Mengakses array transkrip dari JSON
  List<dynamic> transkrip = parsedJson['transkrip'];

  double totalNilai = 0.0;
  int totalSks = 0;

  // Fungsi untuk mengonversi nilai huruf ke angka
  double nilaiKeAngka(String nilai) {
    switch (nilai) {
      case 'A':
        return 4.0;
      case 'A-':
        return 3.7;
      case 'B+':
        return 3.3;
      case 'B':
        return 3.0;
      case 'B-':
        return 2.7;
      case 'C+':
        return 2.3;
      case 'C':
        return 2.0;
      case 'D':
        return 1.0;
      default:
        return 0.0; // untuk nilai yang tidak dikenal atau gagal
    }
  }

  // Perhitungan total nilai dan total SKS
  for (var mataKuliah in transkrip) {
    int sks = mataKuliah['sks'];
    String nilai = mataKuliah['nilai'];
    totalSks += sks;
    totalNilai += nilaiKeAngka(nilai) * sks;
  }

  // Menghitung IPK
  double ipk = totalNilai / totalSks;

  // Menampilkan IPK
  print(
      "IPK dari ${parsedJson['mahasiswa']['nama']} adalah ${ipk.toStringAsFixed(2)}");
}
