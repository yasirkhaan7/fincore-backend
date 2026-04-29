import 'package:flutter/material.dart';
import 'customers_screen.dart'; // Brings in your new CRM screen

class POSScreen extends StatefulWidget {
  const POSScreen({super.key});

  @override
  State<POSScreen> createState() => _POSScreenState();
}

class _POSScreenState extends State<POSScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Current Sale', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF2D2B2A),
        foregroundColor: Colors.white,
        actions: [
          // The CRM Button
          IconButton(
            icon: const Icon(Icons.people_alt_outlined),
            tooltip: 'Customer CRM',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CustomersScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      backgroundColor: const Color(0xFFE9ECEF),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.point_of_sale, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Cash Register Ready',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2D2B2A)),
            ),
            SizedBox(height: 8),
            Text(
              'Scan an item or tap the People icon to attach a VIP Customer.',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}