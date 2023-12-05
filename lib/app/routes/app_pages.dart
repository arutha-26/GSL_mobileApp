import 'package:get/get.dart';

import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/karyawanlogin/bindings/karyawanlogin_binding.dart';
import '../modules/karyawanlogin/views/karyawanlogin_view.dart';
import '../modules/ownerlogin/bindings/ownerlogin_binding.dart';
import '../modules/ownerlogin/views/ownerlogin_view.dart';
import '../modules/splashscreen/bindings/splashscreen_binding.dart';
import '../modules/splashscreen/views/splashscreen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.OWNERLOGIN,
      page: () => OwnerloginView(),
      binding: OwnerloginBinding(),
    ),
    GetPage(
      name: _Paths.SPLASHSCREEN,
      page: () => SplashscreenView(),
      binding: SplashscreenBinding(),
    ),
    GetPage(
      name: _Paths.KARYAWANLOGIN,
      page: () => KaryawanloginView(),
      binding: KaryawanloginBinding(),
    ),
  ];
}
