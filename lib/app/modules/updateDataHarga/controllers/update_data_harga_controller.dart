import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UpdateDataHargaController extends GetxController {
  @override
  void onInit() {
    getDataUser();
    super.onInit();
  }

  TextEditingController idUser = TextEditingController();

  RxBool isLoading = false.obs;
  RxMap<String, dynamic> updatedUserData = <String, dynamic>{}.obs;
  SupabaseClient client = Supabase.instance.client;

  Future<void> getDataUser() async {
    try {
      List<dynamic> res =
          await client.from("user").select('*').match({"uid": client.auth.currentUser!.id});

      if (res.isNotEmpty) {
        Map<String, dynamic> user = res.first as Map<String, dynamic>;
        idUser.text = user["id_user"].toString();
        print("id user nih: ${idUser.text}");
      } else {
        if (kDebugMode) {
          print("Data not found for current user ID");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error fetching data: $e");
      }
    }
  }

  Future<void> updateUserData(Map<String, dynamic> userData) async {
    if (kDebugMode) {
      print('Update button pressed');
    }
    try {
      if (userData['id_harga'] != null) {
        isLoading.value = true;

        String cleanedInput =
            updatedUserData['harga_kilo'].toString().replaceAll(RegExp(r'[^\d]'), '');

        double? hargaKilo = cleanedInput.isEmpty ? null : double.parse(cleanedInput);

        Map<String, dynamic> updateFields = {
          "id_user": idUser.text,
          "harga_kilo": hargaKilo ?? userData['harga_kilo'],
          "edit_at": DateTime.now().toString(),
        };
        if (kDebugMode) {
          print(updateFields);
        }

        var response = await client
            .from("harga")
            .update(updateFields)
            .match({"id_harga": userData['id_harga']}).execute();

        isLoading.value = false; // Reset the loading state

        if (response.status == 200 || response.status == 201 || response.status == 204) {
          // Log the updated data to the console
          if (kDebugMode) {
            print('Data Diperbaharui: $updatedUserData');
          }

          // Insert into log_harga table
          Map<String, dynamic> logData = {
            "id_harga": userData['id_harga'],
            "harga_kilo_lama": userData['harga_kilo'],
            "harga_kilo_baru": updateFields["harga_kilo"],
            "created_at": DateTime.now().toString(),
          };

          print("Log Data Nih:$logData");
          var logResponse = await client
              .from("log_harga")
              .upsert([logData]).execute(); // Assuming upsert is supported for log_harga table

          if (logResponse.status == 200 ||
              logResponse.status == 201 ||
              logResponse.status == 204) {
            Get.back();
            Get.forceAppUpdate();
            Get.snackbar(
              'Berhasil',
              'Data Berhasil di Perbaharui',
              colorText: Colors.white,
              backgroundColor: Colors.indigoAccent,
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.fromLTRB(10, 5, 10, 20),
            );
          } else {
            Get.snackbar(
              'Error',
              'Gagal Memperbaharui Data Harga dan Log',
              snackPosition: SnackPosition.BOTTOM,
              margin: const EdgeInsets.fromLTRB(10, 5, 10, 20),
              colorText: Colors.white,
              backgroundColor: Colors.red,
            );
          }
        } else {
          Get.snackbar(
            'Error',
            'Gagal Memperbaharui Data Harga',
            snackPosition: SnackPosition.BOTTOM,
            margin: const EdgeInsets.fromLTRB(10, 5, 10, 20),
            colorText: Colors.white,
            backgroundColor: Colors.red,
          );
        }
      }
    } catch (error) {
      isLoading.value = false; // Reset the loading state in case of an error
      if (kDebugMode) {
        print('Gagal Memperbaharui Data Harga: $error');
        Get.snackbar(
          'Error',
          '$error',
          snackPosition: SnackPosition.BOTTOM,
          margin: const EdgeInsets.fromLTRB(10, 5, 10, 20),
          colorText: Colors.white,
          backgroundColor: Colors.red,
        );
      }
    }
  }
}
