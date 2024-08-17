import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class CustomerDetailView extends StatefulWidget {
  final String customerId;

  const CustomerDetailView({super.key, required this.customerId});

  @override
  // ignore: library_private_types_in_public_api
  _CustomerDetailViewState createState() => _CustomerDetailViewState();
}

class _CustomerDetailViewState extends State<CustomerDetailView> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic> customerData = {};
  List<Map<String, dynamic>> orders = [];
  double yorganPrice = 150; // Varsayılan fiyat
  double battaniyePrice = 150; // Varsayılan fiyat
  double yastikPrice = 100; // Varsayılan fiyat

  @override
  void initState() {
    super.initState();
    _fetchCustomerDetails();
  }

  Future<void> _fetchCustomerDetails() async {
    try {
      DocumentSnapshot customerDoc =
          await _firestore.collection('customers').doc(widget.customerId).get();
      if (customerDoc.exists) {
        setState(() {
          customerData = customerDoc.data() as Map<String, dynamic>? ?? {};
          orders =
              List<Map<String, dynamic>>.from(customerData['orders'] ?? []);
          // Varsayılan fiyatları Firestore'dan çekme
          yorganPrice = customerData['yorganPrice']?.toDouble() ?? 150;
          battaniyePrice = customerData['battaniyePrice']?.toDouble() ?? 150;
          yastikPrice = customerData['yastikPrice']?.toDouble() ?? 100;
        });
      } else {
        print("Müşteri bulunamadı.");
      }
    } catch (e) {
      print("Hata: $e");
    }
  }

  Future<void> _updateCustomerDetails() async {
    final updatedData = await _showUpdateDialog();
    if (updatedData != null) {
      try {
        await _firestore.collection('customers').doc(widget.customerId).update({
          ...updatedData,
          'yorganPrice': yorganPrice,
          'battaniyePrice': battaniyePrice,
          'yastikPrice': yastikPrice,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Müşteri bilgileri güncellendi')),
        );
        _fetchCustomerDetails(); // Bilgileri tekrar çek
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e')),
        );
      }
    }
  }

  Future<void> _deleteCustomer() async {
    try {
      await _firestore.collection('customers').doc(widget.customerId).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Müşteri silindi')),
      );
      Navigator.pop(context); // Sayfayı kapat
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Hata: $e')),
      );
    }
  }

  Future<void> _addNewOrder() async {
    final Map<String, dynamic>? newOrder = await _showOrderDialog();
    if (newOrder != null) {
      try {
        setState(() {
          orders.add(newOrder);
        });
        await _firestore.collection('customers').doc(widget.customerId).update({
          'orders': orders,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Yeni sipariş eklendi')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Hata: $e')),
        );
      }
    }
  }

  Future<Map<String, dynamic>?> _showOrderDialog() async {
    final TextEditingController yorganController = TextEditingController();
    final TextEditingController battaniyeController = TextEditingController();
    final TextEditingController yastikController = TextEditingController();
    return await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Yeni Sipariş Ekle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: yorganController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Yorgan Adedi'),
              ),
              TextField(
                controller: battaniyeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Battaniye Adedi'),
              ),
              TextField(
                controller: yastikController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Yastık Adedi'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null); // İptal
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                final int yorganCount =
                    int.tryParse(yorganController.text) ?? 0;
                final int battaniyeCount =
                    int.tryParse(battaniyeController.text) ?? 0;
                final int yastikCount =
                    int.tryParse(yastikController.text) ?? 0;
                final double totalPrice = yorganCount * yorganPrice +
                    battaniyeCount * battaniyePrice +
                    yastikCount * yastikPrice;
                Navigator.of(context).pop({
                  'yorgan': yorganCount,
                  'battaniye': battaniyeCount,
                  'yastik': yastikCount,
                  'price': totalPrice,
                  'date': Timestamp.now(),
                });
              },
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>?> _showUpdateDialog() async {
    final nameController =
        TextEditingController(text: customerData['name'] ?? '');
    final surnameController =
        TextEditingController(text: customerData['surname'] ?? '');
    final addressController =
        TextEditingController(text: customerData['address'] ?? '');
    final phoneController =
        TextEditingController(text: customerData['phone'] ?? '');

    return await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Müşteri Bilgilerini Güncelle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Ad'),
              ),
              TextField(
                controller: surnameController,
                decoration: const InputDecoration(labelText: 'Soyad'),
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(labelText: 'Adres'),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(labelText: 'Telefon'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(null); // İptal
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop({
                  'name': nameController.text,
                  'surname': surnameController.text,
                  'address': addressController.text,
                  'phone': phoneController.text,
                });
              },
              child: const Text('Güncelle'),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Müşteri Silme'),
          content:
              const Text('Bu müşteriyi silmek istediğinizden emin misiniz?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // İptal
              },
              child: const Text('İptal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dialog kapat
                _deleteCustomer(); // Silme işlemi
              },
              child: const Text('Sil'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendSms(String? phoneNumber, String message) async {
    final Uri smsUri = Uri(
      scheme: 'sms',
      path: phoneNumber,
      queryParameters: <String, String>{
        'body': message,
      },
    );

    if (!await launchUrl(smsUri)) {
      throw Exception('SMS gönderilemedi: $smsUri');
    }
  }

  Future<void> _sendOrderSms(Map<String, dynamic> order) async {
    final int yorganCount = order['yorgan'] ?? 0;
    final int battaniyeCount = order['battaniye'] ?? 0;
    final int yastikCount = order['yastik'] ?? 0;

    if (yorganCount == 0 && battaniyeCount == 0 && yastikCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Siparişte ürün yok. SMS gönderilemez.')),
      );
      return; // Hiçbir ürün yoksa SMS gönderme
    }

    // Mesajı oluşturalım ve sıfır olanları hariç tutalım
    final StringBuffer messageBuffer =
        StringBuffer('Değerli Müşterimiz Sipariş Detaylarınız:\n');

    if (yorganCount > 0) {
      messageBuffer.writeln('Yorgan: $yorganCount x $yorganPrice');
    }
    if (battaniyeCount > 0) {
      messageBuffer.writeln('Battaniye: $battaniyeCount x $battaniyePrice');
    }
    if (yastikCount > 0) {
      messageBuffer.writeln('Yastık: $yastikCount x $yastikPrice');
    }

    messageBuffer.writeln('Toplam: ${order['price']}');
    messageBuffer.writeln('Teslimat 1-3 iş günü içerisinde olacaktır\n');

    final String message = messageBuffer.toString();

    await _sendSms(customerData['phone'], message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${customerData['name']} ${customerData['surname']}'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: _showDeleteConfirmationDialog,
          ),
          IconButton(
            icon: const Icon(Icons.update),
            onPressed: _updateCustomerDetails,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Text('Adres: ${customerData['address'] ?? 'Bilgi yok'}'),
            Text('Telefon: ${customerData['phone'] ?? 'Bilgi yok'}'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addNewOrder,
              child: const Text('Yeni Sipariş Ekle'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final orderDate = (order['date'] as Timestamp?)?.toDate();
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: ListTile(
                      title: Text('Sipariş ${index + 1}'),
                      subtitle: Text(
                        'Yorgan: ${order['yorgan']} x $yorganPrice\n'
                        'Battaniye: ${order['battaniye']} x $battaniyePrice\n'
                        'Yastık: ${order['yastik']} x $yastikPrice\n'
                        'Toplam: ${order['price']}\n'
                        'Tarih: ${orderDate != null ? '${orderDate.day}/${orderDate.month}/${orderDate.year}' : 'Bilgi yok'}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              final updatedOrder = await _showOrderDialog();
                              if (updatedOrder != null) {
                                _updateOrder(index, updatedOrder);
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.message),
                            onPressed: () async {
                              await _sendOrderSms(order);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateOrder(int index, Map<String, dynamic> updatedOrder) {
    setState(() {
      orders[index] = updatedOrder;
    });
    _firestore.collection('customers').doc(widget.customerId).update({
      'orders': orders,
    });
  }
}
