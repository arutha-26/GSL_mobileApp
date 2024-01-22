import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gsl/app/modules/pengambilanLaundry/controllers/pengambilan_laundry_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'bukti_transfer.dart';

class BuktiTransfer extends StatefulWidget {
  const BuktiTransfer({Key? key}) : super(key: key);

  @override
  State<BuktiTransfer> createState() => _BuktiTransfer();
}

class _BuktiTransfer extends State<BuktiTransfer> {
  PengambilanLaundryController controller = Get.find<PengambilanLaundryController>();

  SupabaseClient client = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return BuktiTrf(
      imageUrl: controller.imagePilih?.path,
      onUpload: (imageUrl) async {
        controller.updateSelectedImage(controller.imagePilih);
        if (controller.imagePilih == null) {
          Get.snackbar(
            'ERROR',
            'Harap pilih gambar terlebih dahulu',
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
            backgroundColor: Colors.red,
          );
          return;
        }
        controller.updateTransaksi();
      },
      selectedImage: controller.imagePilih,
      onImageSelected: (XFile? image) {
        controller.updateSelectedImage(image);
      },
    );
  }
}
