import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class InventoryScreen extends StatefulWidget {
  const InventoryScreen({super.key});

  @override
  State<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends State<InventoryScreen> {
  List<dynamic> _inventoryItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchInventory();
  }

  Future<void> _fetchInventory() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/v1/inventory'));
      if (response.statusCode == 200) {
        setState(() {
          _inventoryItems = json.decode(response.body);
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching inventory: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Warehouse Stock', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF2D2B2A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => _isLoading = true);
              _fetchInventory();
            },
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF588157)))
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: _inventoryItems.length,
              itemBuilder: (context, index) {
                final item = _inventoryItems[index];
                return Card(
                  color: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: const Color(0xFF588157).withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                          child: Text(item['sku'], style: const TextStyle(color: Color(0xFF588157), fontSize: 12, fontWeight: FontWeight.bold)),
                        ),
                        const Spacer(),
                        Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF2D2B2A)), maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('PKR ${item['price']}', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                            Text('${item['qty']} in stock', style: TextStyle(fontWeight: FontWeight.bold, color: item['qty'] < 10 ? Colors.red : const Color(0xFF588157))),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}