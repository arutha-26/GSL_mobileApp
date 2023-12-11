import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../routes/app_pages.dart';

class DatapelangganController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  TextEditingController nameC = TextEditingController();
  TextEditingController nameC2 = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  SupabaseClient client = Supabase.instance.client;

  Future<void> logout() async {
    await client.auth.signOut();
    Get.offAllNamed(Routes.HOME);
  }

  Future<void> getProfile() async {
    List<dynamic> res = await client
        .from("karyawan")
        .select()
        .match({"uid": client.auth.currentUser!.id});
    Map<String, dynamic> user = (res).first as Map<String, dynamic>;
    nameC.text = user["nama_karyawan"];
    nameC2.text = user["nama_karyawan"];
    emailC.text = user["email"];
  }

  Future<void> updateProfile() async {
    if (nameC2.text.isNotEmpty) {
      isLoading.value = true;
      await client.from("karyawan").update({
        "nama_karyawan": nameC2.text,
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
          Get.snackbar("ERROR", "Password must be longer than 6 characters");
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
}
