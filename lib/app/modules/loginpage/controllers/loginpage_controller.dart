import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../routes/app_pages.dart';

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

  Future<String?> getUserRole() async {
    try {
      // Assuming 'uid' matches the 'id' in the Supabase auth table
      var uid = client.auth.currentUser?.id;

      if (uid == null) {
        print("User ID not found");
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
        print("No user found");
        return null;
      }
    } catch (e) {
      print("Exception occurred: $e");
      return null;
    }
  }

  Future<bool?> login() async {
    if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        await client.auth
            .signInWithPassword(email: emailC.text, password: passwordC.text);
        isLoading.value = false;

        // Fetch user role after successful login
        String? userRole = await getUserRole();

        if (userRole != null) {
          // Navigate based on user role
          switch (userRole) {
            case 'Owner':
              Get.offAllNamed(Routes.OWNERHOME);
              break;
            case 'Karyawan':
              Get.offAllNamed(Routes.KARYAWANHOME); // Replace with your route
              break;
            case 'Pelanggan':
              Get.offAllNamed(Routes.PELANGGANHOME);
              break;
            default:
              Get.snackbar("ERROR", "Unknown user role");
              break;
          }
        } else {
          Get.snackbar("ERROR", "Failed to fetch user role");
        }

        return true;
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("ERROR", e.toString());
        return null;
      }
    } else {
      Get.snackbar("ERROR", "Email dan Password harus terisi!");
      return null;
    }
  }
}

