import 'package:get/get.dart';
import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../routes/app_pages.dart';

class AuthController extends GetxController {
  Timer? authTimer;
  SupabaseClient client = Supabase.instance.client;
  Future<void> autoLogout() async {
    if (authTimer != null) {
      authTimer!.cancel();
    }

    authTimer = Timer(const Duration(seconds: 90000), () async {
      await client.auth.signOut();
      Get.offAllNamed(Routes.HOME);
    }); // after login will run auto logout after 1 hours
  }

  Future<void> resetTimer() async {
    if (authTimer != null) {
      authTimer!.cancel();
      authTimer = null;
    }
  }
}
