import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SuppliersScreen extends StatefulWidget {
  const SuppliersScreen({super.key});

  @override
  State<SuppliersScreen> createState() => _SuppliersScreenState();
}

class _SuppliersScreenState extends State<SuppliersScreen> {
  List<dynamic> _suppliers = [];

  @override
  void initState() {
    super.initState();
    _fetchSuppliers();
  }

  Future<void> _fetchSuppliers() async {
    final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/v1/suppliers'));
    if (response.statusCode == 200) {
      setState(() => _suppliers = json.decode(response.body));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Supplier Directory', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF2D2B2A),
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _suppliers.length,
        itemBuilder: (context, index) {
          final s = _suppliers[index];
          return Card(
            child: ListTile(
              leading: const CircleAvatar(backgroundColor: Color(0xFF588157), child: Icon(Icons.business, color: Colors.white)),
              title: Text(s['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Contact: ${s['contact_person']}'),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Owed', style: TextStyle(fontSize: 10, color: Colors.grey)),
                  Text('PKR ${s['balance_owed']}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF2D2B2A),
        onPressed: () {}, // Future: Add logic to add new supplier
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }
}