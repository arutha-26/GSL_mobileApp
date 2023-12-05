import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app/controllers/auth_controllers.dart';
import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  String supaUri = dotenv.get('SUPABASE_URL');
  String supaAnon = dotenv.get('SUPABASE_ANONKEY');

  Supabase supaProvider = await Supabase.initialize(url: supaUri, anonKey: supaAnon);

  final authC = Get.put(AuthController(), permanent: true);

  runApp(
    GetMaterialApp(
      title: "Application",
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.SPLASHSCREEN,
      getPages: AppPages.routes,
      onReady: () async {
        // Introduce a delay of 2 seconds before navigating to the home screen
        await Future.delayed(const Duration(seconds: 3));

        // Navigate to the home screen
        Get.offNamed(Routes.HOME);
      },
    ),
  );
}
