import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PelangganDasboardController extends GetxController {
  SupabaseClient client = Supabase.instance.client;

  RxBool isLoading = false.obs;

  final count = 0.obs;
  final RxDouble totalDebt = 0.0.obs;
  final RxDouble totalPaidDebt = 0.0.obs;
  var todayTransactionCount = 0.obs;
  var monthlyTransactionData = <int>[].obs;

  Future<void> refreshData() async {
    isLoading.value = true;
    await getUserRole();
    isLoading.value = false;
  }

  @override
  void onInit() {
    super.onInit();
    getUserRole();
  }

  RxString userRole = RxString('');
  RxInt selectedIndexOwner = 0.obs;
  RxInt selectedIndexKaryawan = 0.obs;
  RxInt selectedIndexPelanggan = 0.obs;

  Future<void> getUserRole() async {
    try {
      var uid = client.auth.currentUser?.id;

      if (uid == null) {
        if (kDebugMode) {
          print("User ID not found");
        }
        return;
      }

      var response =
          await client.from('user').select('role').eq('uid', uid).single().execute();

      if (response.data != null && response.data.isNotEmpty) {
        userRole.value = response.data['role'] as String? ?? '';
        if (kDebugMode) {
          print(response.data.toString());
        }
      } else {
        if (kDebugMode) {
          print("No user found");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Exception occurred: $e");
      }
    }
  }
}
