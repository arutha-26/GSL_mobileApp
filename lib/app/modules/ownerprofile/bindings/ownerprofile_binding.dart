import 'package:get/get.dart';

import '../controllers/ownerprofile_controller.dart';

class OwnerprofileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OwnerprofileController>(
      () => OwnerprofileController(),
    );
  }
}
