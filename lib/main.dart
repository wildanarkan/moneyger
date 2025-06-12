import 'package:flutter/material.dart';
import 'package:moneyger_3_24/pages/home_page.dart';

void main() {
  runApp(const MoneygerApp());
}

class MoneygerApp extends StatelessWidget {
  const MoneygerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(title: 'Moneyger', home: HomePage());
  }
}
