// services/transaction_service.dart
import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:moneyger_3_24/models/transaction.dart';
import 'package:moneyger_3_24/utils/constants.dart';

class TransactionService {
  static const String _contentType = 'application/json';

  /// Get current balance from server
  Future<double> getBalance() async {
    try {
      final response = await http.get(
        Uri.parse('${AppUrls.gasUrl}?action=getBalance'),
        headers: {'Content-Type': _contentType},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return (data['balance'] ?? 0).toDouble();
        } else {
          throw Exception(data['error'] ?? 'Failed to load balance');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      log('Error loading balance: $e');
      rethrow;
    }
  }

  /// Get transactions list from server
  Future<List<Transaction>> getTransactions() async {
    try {
      final response = await http.get(
        Uri.parse('${AppUrls.gasUrl}?action=getTransactions'),
        headers: {'Content-Type': _contentType},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        log(data.toString());
        if (data['success']) {
          return (data['transactions'] as List).map((item) => Transaction.fromJson(item)).toList();
        } else {
          throw Exception(data['error'] ?? 'Failed to load transactions');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      log('Error loading transactions: $e');
      rethrow;
    }
  }

  /// Add new transaction to server
  Future<String> addTransaction({
    required String title,
    required String subtitle,
    required double amount,
    required bool isPositive,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(AppUrls.gasUrl),
        headers: {'Content-Type': _contentType},
        body: json.encode({
          'action': 'addTransaction',
          'title': title,
          'subtitle': subtitle,
          'amount': amount.toString(),
          'isPositive': isPositive,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success']) {
          return data['message'] ?? 'Transaction added successfully';
        } else {
          throw Exception(data['error'] ?? 'Failed to add transaction');
        }
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } catch (e) {
      log('Error adding transaction: $e');
      rethrow;
    }
  }
}
