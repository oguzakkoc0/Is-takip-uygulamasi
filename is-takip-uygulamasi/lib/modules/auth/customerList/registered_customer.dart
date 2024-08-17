import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:staj_proje_1/modules/auth/customerList/customer_detail_view.dart';

class RegisteredCustomersView extends StatefulWidget {
  const RegisteredCustomersView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisteredCustomersViewState createState() =>
      _RegisteredCustomersViewState();
}

class _RegisteredCustomersViewState extends State<RegisteredCustomersView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String _searchTerm = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            onChanged: (value) {
              setState(() {
                _searchTerm = value;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Ara...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: _firestore.collection('customers').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('Henüz kayıtlı müşteri yok.'));
              }

              final filteredDocs = snapshot.data!.docs.where((doc) {
                final data = doc.data() as Map<String, dynamic>;
                final name = data['name']?.toString().toLowerCase() ?? '';
                final surname = data['surname']?.toString().toLowerCase() ?? '';
                final address = data['address']?.toString().toLowerCase() ?? '';
                final phone = data['phone']?.toString().toLowerCase() ?? '';
                final searchTerm = _searchTerm.toLowerCase();

                return name.contains(searchTerm) ||
                    surname.contains(searchTerm) ||
                    address.contains(searchTerm) ||
                    phone.contains(searchTerm);
              }).toList();

              return ListView.builder(
                itemCount: filteredDocs.length,
                itemBuilder: (context, index) {
                  final doc = filteredDocs[index];
                  final data = doc.data() as Map<String, dynamic>;
                  final customerId = doc.id;

                  return ListTile(
                    title: Text(
                        '${data['name'] ?? 'N/A'} ${data['surname'] ?? 'N/A'}'),
                    subtitle: Text(
                        '${data['address'] ?? 'N/A'} - ${data['phone'] ?? 'N/A'}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomerDetailView(
                            customerId: customerId,
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
