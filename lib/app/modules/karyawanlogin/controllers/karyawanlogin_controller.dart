import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class KaryawanloginController extends GetxController {
  //TODO: Implement KaryawanloginController

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();

  SupabaseClient client = Supabase.instance.client;

  Future<bool?> login() async {
    if (phone.text.isNotEmpty && password.text.isNotEmpty) {
      isLoading.value = true;
      try {
        await client.auth.signInWithPassword(phone: phone.text, password: password.text);
        isLoading.value = false;
        Get.defaultDialog(
          barrierDismissible: false,
          title: "Login success",
          middleText: "Will be redirected to Home Page",
          backgroundColor: Colors.green,
        );
        return true;
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("ERROR", e.toString());
      }
    } else {
      Get.snackbar("ERROR", "Phone and password are required");
    }
    return null;
  }
}

