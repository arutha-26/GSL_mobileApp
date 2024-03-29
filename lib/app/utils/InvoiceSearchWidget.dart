import 'package:flutter/material.dart';
import 'package:gsl/app/modules/invoiceTransaksi/controllers/invoice_transaksi_controller.dart';
import 'package:gsl/app/utils/pelanggan.dart';

class InvoiceSearchWidget extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController phoneController;
  final TextEditingController kategoriController;

  final InvoiceTransaksiController invoiceTransaksiController;

  InvoiceSearchWidget({
    Key? key,
    required this.nameController,
    required this.phoneController,
    required this.kategoriController,
    required this.invoiceTransaksiController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Autocomplete<Pelanggan>(
      optionsBuilder: (TextEditingValue textEditingValue) async {
        if (textEditingValue.text == '') {
          return const Iterable<Pelanggan>.empty();
        }
        return await invoiceTransaksiController.fetchdataPelanggan(textEditingValue.text);
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
        phoneController.text = selection.phone ?? '';
        kategoriController.text = selection.kategori ?? '';
      },
      fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          textInputAction: TextInputAction.done,
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
