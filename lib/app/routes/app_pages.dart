import 'package:get/get.dart';

import '../modules/adddatakaryawan/bindings/adddatakaryawan_binding.dart';
import '../modules/adddatakaryawan/views/adddatakaryawan_view.dart';
import '../modules/adddatapelanggan/bindings/adddatapelanggan_binding.dart';
import '../modules/adddatapelanggan/views/adddatapelanggan_view.dart';
import '../modules/datapelanggan/bindings/datapelanggan_binding.dart';
import '../modules/datapelanggan/views/datapelanggan_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/karyawanhome/bindings/karyawanhome_binding.dart';
import '../modules/karyawanhome/views/karyawanhome_view.dart';
import '../modules/karyawanlogin/bindings/karyawanlogin_binding.dart';
import '../modules/karyawanlogin/views/karyawanlogin_view.dart';
import '../modules/karyawanprofile/bindings/karyawanprofile_binding.dart';
import '../modules/karyawanprofile/views/karyawanprofile_view.dart';
import '../modules/loginpage/bindings/loginpage_binding.dart';
import '../modules/loginpage/views/loginpage_view.dart';
import '../modules/ownerhome/bindings/ownerhome_binding.dart';
import '../modules/ownerhome/views/ownerhome_view.dart';
import '../modules/ownerlogin/bindings/ownerlogin_binding.dart';
import '../modules/ownerlogin/views/ownerlogin_view.dart';
import '../modules/ownerprofile/bindings/ownerprofile_binding.dart';
import '../modules/ownerprofile/views/ownerprofile_view.dart';
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
    GetPage(
      name: _Paths.OWNERHOME,
      page: () => OwnerhomeView(),
      binding: OwnerhomeBinding(),
    ),
    GetPage(
      name: _Paths.OWNERPROFILE,
      page: () => OwnerprofileView(),
      binding: OwnerprofileBinding(),
    ),
    GetPage(
      name: _Paths.ADDDATAKARYAWAN,
      page: () => AdddatakaryawanView(),
      binding: AdddatakaryawanBinding(),
    ),
    GetPage(
      name: _Paths.KARYAWANHOME,
      page: () => KaryawanhomeView(),
      binding: KaryawanhomeBinding(),
    ),
    GetPage(
      name: _Paths.KARYAWANPROFILE,
      page: () => KaryawanprofileView(),
      binding: KaryawanprofileBinding(),
    ),
    GetPage(
      name: _Paths.ADDDATAPELANGGAN,
      page: () => AdddatapelangganView(),
      binding: AdddatapelangganBinding(),
    ),
    GetPage(
      name: _Paths.DATAPELANGGAN,
      page: () => DatapelangganView(),
      binding: DatapelangganBinding(),
    ),
    GetPage(
      name: _Paths.LOGINPAGE,
      page: () => const LoginpageView(),
      binding: LoginpageBinding(),
    ),
  ];
}
