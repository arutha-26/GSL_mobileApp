import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../routes/app_pages.dart';

class PelangganProfileController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    getUserRole();
  }

  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  TextEditingController nameC = TextEditingController();
  TextEditingController nameC2 = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  SupabaseClient client = Supabase.instance.client;

  Future<void> logout() async {
    await client.auth.signOut();
    Get.offAllNamed(Routes.LOGINPAGE);
  }

  Future<void> getProfile() async {
    List<dynamic> res =
        await client.from("user").select().match({"uid": client.auth.currentUser!.id});
    Map<String, dynamic> user = (res).first as Map<String, dynamic>;
    nameC.text = user["nama"];
    nameC2.text = user["nama"];
    emailC.text = user["email"];
  }

  Future<void> updateProfile() async {
    if (nameC2.text.isNotEmpty) {
      isLoading.value = true;
      await client.from("user").update({
        "nama": nameC2.text,
      }).match({"uid": client.auth.currentUser!.id});
      // if user want to update password
      if (passwordC.text.isNotEmpty) {
        if (passwordC.text.length >= 6) {
          try {
            await client.auth.updateUser(UserAttributes(
              password: passwordC.text,
            ));
          } catch (e) {
            Get.snackbar("ERROR", e.toString());
          }
        } else {
          Get.snackbar("ERROR", "Password harus lebih dari 6");
        }
      }
      Get.defaultDialog(
          barrierDismissible: false,
          title: "Update Profile sukses",
          middleText: "Nama dan password berhasil diupdate",
          actions: [
            OutlinedButton(
                onPressed: () {
                  Get.back(); //close dialog
                  Get.back(); //back to login page
                },
                child: const Text("OK"))
          ]);
      isLoading.value = false;
    }
  }

  RxString userRole = RxString('');
  RxInt selectedIndexOwner = 0.obs;
  RxInt selectedIndexKaryawan = 0.obs;
  RxInt selectedIndexPelanggan = 0.obs;

  Future<void> getUserRole() async {
    try {
      var uid = client.auth.currentUser?.id;

      if (uid == null) {
        if (kDebugMode) {
          print("User ID not found");
        }
        return;
      }

      var response =
          await client.from('user').select('role').eq('uid', uid).single().execute();

      if (response.data != null && response.data.isNotEmpty) {
        userRole.value = response.data['role'] as String? ?? '';
        if (kDebugMode) {
          print(response.data.toString());
        }
      } else {
        if (kDebugMode) {
          print("No user found");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Exception occurred: $e");
      }
    }
  }

  void onPageChanged(int index) {
    selectedIndexPelanggan.value = index;
  }
}
