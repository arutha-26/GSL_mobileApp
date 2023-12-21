import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../routes/app_pages.dart';
import '../../../utils/pelanggan.dart';

class AddtransaksiController extends GetxController {

  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  TextEditingController namaKaryawanC = TextEditingController();

  TextEditingController tanggalDatangController = TextEditingController();
  TextEditingController tanggalSelesaiController = TextEditingController();


  SupabaseClient client = Supabase.instance.client;

  Future<List<Pelanggan>> fetchdataPelanggan(String query) async {
    List<Pelanggan> results = [];
    try {
      final response = await client
          .from('user')
          .select('nama, id, phone, kategori') // Include 'phone' in the select statement
          .eq('role', 'Pelanggan')
          .ilike('nama, phone, kategori', '%$query%')
          .execute();

      if (response.status == 200 && response.data != null && response.data is List) {
        results = (response.data as List).map((item) {
          // Ensure that 'nama', 'id', and 'phone' are treated as strings
          final nama = item['nama']?.toString() ?? '';
          final id = item['id']?.toString() ?? '';
          final phone = item['phone']?.toString() ?? '';
          final kategori = item['kategori']?.toString() ?? '';

          return Pelanggan(
            nama: nama,
            id: id,
            phone: phone,
            kategori: kategori
          );
        }).toList();
      }
    } catch (error) {
      print('Exception during fetching data: $error');
    }
    return results;
  }

  Future<void> getDataKaryawan() async {
    List<dynamic> res = await client
        .from("user")
        .select()
        .match({"uid": client.auth.currentUser!.id});
    Map<String, dynamic> user = (res).first as Map<String, dynamic>;
    namaKaryawanC.text = user["nama"];
  }

  Future<void> addTransaksi() async {
    if (namaKaryawanC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        // AuthResponse res = await client.auth
        //     .signUp(password: passwordC.text, email: emailC.text);
        // isLoading.value = false;

        // insert registered user to table users
        await client.from("user").insert({
          // "email": emailC.text,
          "nama": namaKaryawanC.text,
          "role": getSelectedRole(),
          // "alamat": alamatC.text,
          // "phone": nohpC.text,
          "kategori": getSelectedKategori(),
          "created_at": DateTime.now().toIso8601String(),
        });

        Get.defaultDialog(
            barrierDismissible: false,
            title: "Tambah Data Transaksi Berhasil",
            middleText: ".......",
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Get.back(); //close dialog
                    // Get.offAllNamed(Routes.OWNERHOME);
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
