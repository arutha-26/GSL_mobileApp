import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/pelanggan.dart';

class AddtransaksiController extends GetxController {

  // @override
  // void onInit() {
  //   super.onInit();
  //   fetchdataPelanggan();
  // }

  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  TextEditingController nameC = TextEditingController();
  TextEditingController pelangganC = TextEditingController();
  TextEditingController karyawanC = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController nohpC = TextEditingController();

  TextEditingController passwordC = TextEditingController();

  TextEditingController alamatC = TextEditingController();


  SupabaseClient client = Supabase.instance.client;


  Future<List<Pelanggan>> fetchdataPelanggan(String query) async {
    List<Pelanggan> results = [];
    try {
      final response = await client
          .from('user')
          .select('nama, id, phone') // Include 'phone' in the select statement
          .eq('role', 'Pelanggan')
          .ilike('nama, phone', '%$query%')
          .execute();

      if (response.status == 200 && response.data != null && response.data is List) {
        results = (response.data as List).map((item) {
          // Ensure that 'nama', 'id', and 'phone' are treated as strings
          final nama = item['nama']?.toString() ?? '';
          final id = item['id']?.toString() ?? '';
          final phone = item['phone']?.toString() ?? '';

          return Pelanggan(
            nama: nama,
            id: id,
            phone: phone, // Map the phone number
          );
        }).toList();
      }
    } catch (error) {
      print('Exception during fetching data: $error');
    }
    return results;
  }


  // RxList<Map<String, dynamic>> data = <Map<String, dynamic>>[].obs;
  //
  // Future<void> fetchdataPelanggan() async {
  //   print("Fetching data...");
  //   try {
  //     final response = await client
  //         .from('user')
  //         .select('nama, id')
  //         .eq('role', 'Pelanggan')
  //         .execute();
  //
  //     print("Response: ${response.toString()}"); // Menampilkan seluruh respons
  //
  //     if (response.status == 200 && response.data != null && response.data is List) {
  //       List<Map<String, dynamic>> fetchedData =
  //       (response.data as List).map((item) => item as Map<String, dynamic>).toList();
  //       data.assignAll(fetchedData);
  //       print("Fetched data: $fetchedData");
  //     } else {
  //       print('Error: Response status ${response.status}, Data: ${response.data}, Error: $Future.error(error)');
  //     }
  //   } catch (error) {
  //     print('Exception during fetching data: $error');
  //   }
  // }



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
