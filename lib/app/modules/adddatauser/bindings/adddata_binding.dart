import 'package:get/get.dart';

import '../controllers/adddata_controller.dart';

class AdddataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdddataController>(
      () => AdddataController(),
    );
  }
}
