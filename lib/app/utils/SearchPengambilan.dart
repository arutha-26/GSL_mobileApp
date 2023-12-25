import 'package:flutter/material.dart';
import 'package:gsl/app/modules/pengambilanLaundry/controllers/pengambilan_laundry_controller.dart';
import 'package:gsl/app/utils/pelanggan.dart';

class SearchPengambilan extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController kategoriController;
  final PengambilanLaundryController pengambilanLaundryController;

  SearchPengambilan({
    Key? key,
    required this.nameController,
    required this.phoneController,
    required this.kategoriController,
    required this.pengambilanLaundryController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Pengambilan>(
      optionsBuilder: (TextEditingValue textEditingValue) async {
        if (textEditingValue.text == '') {
          return const Iterable<Pengambilan>.empty();
        }
        return await pengambilanLaundryController.fetchdataPelanggan(textEditingValue.text);
      },
      displayStringForOption: (Pengambilan option) {
        if (option != null) {
          final name = option.nama ?? '';
          final phone = option.phone ?? '';
          final kategori = option.kategori ?? '';
          return '$name - +62$phone - $kategori';
        } else {
          return ''; // Return an empty string for null options
        }
      },
      onSelected: (Pengambilan selection) {
        nameController.text = selection.nama ?? '';
        phoneController.text = '+62${selection.phone}' ?? '';
        kategoriController.text = selection.kategori ?? '';
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
