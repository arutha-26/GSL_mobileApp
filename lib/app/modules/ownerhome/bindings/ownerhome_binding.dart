import 'package:get/get.dart';

import '../controllers/ownerhome_controller.dart';

class OwnerhomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OwnerhomeController>(
      () => OwnerhomeController(),
    );
  }
}
