import 'package:get/get.dart';

import '../controllers/karyawan_dashboard_controller.dart';

class KaryawanDashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KaryawanDashboardController>(
      () => KaryawanDashboardController(),
    );
  }
}
