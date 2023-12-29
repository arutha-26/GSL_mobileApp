import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // Import ini
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart'; // Import ini
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/controllers/auth_controllers.dart';
import 'app/routes/app_pages.dart';
import 'app/utils/authentication_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();

  // Inisialisasi data lokal untuk Indonesia
  await initializeDateFormatting('id_ID', null);
  Intl.defaultLocale = 'id_ID';

  String supaUri = dotenv.get('SUPABASE_URL');
  String supaAnon = dotenv.get('SUPABASE_ANONKEY');

  Supabase supaProvider = await Supabase.initialize(url: supaUri, anonKey: supaAnon);

  final authC = Get.put(AuthController(), permanent: true);

  runApp(GetMaterialApp(
    title: "Green Spirit Laundry",
    debugShowCheckedModeBanner: false,
    initialRoute: Routes.SPLASHSCREEN,
    getPages: AppPages.routes,
    localizationsDelegates: const [
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('id', 'ID'), // Bahasa Indonesia
    ],
    onInit: () async {
      await Future.delayed(const Duration(seconds: 2));

      AuthenticationService authService = AuthenticationService(supaProvider.client);

      if (supaProvider.client.auth.currentUser != null) {
        await authService.fetchUserRoleAndNavigate();
      } else {
        Get.offNamed(Routes.LOGINPAGE);
      }
    },
  ));
}
