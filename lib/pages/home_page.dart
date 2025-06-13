// views/home_page.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneyger_3_24/controllers/home_controller.dart';
import 'package:moneyger_3_24/widgets/add_transaction_dialog.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      backgroundColor: Colors.grey[50],
      // Tambahkan resizeToAvoidBottomInset untuk menghindari konflik keyboard
      resizeToAvoidBottomInset: true,
      body: RefreshIndicator(
        onRefresh: controller.loadData,
        child: Column(
          children: [
            _buildBalanceSection(context, controller),
            const SizedBox(height: 100),
            _buildRecentTransactionsHeader(),
            Expanded(
              child: _buildTransactionsList(controller),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceSection(BuildContext context, HomeController controller) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.32,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            color: Colors.green[600],
          ),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Total Balance',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Obx(() {
                  if (controller.isLoading) {
                    return const CircularProgressIndicator(color: Colors.white);
                  }
                  return Text(
                    controller.formatCurrency(controller.balance),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  );
                }),
                Obx(() {
                  if (controller.errorMessage.isNotEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        controller.errorMessage,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: -90,
          child: _buildActionButtons(controller),
        ),
      ],
    );
  }

  Widget _buildActionButtons(HomeController controller) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(50),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildActionButton(
            icon: Icons.add_circle_outline,
            label: 'Income',
            color: Colors.green,
            onTap: () => _showAddTransactionDialog(true),
          ),
          _buildDivider(),
          _buildActionButton(
            icon: Icons.remove_circle_outline,
            label: 'Expense',
            color: Colors.red,
            onTap: () => _showAddTransactionDialog(false),
          ),
          _buildDivider(),
          _buildActionButton(
            icon: Icons.bar_chart_rounded,
            label: 'Report',
            color: Colors.blue,
            onTap: controller.showReportComingSoon,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          // Tambahkan splashColor dan highlightColor untuk menghindari conflict
          splashColor: color.withOpacity(0.1),
          highlightColor: color.withOpacity(0.05),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    icon,
                    color: color,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey[200],
    );
  }

  Widget _buildRecentTransactionsHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Recent Transactions',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          GestureDetector(
            onTap: () {
              // Navigate to all transactions page
              Get.snackbar(
                'Info',
                'All transactions page coming soon!',
                backgroundColor: Colors.blue,
                colorText: Colors.white,
                snackPosition: SnackPosition.BOTTOM,
                margin: const EdgeInsets.all(16),
              );
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View All',
                  style: TextStyle(
                    color: Colors.green[600],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 14,
                  color: Colors.green[600],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionsList(HomeController controller) {
    return Obx(() {
      if (controller.isLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (controller.transactions.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long,
                size: 64,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 16),
              Text(
                'No transactions yet',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Add your first transaction using the buttons above',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: controller.transactions.length,
        // Tambahkan keyboardDismissBehavior untuk menghindari conflict
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        itemBuilder: (context, index) {
          final transaction = controller.transactions[index];
          return _buildTransactionItem(
            controller: controller,
            title: transaction.title,
            subtitle: transaction.subtitle,
            amount: transaction.amount,
            isPositive: transaction.isPositive,
            isLast: index == controller.transactions.length - 1,
          );
        },
      );
    });
  }

  Widget _buildTransactionItem({
    required HomeController controller,
    required String title,
    required String subtitle,
    required double amount,
    required bool isPositive,
    bool isLast = false,
  }) {
    return Container(
      margin: EdgeInsets.only(
        bottom: isLast ? 30 : 12,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isPositive ? Icons.add_circle_outline : Icons.remove_circle_outline,
              color: isPositive ? Colors.green[600] : Colors.red[600],
              size: 22,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${isPositive ? '+' : '-'}${controller.formatCurrency(amount)}',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isPositive ? Colors.green[600] : Colors.red[600],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddTransactionDialog(bool isIncome) {
    // Pastikan tidak ada focus yang tersisa sebelum membuka dialog
    FocusManager.instance.primaryFocus?.unfocus();

    // Tambahkan delay kecil untuk memastikan keyboard sudah hilang
    Future.delayed(const Duration(milliseconds: 100), () {
      Get.dialog(
        AddTransactionDialog(isIncome: isIncome),
        barrierDismissible: false,
        // Tambahkan parameter untuk menghindari auto focus issue
        useSafeArea: true,
      );
    });
  }
}
