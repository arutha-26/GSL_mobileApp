import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginpageController extends GetxController {

  OwnerloginController() {
    print('OwnerloginController initialized');
  }

  @override
  void onInit() {
    print('OwnerloginController onInit called');
    super.onInit();
  }

  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  SupabaseClient client = Supabase.instance.client;

  Future<bool?> login() async {
    if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        await client.auth
            .signInWithPassword(email: emailC.text, password: passwordC.text);
        isLoading.value = false;
        Get.defaultDialog(
            barrierDismissible: false,
            title: "Login Berhasil!",
            middleText: "akan diarahkan ke halaman utama",
            backgroundColor: Colors.green);
        return true;
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("ERROR", e.toString());
      }
    } else {
      Get.snackbar("ERROR", "Email dan Password harus terisi!");
    }
    return null;
  }
}