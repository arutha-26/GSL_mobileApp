import 'package:get/get.dart';

import '../controllers/addtransaksi_controller.dart';

class AddtransaksiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddtransaksiController>(
      () => AddtransaksiController(),
    );
  }
}
