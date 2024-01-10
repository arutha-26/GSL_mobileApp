import 'package:flutter/material.dart';
import 'package:gsl/app/utils/pelanggan.dart';

import '../modules/addtransaksi/controllers/addtransaksi_controller.dart';

class PelangganSearchWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController kategoriController;

  final AddtransaksiController addtransaksiController;

  PelangganSearchWidget({
    Key? key,
    required this.nameController,
    required this.phoneController,
    required this.kategoriController,
    required this.addtransaksiController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Pelanggan>(
      optionsBuilder: (TextEditingValue textEditingValue) async {
        if (textEditingValue.text == '') {
          return const Iterable<Pelanggan>.empty();
        }
        return await addtransaksiController.fetchdataPelanggan(textEditingValue.text);
      },
      displayStringForOption: (Pelanggan option) {
        if (option != null) {
          final name = option.nama ?? '';
          final phone = option.phone ?? '';
          final kategori = option.kategori ?? '';
          return '$name - $phone - $kategori';
        } else {
          return ''; // Return an empty string for null options
        }
      },
      onSelected: (Pelanggan selection) {
        nameController.text = selection.nama ?? '';
        phoneController.text = '${selection.phone}' ?? '';
        kategoriController.text = selection.kategori ?? '';
      },
      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          onEditingComplete: onEditingComplete,
          decoration: const InputDecoration(
            labelText: "Cari Pelanggan",
            border: OutlineInputBorder(),
          ),
        );
      },
    );
  }
}
