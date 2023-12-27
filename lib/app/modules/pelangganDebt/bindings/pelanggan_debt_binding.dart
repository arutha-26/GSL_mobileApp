import 'package:get/get.dart';

import '../controllers/pelanggan_debt_controller.dart';

class PelangganDebtBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PelangganDebtController>(
      () => PelangganDebtController(),
    );
  }
}
