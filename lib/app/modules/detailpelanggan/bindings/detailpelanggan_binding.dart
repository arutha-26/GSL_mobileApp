import 'package:get/get.dart';

import '../controllers/detailpelanggan_controller.dart';

class DetailpelangganBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailpelangganController>(
      () => DetailpelangganController(),
    );
  }
}
