import 'package:get/get.dart';

import '../modules/adddatauser/bindings/adddata_binding.dart';
import '../modules/adddatauser/views/adddata_view.dart';
import '../modules/addtransaksi/bindings/addtransaksi_binding.dart';
import '../modules/addtransaksi/views/addtransaksi_view.dart';
import '../modules/dashboardOwner/bindings/dashboard_owner_binding.dart';
import '../modules/dashboardOwner/views/dashboard_owner_view.dart';
import '../modules/dataKaryawan/bindings/data_karyawan_binding.dart';
import '../modules/dataKaryawan/views/data_karyawan_view.dart';
import '../modules/dataTransaksi/bindings/data_transaksi_binding.dart';
import '../modules/dataTransaksi/views/data_transaksi_view.dart';
import '../modules/datapelanggan/bindings/datapelanggan_binding.dart';
import '../modules/datapelanggan/views/datapelanggan_view.dart';
import '../modules/detailDataTransaksi/bindings/detail_data_transaksi_binding.dart';
import '../modules/detailDataTransaksi/views/detail_data_transaksi_view.dart';
import '../modules/detailKaryawan/bindings/detail_karyawan_binding.dart';
import '../modules/detailKaryawan/views/detail_karyawan_view.dart';
import '../modules/detailpelanggan/bindings/detailpelanggan_binding.dart';
import '../modules/detailpelanggan/views/detailpelanggan_view.dart';
import '../modules/invoiceTransaksi/bindings/invoice_transaksi_binding.dart';
import '../modules/invoiceTransaksi/views/invoice_transaksi_view.dart';
import '../modules/karyawanDashboard/bindings/karyawan_dashboard_binding.dart';
import '../modules/karyawanDashboard/views/karyawan_dashboard_view.dart';
import '../modules/karyawanhome/bindings/karyawanhome_binding.dart';
import '../modules/karyawanhome/views/karyawanhome_view.dart';
import '../modules/karyawanprofile/bindings/karyawanprofile_binding.dart';
import '../modules/karyawanprofile/views/karyawanprofile_view.dart';
import '../modules/log_harga/bindings/log_harga_binding.dart';
import '../modules/log_harga/views/log_harga_view.dart';
import '../modules/loginpage/bindings/loginpage_binding.dart';
import '../modules/loginpage/views/loginpage_view.dart';
import '../modules/ownerhome/bindings/ownerhome_binding.dart';
import '../modules/ownerhome/views/ownerhome_view.dart';
import '../modules/ownerprofile/bindings/ownerprofile_binding.dart';
import '../modules/ownerprofile/views/ownerprofile_view.dart';
import '../modules/paneltransaksi/bindings/paneltransaksi_binding.dart';
import '../modules/paneltransaksi/views/paneltransaksi_view.dart';
import '../modules/pelangganDasboard/bindings/pelanggan_dasboard_binding.dart';
import '../modules/pelangganDasboard/views/pelanggan_dasboard_view.dart';
import '../modules/pelangganPaid/bindings/pelanggan_paid_binding.dart';
import '../modules/pelangganPaid/views/pelanggan_paid_view.dart';
import '../modules/pelangganProfile/bindings/pelanggan_profile_binding.dart';
import '../modules/pelangganProfile/views/pelanggan_profile_view.dart';
import '../modules/pelangganTransaksi/bindings/pelanggan_transaksi_binding.dart';
import '../modules/pelangganTransaksi/views/pelanggan_transaksi_view.dart';
import '../modules/pelangganhome/bindings/pelangganhome_binding.dart';
import '../modules/pelangganhome/views/pelangganhome_view.dart';
import '../modules/pengambilanLaundry/bindings/pengambilan_laundry_binding.dart';
import '../modules/pengambilanLaundry/views/pengambilan_laundry_view.dart';
import '../modules/splashscreen/bindings/splashscreen_binding.dart';
import '../modules/splashscreen/views/splashscreen_view.dart';
import '../modules/statusCucianTransaksi/bindings/status_cucian_transaksi_binding.dart';
import '../modules/statusCucianTransaksi/views/status_cucian_transaksi_view.dart';
import '../modules/transaksiHariIni/bindings/transaksi_hari_ini_binding.dart';
import '../modules/transaksiHariIni/views/transaksi_hari_ini_view.dart';
import '../modules/updateDataHarga/bindings/update_data_harga_binding.dart';
import '../modules/updateDataHarga/views/update_data_harga_view.dart';
import '../modules/updateDataKaryawan/bindings/update_data_karyawan_binding.dart';
import '../modules/updateDataKaryawan/views/update_data_karyawan_view.dart';
import '../modules/updateDataPelanggan/bindings/update_data_pelanggan_binding.dart';
import '../modules/updateDataPelanggan/views/update_data_pelanggan_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASHSCREEN;

  static final routes = [
    GetPage(
      name: _Paths.SPLASHSCREEN,
      page: () => const SplashscreenView(),
      binding: SplashscreenBinding(),
    ),
    GetPage(
      name: _Paths.OWNERHOME,
      page: () => const OwnerhomeView(),
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
      page: () => PaneltransaksiView(),
      binding: PaneltransaksiBinding(),
    ),
    GetPage(
      name: _Paths.DASHBOARD_OWNER,
      page: () => const DashboardOwnerView(),
      binding: DashboardOwnerBinding(),
    ),
    GetPage(
      name: _Paths.DATA_TRANSAKSI,
      page: () => DataTransaksiView(),
      binding: DataTransaksiBinding(),
    ),
    GetPage(
      name: _Paths.PELANGGAN_PROFILE,
      page: () => PelangganProfileView(),
      binding: PelangganProfileBinding(),
    ),
    GetPage(
      name: _Paths.PELANGGAN_DASBOARD,
      page: () => PelangganDasboardView(),
      binding: PelangganDasboardBinding(),
    ),
    GetPage(
      name: _Paths.KARYAWAN_DASHBOARD,
      page: () => KaryawanDashboardView(),
      binding: KaryawanDashboardBinding(),
    ),
    GetPage(
      name: _Paths.PENGAMBILAN_LAUNDRY,
      page: () => PengambilanLaundryView(),
      binding: PengambilanLaundryBinding(),
    ),
    GetPage(
      name: _Paths.PELANGGAN_PAID,
      page: () => const PelangganPaidView(),
      binding: PelangganPaidBinding(),
    ),
    GetPage(
      name: _Paths.PELANGGAN_TRANSAKSI,
      page: () => const PelangganTransaksiView(),
      binding: PelangganTransaksiBinding(),
    ),
    GetPage(
      name: _Paths.INVOICE_TRANSAKSI,
      page: () => InvoiceTransaksiView(),
      binding: InvoiceTransaksiBinding(),
    ),
    GetPage(
      name: _Paths.UPDATE_DATA_PELANGGAN,
      page: () => UpdateDataPelangganView(),
      binding: UpdateDataPelangganBinding(),
    ),
    GetPage(
      name: _Paths.DATA_KARYAWAN,
      page: () => DataKaryawanView(),
      binding: DataKaryawanBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_KARYAWAN,
      page: () => DetailKaryawanView(),
      binding: DetailKaryawanBinding(),
    ),
    GetPage(
      name: _Paths.UPDATE_DATA_KARYAWAN,
      page: () => UpdateDataKaryawanView(),
      binding: UpdateDataKaryawanBinding(),
    ),
    GetPage(
      name: _Paths.DETAIL_DATA_TRANSAKSI,
      page: () => DetailDataTransaksiView(),
      binding: DetailDataTransaksiBinding(),
    ),
    GetPage(
      name: _Paths.UPDATE_DATA_HARGA,
      page: () => UpdateDataHargaView(),
      binding: UpdateDataHargaBinding(),
    ),
    GetPage(
      name: _Paths.STATUS_CUCIAN_TRANSAKSI,
      page: () => const StatusCucianTransaksiView(),
      binding: StatusCucianTransaksiBinding(),
    ),
    GetPage(
      name: _Paths.TRANSAKSI_HARI_INI,
      page: () => const TransaksiHariIniView(),
      binding: TransaksiHariIniBinding(),
    ),
    GetPage(
      name: _Paths.LOG_HARGA,
      page: () => const LogHargaView(),
      binding: LogHargaBinding(),
    ),
  ];
}
