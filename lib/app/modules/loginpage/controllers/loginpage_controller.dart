import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../routes/app_pages.dart';

class LoginpageController extends GetxController {
  @override
  void onInit() {
    if (kDebugMode) {
      print('OwnerloginController onInit called');
    }
    super.onInit();
  }

  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  SupabaseClient client = Supabase.instance.client;

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
        return response.data['role'] as String?;
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

  Future<bool?> getUserStatus() async {
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
          .select('is_active')
          .eq('uid', uid)
          .single()
          .execute();

      if (response.data != null && response.data.isNotEmpty) {
        return response.data['is_active'] as bool;
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

  Future<bool?> login() async {
    if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        await client.auth.signInWithPassword(email: emailC.text, password: passwordC.text);
        isLoading.value = false;

        // Fetch user role after successful login
        String? userRole = await getUserRole();
        bool? userStatus = await getUserStatus();

        if (userStatus != false) {
          // Navigate based on user role
          if (userRole != null) {
            switch (userRole) {
              case 'Owner':
                Get.offAllNamed(Routes.OWNERHOME);
                Get.snackbar(
                  'Berhasil Login',
                  'Selamat Datang Owner',
                  snackPosition: SnackPosition.BOTTOM,
                  colorText: Colors.black87,
                  backgroundColor: const Color(0xFFC6DDD8),
                );
                break;
              case 'Karyawan':
                Get.offAllNamed(Routes.KARYAWANHOME);
                Get.snackbar(
                  'Berhasil Login',
                  'Selamat Datang Karyawan',
                  snackPosition: SnackPosition.BOTTOM,
                  colorText: Colors.black87,
                  backgroundColor: const Color(0xFFC6DDD8),
                );
                break;
              case 'Pelanggan':
                Get.offAllNamed(Routes.PELANGGANHOME);
                Get.snackbar(
                  'Berhasil Login',
                  'Selamat Datang Pelanggan',
                  snackPosition: SnackPosition.BOTTOM,
                  colorText: Colors.black87,
                  backgroundColor: const Color(0xFFC6DDD8),
                );
                break;
              default:
                Get.snackbar(
                  'Gagal',
                  'User Role atau Status Error',
                  snackPosition: SnackPosition.BOTTOM,
                  colorText: Colors.white,
                  backgroundColor: Colors.red,
                );
                break;
            }
          } else {
            Get.snackbar(
              'Gagal',
              'User Role Tidak Ditemukan',
              snackPosition: SnackPosition.BOTTOM,
              colorText: Colors.white,
              backgroundColor: Colors.red,
            );
          }
        } else {
          Get.snackbar(
            'Gagal',
            'Status Pengguna Non-Aktif',
            snackPosition: SnackPosition.BOTTOM,
            colorText: Colors.white,
            backgroundColor: Colors.red,
          );
        }

        return true;
      } catch (e) {
        isLoading.value = false;
        Get.snackbar(
          "ERROR",
          e.toString(),
          snackPosition: SnackPosition.BOTTOM,
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
        return null;
      }
    } else {
      Get.snackbar(
        'Error',
        'Semua Data Harus Terisi!',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
      return null;
    }
  }
}
