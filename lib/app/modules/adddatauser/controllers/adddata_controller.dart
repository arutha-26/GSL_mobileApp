import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../routes/app_pages.dart';

class AdddataController extends GetxController {
  RxString userRole = "".obs; // Tambahkan ini sebagai variabel anggota

  @override
  void onInit() {
    getUserRole();
    super.onInit();
  }

  @override
  void onReady() {
    getUserRole();
    super.onReady();
  }

  Future<String?> getUserRole() async {
    try {
      // Assuming 'uid' matches the 'id' in the Supabase auth table
      var uid = client.auth.currentUser?.id;

      if (uid == null) {
        if (kDebugMode) {
          print("User ID not found");
        }
        return null;
      }

      var response = await client
          .from('user') // Replace with your user details table name
          .select('role')
          .eq('uid', uid)
          .single()
          .execute();

      if (response.data != null && response.data.isNotEmpty) {
        userRole.value = response.data['role'] as String? ?? ""; // Set nilai userRole
        if (kDebugMode) {
          print('user role:${userRole.value}');
        }
        return userRole.value;
      } else {
        if (kDebugMode) {
          print("No user found");
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print("Exception occurred: $e");
      }
      return null;
    }
  }

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

  // TextEditingController passwordC = TextEditingController();
  TextEditingController passwordC = TextEditingController(text: "123456789");
  TextEditingController alamatC = TextEditingController();

  SupabaseClient client = Supabase.instance.client;

  Future<void> addData() async {
    if (emailC.text.isNotEmpty &&
        nameC.text.isNotEmpty &&
        alamatC.text.isNotEmpty &&
        nohpC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        // Store the current session
        // final originalSession = await client.auth.currentSession;

        AuthResponse res =
            await client.auth.signUp(password: passwordC.text, email: emailC.text);
        isLoading.value = false;

        // Log the data to be inserted
        if (kDebugMode) {
          print('Inserting data to the database:');
        }
        if (kDebugMode) {
          print('Email: ${emailC.text}');
        }
        if (kDebugMode) {
          print('Name: ${nameC.text}');
        }
        if (kDebugMode) {
          print('Role: ${getSelectedRole()}');
        }
        if (kDebugMode) {
          print('Alamat: ${alamatC.text}');
        }
        if (kDebugMode) {
          print('No Telp: ${nohpC.text}');
        }
        if (kDebugMode) {
          print('Kategori: ${getSelectedKategori()}');
        }
        if (kDebugMode) {
          print('Password: ${passwordC.text}');
        }
        if (kDebugMode) {
          print('Created At: ${DateTime.now().toIso8601String()}');
        }

        // insert registered user to table users
        await client.from("user").insert({
          "email": emailC.text,
          "nama": nameC.text,
          "role": getSelectedRole(),
          "alamat": alamatC.text,
          "no_telp": nohpC.text,
          "kategori": getSelectedKategori(),
          "created_at": DateTime.now().toIso8601String(),
          "uid": res.user!.id,
          "is_active": true,
        });

        // Clear the session manually
        await client.auth.signOut();

        // // Recover the original session
        // await client.auth.recoverSession(originalSession as String);

        Get.defaultDialog(
          barrierDismissible: false,
          title: "Tambah Data Pengguna email: ${res.user!.email} Telah Berhasil",
          middleText: "Harap Lakukan Login Kembali",
          actions: [
            OutlinedButton(
              onPressed: () {
                Get.back(); //close dialog
                // Get.deleteAll(force: true);
                Get.offAllNamed(Routes.LOGINPAGE);
                // Get.back(); //close dialog
              },
              child: const Text("OK"),
            ),
          ],
        );
      } catch (e) {
        isLoading.value = false;
        Get.snackbar(
          'ERROR',
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      }
    } else {
      Get.snackbar(
        'ERROR',
        'Seluruh data harus terisi!',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    }
    // refresh();
  }

  RxString selectedKategori = "".obs;
  List<String> kategoriOptions = ["-", "Individual", "Hotel", "Villa"];

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
    selectedRole.value = value ?? "";
  }
}
