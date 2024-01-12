import 'package:flutter/material.dart';
import 'package:gsl/app/modules/pengambilanLaundry/controllers/pengambilan_laundry_controller.dart';
import 'package:gsl/app/utils/pengambilan.dart';

class SearchPengambilan extends StatelessWidget {
  final TextEditingController idTransaksiController;
  final TextEditingController idUserController;
  final TextEditingController namaController;
  final TextEditingController noTelpController;
  final TextEditingController beratController;
  final TextEditingController totalHargaController;
  final TextEditingController metodePembayaranController;
  final TextEditingController statusPembayaranControlller;
  final TextEditingController statusCucianController;
  final PengambilanLaundryController pengambilanLaundryController;

  SearchPengambilan({
    Key? key,
    required this.idTransaksiController,
    required this.idUserController,
    required this.namaController,
    required this.noTelpController,
    required this.beratController,
    required this.totalHargaController,
    required this.metodePembayaranController,
    required this.statusPembayaranControlller,
    required this.statusCucianController,
    required this.pengambilanLaundryController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Pengambilan>(
      optionsBuilder: (TextEditingValue textEditingValue) async {
        if (textEditingValue.text == '') {
          return const Iterable<Pengambilan>.empty();
        }
        return await pengambilanLaundryController.fetchDataTransaksi(textEditingValue.text);
      },
      displayStringForOption: (Pengambilan option) {
        if (option != null) {
          final idTransaksi = option.idTransaksi ?? '';
          final idUser = option.idUser ?? '';
          final nama = option.nama ?? '';
          final noTelp = option.noTelp ?? '';
          final berat = option.berat ?? '';
          final totalHarga = option.totalHarga ?? '';
          final metodePembayaran = option.metodePembayaran ?? '';
          final statusPembayaran = option.statusPembayaran ?? '';
          final statusCucian = option.statusCucian ?? '';
          return '$idTransaksi - $nama - $noTelp - $berat - $totalHarga - $metodePembayaran- $statusPembayaran - $statusCucian';
        } else {
          return '';
        }
      },
      onSelected: (Pengambilan selection) {
        idTransaksiController.text = selection.idTransaksi ?? '';
        idUserController.text = selection.idUser ?? '';
        namaController.text = selection.nama ?? '';
        noTelpController.text = selection.noTelp ?? '';
        beratController.text = selection.berat ?? '';
        totalHargaController.text = selection.totalHarga ?? '';
        metodePembayaranController.text = selection.metodePembayaran ?? '';
        statusPembayaranControlller.text = selection.statusPembayaran ?? '';
        statusCucianController.text = selection.statusCucian ?? '';
      },
      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          onEditingComplete: onEditingComplete,
          decoration: const InputDecoration(
            labelText: "Cari Data Transaksi",
            border: OutlineInputBorder(),
          ),
        );
      },
    );
  }
}
