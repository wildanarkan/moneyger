// controllers/home_controller.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneyger_3_24/models/transaction.dart';
import 'package:moneyger_3_24/services/transaction_service.dart';

class HomeController extends GetxController {
  final TransactionService _transactionService = TransactionService();

  // Observable variables
  final _balance = 0.0.obs;
  final _transactions = <Transaction>[].obs;
  final _isLoading = true.obs;
  final _errorMessage = ''.obs;

  // Getters
  double get balance => _balance.value;
  List<Transaction> get transactions => _transactions;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  /// Load all data (balance + transactions)
  Future<void> loadData() async {
    try {
      _isLoading.value = true;
      _errorMessage.value = '';

      await Future.wait([
        loadBalance(),
        loadTransactions(),
      ]);
    } catch (e) {
      _errorMessage.value = 'Failed to load data: $e';
    } finally {
      _isLoading.value = false;
    }
  }

  /// Load balance from server
  Future<void> loadBalance() async {
    try {
      final result = await _transactionService.getBalance();
      _balance.value = result;
    } catch (e) {
      rethrow;
    }
  }

  /// Load transactions from server
  Future<void> loadTransactions() async {
    try {
      final result = await _transactionService.getTransactions();
      _transactions.value = result;
    } catch (e) {
      rethrow;
    }
  }

  /// Add new transaction
  Future<void> addTransaction({
    required String title,
    required String subtitle,
    required double amount,
    required bool isPositive,
  }) async {
    try {
      final message = await _transactionService.addTransaction(
        title: title,
        subtitle: subtitle,
        amount: amount,
        isPositive: isPositive,
      );

      // Reload data after successful addition
      await loadData();

      // Show success message
      Get.snackbar(
        'Success',
        message,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    } catch (e) {
      // Show error message
      Get.snackbar(
        'Error',
        'Failed to add transaction: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
      );
    }
  }

  /// Get preset buttons based on transaction type
  List<Map<String, String>> getPresetButtons(bool isIncome) {
    if (isIncome) {
      return [
        {'title': 'Salary', 'subtitle': 'Monthly salary'},
        {'title': 'Freelance', 'subtitle': 'Freelance project'},
        {'title': 'Bonus', 'subtitle': 'Performance bonus'},
        {'title': 'Investment', 'subtitle': 'Investment return'},
        {'title': 'Gift', 'subtitle': 'Money gift'},
      ];
    } else {
      return [
        {'title': 'Food', 'subtitle': 'Meals and snacks'},
        {'title': 'Transportation', 'subtitle': 'Travel expenses'},
        {'title': 'Shopping', 'subtitle': 'Shopping expenses'},
        {'title': 'Bills', 'subtitle': 'Utility bills'},
        {'title': 'Entertainment', 'subtitle': 'Movies, games, etc'},
      ];
    }
  }

  /// Format currency (Rupiah)
  String formatCurrency(double amount) {
    return 'Rp ${amount.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        )}';
  }

  /// Show report feature coming soon message
  void showReportComingSoon() {
    Get.snackbar(
      'Info',
      'Report feature coming soon!',
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16),
    );
  }
}
