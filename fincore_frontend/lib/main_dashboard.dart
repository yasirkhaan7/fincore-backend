import 'package:flutter/material.dart';
import 'pos_screen.dart';
import 'ledger_screen.dart';
import 'inventory_screen.dart';
import 'suppliers_screen.dart'; // <--- Make sure this line is exactly here
import 'analytics_screen.dart';

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  int _currentIndex = 0;

  // 2. Updated Screen List (Now has 4 items)
  final List<Widget> _screens = [
    const POSScreen(),
    const InventoryScreen(),
    const LedgerScreen(),
    const SuppliersScreen(),
    const AnalyticsScreen(), 
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        // Professional ERP Theme
        type: BottomNavigationBarType.fixed, // Essential when you have 4+ items
        selectedItemColor: const Color(0xFF588157),
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        elevation: 15,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
        
        // 3. Updated Navigation Items
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.point_of_sale_rounded), 
            label: 'POS'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory_2_outlined), 
            label: 'Inventory'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet_outlined), 
            label: 'Ledger'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping_outlined), // Professional Vendor/Supplier icon
            label: 'Suppliers'
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart_rounded), 
            label: 'Insights'
          ),
        ],
      ),
    );
  }
}