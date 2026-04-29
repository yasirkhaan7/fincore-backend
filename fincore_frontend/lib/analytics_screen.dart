import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  List<dynamic> _chartData = [];
  bool _isLoading = true;
  double _maxValue = 0.0;

  @override
  void initState() {
    super.initState();
    _fetchChartData();
  }

  Future<void> _fetchChartData() async {
    try {
      final response = await http.get(Uri.parse('http://127.0.0.1:8000/api/v1/analytics/inventory-chart'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        double maxVal = 0;
        for (var item in data) {
          if (item['value'] > maxVal) maxVal = item['value'].toDouble();
        }
        setState(() {
          _chartData = data;
          _maxValue = maxVal == 0 ? 1 : maxVal; // Prevent division by zero
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching chart: $e');
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Executive Insights', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF2D2B2A),
        foregroundColor: Colors.white,
      ),
      backgroundColor: const Color(0xFFE9ECEF),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF588157)))
          : Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Inventory Valuation', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF2D2B2A))),
                  const Text('Total PKR value of physical stock by product', style: TextStyle(color: Colors.grey)),
                  const SizedBox(height: 32),
                  
                  // THE CUSTOM PURE-FLUTTER BAR CHART
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _chartData.map((data) {
                          final double heightPercentage = data['value'] / _maxValue;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              // The Value Tooltip
                              Text('PKR\n${data['value']}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
                              const SizedBox(height: 8),
                              // The Bar
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 800),
                                curve: Curves.easeOutQuart,
                                width: 50,
                                // Calculate height relative to the max value (max 300 pixels tall)
                                height: 300 * heightPercentage, 
                                decoration: BoxDecoration(
                                  color: const Color(0xFF588157),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                              ),
                              const SizedBox(height: 12),
                              // The Label
                              SizedBox(
                                width: 60,
                                child: Text(data['name'], textAlign: TextAlign.center, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF2D2B2A))),
                              )
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}