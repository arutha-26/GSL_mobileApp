import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/controllers/auth_controllers.dart';
import 'app/routes/app_pages.dart';
import 'app/utils/authentication_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  String supaUri = dotenv.get('SUPABASE_URL');
  String supaAnon = dotenv.get('SUPABASE_ANONKEY');

  Supabase supaProvider = await Supabase.initialize(url: supaUri, anonKey: supaAnon);

  final authC = Get.put(AuthController(), permanent: true);

  runApp(GetMaterialApp(
    title: "Application",
    debugShowCheckedModeBanner: false,
    initialRoute: Routes.SPLASHSCREEN,
    // Always start with splash screen
    getPages: AppPages.routes,
    onInit: () async {
      await Future.delayed(const Duration(seconds: 2));

      AuthenticationService authService = AuthenticationService(supaProvider.client);

      // Check if the user is already logged in
      if (supaProvider.client.auth.currentUser != null) {
        await authService.fetchUserRoleAndNavigate(); // Call fetchUserRoleAndNavigate here
      } else {
        Get.offNamed(Routes.LOGINPAGE);
      }
    },
  ));
}
