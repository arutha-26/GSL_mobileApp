import 'package:get/get.dart';

import '../controllers/ownerlogin_controller.dart';

class OwnerloginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OwnerloginController>(
      () => OwnerloginController(),
    );
  }
}
