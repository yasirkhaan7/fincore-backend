import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LedgerScreen extends StatefulWidget {
  const LedgerScreen({super.key});

  @override
  State<LedgerScreen> createState() => _LedgerScreenState();
}

class _LedgerScreenState extends State<LedgerScreen> {
  bool _isExporting = false;

  Future<void> _exportLedger() async {
    setState(() => _isExporting = true);
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/v1/export/ledger'));
      
      if (response.statusCode == 200 && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Report successfully saved to your Downloads folder!'),
            backgroundColor: Color(0xFF588157),
            duration: Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      print('Export error: $e');
    } finally {
      setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('General Ledger', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF2D2B2A),
        foregroundColor: Colors.white,
        actions: [
          // THE NEW EXPORT BUTTON
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF588157),
                foregroundColor: Colors.white,
              ),
              icon: _isExporting 
                  ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Icon(Icons.download),
              label: const Text('Export CSV'),
              onPressed: _isExporting ? null : _exportLedger,
            ),
          )
        ],
      ),
      body: const Center(
        child: Text(
          'Ledger Data Goes Here', 
          style: TextStyle(color: Colors.grey, fontSize: 18)
        ),
      ),
    );
  }
}