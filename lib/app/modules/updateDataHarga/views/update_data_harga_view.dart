import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../controllers/update_data_harga_controller.dart';

class UpdateDataHargaView extends GetView<UpdateDataHargaController> {
  UpdateDataHargaView({super.key});
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> userData = Get.arguments ?? {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Data Harga'),
        centerTitle: true,
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.all(10),
          child: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.all(5),
              children: [
                Image.asset(
                  'images/hand-holding-usd.png',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 15),
                // _buildTextField('ID Harga', 'id_harga', userData),
                const SizedBox(height: 15),
                _buildTextField('Kategori Pelanggan', 'kategori_pelanggan', userData),
                const SizedBox(height: 15),
                _buildTextField('Metode Laundry', 'metode_laundry_id', userData),
                const SizedBox(height: 15),
                _buildTextField('Layanan Laundry', 'layanan_laundry_id', userData),
                const SizedBox(height: 15),
                _buildTextFieldCurrency('Harga/Kg', 'harga_kilo', userData),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    controller.updateUserData(userData);
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.greenAccent,
                    minimumSize: const Size(350, 45),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'Update Data',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTextField(String label, String field, Map<String, dynamic> userData) {
    return TextFormField(
      enabled: ['harga_kilo'].contains(field),
      initialValue: userData[field]?.toString() ?? '',
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Field cannot be empty';
        }
        return null;
      },
      onChanged: (value) {
        if (['harga_kilo'].contains(field)) {
          controller.updatedUserData[field] = value;
        }
      },
    );
  }

  String formatCurrency(double value) {
    final currencyFormat =
        NumberFormat.currency(locale: 'id', symbol: 'Rp', decimalDigits: 0).format(value);
    return currencyFormat;
  }

  Widget _buildTextFieldCurrency(String label, String field, Map<String, dynamic> userData) {
    return TextFormField(
      enabled: ['harga_kilo'].contains(field),
      initialValue:
          formatCurrency(double.tryParse(userData[field]?.toString() ?? '0.0') ?? 0.0),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        // prefixText: 'Rp ',
      ),
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        TextInputFormatter.withFunction((oldValue, newValue) {
          final numericValue = int.tryParse(newValue.text) ?? 0;
          final formattedValue = formatCurrency(numericValue.toDouble());
          return TextEditingValue(
            text: formattedValue,
            selection: TextSelection.collapsed(offset: formattedValue.length),
          );
        }),
      ],
      keyboardType: TextInputType.number,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Field cannot be empty';
        }
        return null;
      },
      onChanged: (value) {
        if (['harga_kilo'].contains(field)) {
          controller.updatedUserData[field] = value;
        }
      },
    );
  }
}
