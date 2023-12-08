import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdddatapelangganController extends GetxController {

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
        AuthResponse res = await client.auth
            .signUp(password: passwordC.text, email: emailC.text);
        isLoading.value = false;

        // insert registered user to table users
        await client.from("pelanggan").insert({
          "nama_pelanggan": nameC.text,
          "email": emailC.text,
          "no_hp": nohpC.text,
          "alamat": alamatC.text,
          "kategori_pelanggan": getSelectedKategori(),
          "created_at": DateTime.now().toIso8601String(),
          "uid": res.user!.id,
        });

        Get.defaultDialog(
            barrierDismissible: false,
            title: "Tambah Data Pelanggan Berhasil",
            middleText: "Lakukan konfirmasi Email: ${res.user!.email}",
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Get.back(); //close dialog
                    Get.back(); //back to login page
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
  }

  RxString selectedKategori = "".obs;
  List<String> kategoriOptions = ["Individual", "Hotel", "Villa"];

  String getSelectedKategori() {
    return selectedKategori.value;
  }

  void setSelectedKategori(String? value) {
    selectedKategori.value = value ?? "Individual";
  }

}
