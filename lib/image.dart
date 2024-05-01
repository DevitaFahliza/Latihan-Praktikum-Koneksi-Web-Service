import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String namaImage = ""; // Variabel untuk menyimpan nama gambar yang diunggah

  final dio = Dio(); // Objek Dio untuk pengiriman permintaan HTTP

  // Fungsi untuk mengunggah file gambar ke server
  Future<String> uploadFile(List<int> file, String fileName) async {
    FormData formData = FormData.fromMap({
      "file": MultipartFile.fromBytes(
        file,
        filename: fileName,
        contentType: MediaType("image", "png"),
      ),
    });
    var response =
        // Untuk pengguna Chrome
        await dio.post("http://127.0.0.1:8000/uploadimage", data: formData);
        
        // Untuk pengguna Android emulator
        // await dio.post("http://10.0.2.2:8000/uploadimage", data: formData);

    print(response.statusCode);
    if (response.statusCode == 200) {
      setState(() {
        namaImage = fileName; // Mengubah nilai namaImage dengan nama file yang diunggah
      });
    }
    return fileName; // Mengembalikan nama file yang diunggah
  }

  // Fungsi untuk memilih gambar dari galeri
  Future<void> _getImageFromGallery() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    final bytes = await pickedImage?.readAsBytes();
    if (pickedImage != null) {
      await uploadFile(bytes as List<int>, pickedImage.name); // Mengunggah gambar yang dipilih
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Image Picker Example'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              namaImage != ""
                  ? Image.network(
                      // Untuk pengguna Chrome
                      'http://127.0.0.1:8000/getimage/$namaImage',
                      
                      // Untuk pengguna Android emulator
                      // 'http://10.0.2.2:8000/getimage/$namaImage',
                      height: 200,
                    )
                  : const Text(" Image Tidak Tersedia"),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _getImageFromGallery,
                child: const Text('Select Image'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
