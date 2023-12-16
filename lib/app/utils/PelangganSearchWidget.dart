import 'package:flutter/material.dart';
import 'package:gsl/app/utils/pelanggan.dart';

import '../modules/addtransaksi/controllers/addtransaksi_controller.dart';

class PelangganSearchWidget extends StatelessWidget {
  final TextEditingController controller;
  final AddtransaksiController addtransaksiController;

  PelangganSearchWidget({Key? key, required this.controller, required this.addtransaksiController}) : super(key: key);

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
          return '$name - +62$phone';
        } else {
          return ''; // Return an empty string for null options
        }
      },
      onSelected: (Pelanggan selection) {
        controller.text = '${selection.nama} - +62${selection.phone}';
      },
      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          onEditingComplete: onEditingComplete,
          decoration: const InputDecoration(
            labelText: "Pelanggan",
            border: OutlineInputBorder(),
          ),
        );
      },
    );
  }
}