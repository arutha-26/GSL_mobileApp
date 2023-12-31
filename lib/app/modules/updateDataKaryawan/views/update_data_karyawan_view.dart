import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/update_data_karyawan_controller.dart';

class UpdateDataKaryawanView extends GetView<UpdateDataKaryawanController> {
  UpdateDataKaryawanView({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> userData = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Data Pengguna'),
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
                const SizedBox(height: 15),
                _buildTextField('ID Pengguna', 'id', userData),
                _buildTextField('Role Pengguna', 'role', userData),
                const SizedBox(height: 15),
                _buildTextField('Nama Pengguna', 'nama', userData),
                const SizedBox(height: 15),
                _buildTextField('Email Pengguna', 'email', userData),
                const SizedBox(height: 15),
                _buildTextField('Kategori Pengguna', 'kategori', userData),
                const SizedBox(height: 15),
                _buildTextField('Nomor Pengguna', 'phone', userData),
                const SizedBox(height: 15),
                _buildTextField('Alamat Pengguna', 'alamat', userData),
                const SizedBox(height: 25),
                _buildDropdownStatus('Status Pengguna', 'is_active', userData),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: () {
                    // if (_formKey.currentState?.validate() ?? false) {
                    controller.updateUserData(userData);
                    // }
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.lightBlue,
                    minimumSize: const Size(150, 48),
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
      enabled: ['phone', 'alamat', 'is_active'].contains(field),
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
        if (['phone', 'alamat', 'is_active'].contains(field)) {
          controller.updatedUserData[field] = value;
        }
      },
    );
  }
}
