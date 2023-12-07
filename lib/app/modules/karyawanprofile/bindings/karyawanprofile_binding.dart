import 'package:get/get.dart';

import '../controllers/karyawanprofile_controller.dart';

class KaryawanprofileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<KaryawanprofileController>(
      () => KaryawanprofileController(),
    );
  }
}
