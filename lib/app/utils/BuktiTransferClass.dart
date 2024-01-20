import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../modules/addtransaksi/controllers/addtransaksi_controller.dart';
import 'bukti_transfer.dart';

class BuktiTransfer extends StatefulWidget {
  const BuktiTransfer({Key? key}) : super(key: key);

  @override
  State<BuktiTransfer> createState() => _BuktiTransfer();
}

class _BuktiTransfer extends State<BuktiTransfer> {
  AddtransaksiController controller = Get.find<AddtransaksiController>();

  SupabaseClient client = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return BuktiTrf(
      imageUrl: controller.imagePilih?.path,
      onUpload: (imageUrl) async {
        controller.updateSelectedImage(controller.imagePilih);
        // final tgl = DateTime.now().toString();
        await controller.addTransaksi();
        //
        // client
        //     .from('transaksi')
        //     .update({'bukti_transfer': imageUrl}).eq("tanggal_datang", tgl);
      },
      selectedImage: controller.imagePilih,
      onImageSelected: (XFile? image) {
        controller.updateSelectedImage(image);
      },
    );
  }
}
