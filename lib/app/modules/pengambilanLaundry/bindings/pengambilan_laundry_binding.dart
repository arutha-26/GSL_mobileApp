import 'package:get/get.dart';

import '../controllers/pengambilan_laundry_controller.dart';

class PengambilanLaundryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PengambilanLaundryController>(
      () => PengambilanLaundryController(),
    );
  }
}
