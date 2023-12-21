import 'package:get/get.dart';

import '../modules/adddatauser/bindings/adddata_binding.dart';
import '../modules/adddatauser/views/adddata_view.dart';
import '../modules/addtransaksi/bindings/addtransaksi_binding.dart';
import '../modules/addtransaksi/views/addtransaksi_view.dart';
import '../modules/datapelanggan/bindings/datapelanggan_binding.dart';
import '../modules/datapelanggan/views/datapelanggan_view.dart';
import '../modules/detailpelanggan/bindings/detailpelanggan_binding.dart';
import '../modules/detailpelanggan/views/detailpelanggan_view.dart';
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
import '../modules/paneltransaksi/bindings/paneltransaksi_binding.dart';
import '../modules/paneltransaksi/views/paneltransaksi_view.dart';
import '../modules/pelangganhome/bindings/pelangganhome_binding.dart';
import '../modules/pelangganhome/views/pelangganhome_view.dart';
import '../modules/splashscreen/bindings/splashscreen_binding.dart';
import '../modules/splashscreen/views/splashscreen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASHSCREEN;

  static final routes = [
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
      name: _Paths.DATAPELANGGAN,
      page: () => DatapelangganView(),
      binding: DatapelangganBinding(),
    ),
    GetPage(
      name: _Paths.LOGINPAGE,
      page: () => LoginpageView(),
      binding: LoginpageBinding(),
    ),
    GetPage(
      name: _Paths.ADDDATA,
      page: () => AdddataView(),
      binding: AdddataBinding(),
    ),
    GetPage(
      name: _Paths.PELANGGANHOME,
      page: () => PelangganhomeView(),
      binding: PelangganhomeBinding(),
    ),
    GetPage(
      name: _Paths.DETAILPELANGGAN,
      page: () => DetailpelangganView(),
      binding: DetailpelangganBinding(),
    ),
    GetPage(
      name: _Paths.ADDTRANSAKSI,
      page: () => AddtransaksiView(),
      binding: AddtransaksiBinding(),
    ),
    GetPage(
      name: _Paths.PANELTRANSAKSI,
      page: () => const PaneltransaksiView(),
      binding: PaneltransaksiBinding(),
    ),
  ];
}
