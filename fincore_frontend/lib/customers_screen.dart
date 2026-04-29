import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomersScreen extends StatefulWidget {
  const CustomersScreen({super.key});

  @override
  State<CustomersScreen> createState() => _CustomersScreenState();
}

class _CustomersScreenState extends State<CustomersScreen> {
  List<dynamic> _customers = [];
  bool _isLoading = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchCustomers();
  }

  Future<void> _fetchCustomers() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/v1/customers'));
      if (response.statusCode == 200) {
        setState(() {
          _customers = json.decode(response.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching customers: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addCustomer() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty) return;

    try {
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/api/v1/customers'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'name': _nameController.text,
          'phone': _phoneController.text,
        }),
      );

      if (response.statusCode == 200) {
        _nameController.clear();
        _phoneController.clear();
        Navigator.pop(context); // Close the dialog
        _fetchCustomers(); // Refresh the list!
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Customer registered successfully!'), backgroundColor: Color(0xFF588157)),
        );
      } else {
        final error = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error['detail'] ?? 'Registration failed.'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      print('Network Error: $e');
    }
  }

  void _showAddCustomerDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('New VIP Customer', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Phone Number', prefixIcon: Icon(Icons.phone_outlined)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF588157), foregroundColor: Colors.white),
            onPressed: _addCustomer,
            child: const Text('Register Customer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Loyalty CRM', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF2D2B2A),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFE9ECEF),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF588157)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _customers.length,
              itemBuilder: (context, index) {
                final cust = _customers[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF588157).withOpacity(0.2),
                      child: Text(cust['name'][0].toUpperCase(), style: const TextStyle(color: Color(0xFF588157), fontWeight: FontWeight.bold)),
                    ),
                    title: Text(cust['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    subtitle: Text(cust['phone']),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('POINTS', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                        Text('${cust['loyalty_points']}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF588157))),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFF588157),
        foregroundColor: Colors.white,
        onPressed: _showAddCustomerDialog,
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Register VIP', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}