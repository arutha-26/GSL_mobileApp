import 'package:get/get.dart';

import '../controllers/detail_history_pelanggan_controller.dart';

class DetailHistoryPelangganBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailHistoryPelangganController>(
      () => DetailHistoryPelangganController(),
    );
  }
}
