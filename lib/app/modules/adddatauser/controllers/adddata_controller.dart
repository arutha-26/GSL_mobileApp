import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../routes/app_pages.dart';

class AdddataController extends GetxController {

  @override
  void onClose() {
    // Reset the controller's state when the page is disposed
    nameC.clear();
    emailC.clear();
    nohpC.clear();
    passwordC.clear();
    alamatC.clear();
    super.onClose();
  }

  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  TextEditingController nameC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController nohpC = TextEditingController();

  TextEditingController passwordC = TextEditingController();

  TextEditingController alamatC = TextEditingController();


  SupabaseClient client = Supabase.instance.client;

  Future<void> signUp() async {
    if (emailC.text.isNotEmpty &&
        passwordC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        alamatC.text.isNotEmpty &&
        nohpC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        // AuthResponse res = await client.auth
        //     .signUp(password: passwordC.text, email: emailC.text);
        // isLoading.value = false;

        // insert registered user to table users
        await client.from("user").insert({
          "email": emailC.text,
          "nama": nameC.text,
          "role": getSelectedRole(),
          "alamat": alamatC.text,
          "phone": nohpC.text,
          "kategori": getSelectedKategori(),
          "created_at": DateTime.now().toIso8601String(),
        });

        Get.defaultDialog(
            barrierDismissible: false,
            title: "Tambah Data Pengguna Berhasil",
            middleText: "user: ${emailC.text} sudah bisa login!",
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Get.back(); //close dialog
                    Get.offAllNamed(Routes.OWNERHOME);
                  },
                  child: const Text("OK"))
            ]);
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("ERROR", e.toString());
      }
    } else {
      Get.snackbar("ERROR", "Seluruh data harus terisi!");
    }
    refresh();
  }

  RxString selectedKategori = "".obs;
  List<String> kategoriOptions = ["-","Individual", "Hotel", "Villa"];

  String getSelectedKategori() {
    return selectedKategori.value;
  }

  void setSelectedKategori(String? value) {
    selectedKategori.value = value ?? "-";
  }

  RxString selectedRole = "".obs;
  List<String> roleOptions = ["Owner", "Karyawan", "Pelanggan"];

  String getSelectedRole() {
    return selectedRole.value;
  }

  void setSelectedRole(String? value) {
    selectedRole.value = value ?? "-";
  }

}
