import 'package:flutter/material.dart';
import '../add_customer_page.dart/add_customer_page.dart';
import '../customerList/registered_customer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ana Sayfa')),
      body: _selectedIndex == 0
          ? const AddCustomerView()
          : const RegisteredCustomersView(),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: TextButton(
                onPressed: () => _onItemTapped(0),
                child: Text(
                  'Müşteri Ekle',
                  style: TextStyle(
                    color: _selectedIndex == 0 ? Colors.blue : Colors.black,
                    fontWeight: _selectedIndex == 0
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
            Expanded(
              child: TextButton(
                onPressed: () => _onItemTapped(1),
                child: Text(
                  'Kayıtlı Müşteriler',
                  style: TextStyle(
                    color: _selectedIndex == 1 ? Colors.blue : Colors.black,
                    fontWeight: _selectedIndex == 1
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
