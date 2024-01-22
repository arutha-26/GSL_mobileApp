import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../modules/pengambilanLaundry/controllers/pengambilan_laundry_controller.dart';

class BuktiTrf extends StatelessWidget {
  PengambilanLaundryController controller = PengambilanLaundryController();

  BuktiTrf({
    Key? key,
    required this.imageUrl,
    required this.onUpload,
    required this.selectedImage,
    required this.onImageSelected,
  }) : super(key: key);

  final String? imageUrl;
  final void Function(String imageUrl) onUpload;
  final XFile? selectedImage;
  final void Function(XFile? image) onImageSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            width: 350,
            height: 350,
            child: imageUrl != null
                ? Image.file(
                    File(imageUrl!), // Gunakan Image.file untuk path lokal
                    fit: BoxFit.cover,
                  )
                : Container(
                    color: Colors.grey,
                    child: const Center(
                      child: Text('Bukti Transfer'),
                    ),
                  ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () async {
              final ImagePicker picker = ImagePicker();
              final XFile? image = await picker.pickImage(source: ImageSource.camera);
              if (image == null) {
                return;
              }
              onImageSelected(image);
            },
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.indigoAccent),
              foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              minimumSize: MaterialStateProperty.all<Size>(const Size(300, 40)),
            ),
            child: const Text('Upload Bukti Transfer'),
          ),
          Obx(() => ElevatedButton(
                onPressed: () {
                  if (controller.isLoading.isFalse) {
                    if (selectedImage != null) {
                      onUpload(selectedImage!.path);
                      if (kDebugMode) {
                        print('image path nih: $selectedImage');
                      }
                    } else {
                      // Tampilkan snackbar jika selectedImage null
                      Get.snackbar(
                        'ERROR',
                        'Harap pilih gambar terlebih dahulu',
                        snackPosition: SnackPosition.BOTTOM,
                        colorText: Colors.white,
                        backgroundColor: Colors.red,
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: const Color(0xFF22c55e),
                  minimumSize: const Size(300, 40),
                ),
                child: Text(
                  controller.isLoading.isFalse ? "Tambah Transaksi" : "Loading...",
                ),
              )),
          const SizedBox(
            height: 30,
          )
        ],
      ),
    );
  }
}
