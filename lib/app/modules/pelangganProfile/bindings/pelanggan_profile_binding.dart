import 'package:get/get.dart';

import '../controllers/pelanggan_profile_controller.dart';

class PelangganProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PelangganProfileController>(
      () => PelangganProfileController(),
    );
  }
}
