import 'package:get/get.dart';

import '../controllers/detailpaneltransaksi_controller.dart';

class DetailpaneltransaksiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailpaneltransaksiController>(
      () => DetailpaneltransaksiController(),
    );
  }
}
