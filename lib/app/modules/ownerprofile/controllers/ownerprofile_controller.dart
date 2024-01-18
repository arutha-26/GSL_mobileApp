import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../routes/app_pages.dart';

class OwnerprofileController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController nameC = TextEditingController();
  TextEditingController nameC2 = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  SupabaseClient client = Supabase.instance.client;

  String? imageUrl;

  Future<void> uploadImage(String imagePath) async {
    try {
      final userId = client.auth.currentUser!.id;
      final response = await client.storage.from('profiles').upload(
            'avatar/$userId/avatar.jpg', // Use a unique path for each user
            File(imagePath),
          );

      if (kDebugMode) {
        print('Upload response: $response');
      }

      if (response != null) {
        imageUrl = response; // Assuming response is the URL
        update(); // Update the UI to reflect the new image
      } else {
        Get.snackbar("Error", "Failed to upload image");
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image: $e');
      }
      if (e is StorageException) {
        if (kDebugMode) {
          print(
              'Supabase Storage Error: ${e.message}, StatusCode: ${e.statusCode}, Error: ${e.error}');
        }
      }
      Get.snackbar("Error", "Failed to upload image");
    }
  }

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
          Get.snackbar("ERROR", "Password must be longer than 6 characters");
        }
      }
      Get.defaultDialog(
          barrierDismissible: false,
          title: "Success",
          middleText: "Update Password Berhasil",
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
