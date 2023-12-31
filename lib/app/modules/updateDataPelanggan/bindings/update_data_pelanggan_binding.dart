import 'package:get/get.dart';

import '../controllers/update_data_pelanggan_controller.dart';

class UpdateDataPelangganBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UpdateDataPelangganController>(
      () => UpdateDataPelangganController(),
    );
  }
}
