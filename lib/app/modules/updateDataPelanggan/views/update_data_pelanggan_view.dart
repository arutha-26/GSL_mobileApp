import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/update_data_pelanggan_controller.dart';

class UpdateDataPelangganView extends GetView<UpdateDataPelangganController> {
  UpdateDataPelangganView({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> userData = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Data Pelanggan'),
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
                  'images/user_profile.png',
                  width: 250,
                  height: 250,
                ),
                // const SizedBox(height: 15),
                // _buildTextField('ID Pelanggan', 'id_user', userData),
                const SizedBox(height: 15),
                _buildTextField('Nama Pelanggan', 'nama', userData),
                const SizedBox(height: 15),
                _buildTextField('Email Pelanggan', 'email', userData),
                const SizedBox(height: 15),
                _buildTextField('Nomor Pelanggan', 'no_telp', userData),
                const SizedBox(height: 15),
                _buildDropdownField('Kategori Pelanggan', 'kategori', userData),
                const SizedBox(height: 15),
                _buildTextField('Alamat Pelanggan', 'alamat', userData),
                const SizedBox(height: 25),
                _buildDropdownStatus('Status Pelanggan', 'is_active', userData),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    // if (_formKey.currentState?.validate() ?? false) {
                    controller.updateUserData(userData);
                    // }
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black,
                    backgroundColor: Colors.greenAccent, // Warna teks
                    minimumSize: const Size(150, 48),
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'Update Data',
                          style: TextStyle(
                            color: Colors.black87,
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

  Widget _buildDropdownField(String label, String field, Map<String, dynamic> userData) {
    return DropdownButtonFormField<String>(
      value: controller.updatedUserData[field] ?? userData[field]?.toString() ?? null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: ['Individual', 'Villa', 'Hotel'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (value) {
        controller.updatedUserData[field] = value;
      },
    );
  }

  Widget _buildDropdownStatus(String label, String field, Map<String, dynamic> userData) {
    return DropdownButtonFormField<bool>(
      value: userData[field] ?? false,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: const [
        DropdownMenuItem<bool>(
          value: true,
          child: Text('Aktif'),
        ),
        DropdownMenuItem<bool>(
          value: false,
          child: Text('Tidak Aktif'),
        ),
      ],
      onChanged: (value) {
        controller.updatedUserData[field] = value;
      },
    );
  }

  Widget _buildTextField(String label, String field, Map<String, dynamic> userData) {
    return TextFormField(
      enabled: ['kategori', 'alamat', 'no_telp'].contains(field),
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
        if (['phone', 'kategori', 'alamat', 'is_active'].contains(field)) {
          controller.updatedUserData[field] = value;
        }
      },
    );
  }
}
