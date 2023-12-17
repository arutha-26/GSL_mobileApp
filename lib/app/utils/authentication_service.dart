// services/authentication_service.dart

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:supabase/supabase.dart';

import '../routes/app_pages.dart';

class AuthenticationService {
  final SupabaseClient client;

  AuthenticationService(this.client);

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

  Future<void> fetchUserRoleAndNavigate() async {
    try {
      String? userRole = await getUserRole();

      if (userRole != null) {
        // Navigate based on user role
        switch (userRole) {
          case 'Owner':
            Get.offAllNamed(Routes.OWNERHOME);
            break;
          case 'Karyawan':
            Get.offAllNamed(Routes.KARYAWANHOME);
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
    } catch (e) {
      Get.snackbar("ERROR", e.toString());
    }
  }
// Other authentication-related functions can be added here
}
