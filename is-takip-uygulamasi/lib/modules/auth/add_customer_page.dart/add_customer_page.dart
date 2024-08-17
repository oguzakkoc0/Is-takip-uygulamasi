import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddCustomerView extends StatefulWidget {
  const AddCustomerView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddCustomerViewState createState() => _AddCustomerViewState();
}

class _AddCustomerViewState extends State<AddCustomerView> {
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _addCustomer() async {
    final name = _nameController.text;
    final surname = _surnameController.text;
    final address = _addressController.text;
    final phone = _phoneController.text;

    if (name.isNotEmpty &&
        surname.isNotEmpty &&
        address.isNotEmpty &&
        phone.isNotEmpty) {
      try {
        await _firestore.collection('customers').add({
          'name': name,
          'surname': surname,
          'address': address,
          'phone': phone,
          'orders': []
        });
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Müşteri başarıyla eklendi')),
        );
        _nameController.clear();
        _surnameController.clear();
        _addressController.clear();
        _phoneController.clear();
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lütfen tüm alanları doldurun')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _buildTextField(_nameController, 'Ad', Icons.person),
              _buildTextField(
                  _surnameController, 'Soyad', Icons.person_outline),
              _buildTextField(_addressController, 'Adres', Icons.home),
              _buildTextField(
                _phoneController,
                'Telefon Numarası',
                Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: _addCustomer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text(
                    'Ekle',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.black),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(color: Colors.black, width: 2.0),
          ),
          contentPadding:
              const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
        ),
        keyboardType: keyboardType,
      ),
    );
  }
}
