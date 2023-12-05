import 'package:get/get.dart';

import '../../../routes/app_pages.dart';

class SplashscreenController extends GetxController {
  final count = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Called when the controller is initialized
    // loadSplashData();
  }

  // Future<void> loadSplashData() async {
  //   // You can perform any asynchronous tasks here (e.g., fetching data)
  //   await Future.delayed(Duration(seconds: 3));
  //   increment(); // Example: Increment count after some async operation
  // }
  //
  // void increment() {
  //   count.value++;
  //   if (count.value == 1) {
  //     // Navigates to the home screen when count is updated
  //     Get.offNamed(Routes.HOME);
  //   }
  // }
}
