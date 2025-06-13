// widgets/add_transaction_dialog.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moneyger_3_24/controllers/home_controller.dart';

class AddTransactionDialog extends StatelessWidget {
  final bool isIncome;
  final HomeController controller = Get.find<HomeController>();

  AddTransactionDialog({super.key, required this.isIncome});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController();
    final subtitleController = TextEditingController();
    final amountController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.85,
            maxWidth: MediaQuery.of(context).size.width,
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildTypeIndicator(),
                    const SizedBox(height: 16),
                    _buildPresetButtons(titleController, subtitleController),
                    const SizedBox(height: 16),
                    _buildTitleField(titleController),
                    const SizedBox(height: 16),
                    _buildSubtitleField(subtitleController),
                    const SizedBox(height: 16),
                    _buildAmountField(amountController),
                    const SizedBox(height: 20),
                    _buildActionButtons(
                      context,
                      formKey,
                      titleController,
                      subtitleController,
                      amountController,
                    ),
                    const SizedBox(height: 8),
                    _buildInfoText(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: isIncome ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isIncome ? Icons.add_circle_outline : Icons.remove_circle_outline,
            color: isIncome ? Colors.green[600] : Colors.red[600],
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Add ${isIncome ? 'Income' : 'Expense'}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                isIncome ? 'Record money you received' : 'Record money you spent',
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTypeIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isIncome ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isIncome ? Colors.green[200]! : Colors.red[200]!,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isIncome ? Icons.trending_up : Icons.trending_down,
            size: 14,
            color: isIncome ? Colors.green[600] : Colors.red[600],
          ),
          const SizedBox(width: 6),
          Text(
            'Type: ${isIncome ? 'Income (+)' : 'Expense (-)'}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isIncome ? Colors.green[700] : Colors.red[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPresetButtons(
    TextEditingController titleController,
    TextEditingController subtitleController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Select:',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 6),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: controller
                .getPresetButtons(isIncome)
                .map(
                  (preset) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () {
                        titleController.text = preset['title']!;
                        subtitleController.text = preset['subtitle']!;
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: Text(
                          preset['title']!,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildTitleField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      textCapitalization: TextCapitalization.words,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Title *',
        hintText: isIncome ? 'e.g., Salary, Freelance, Bonus' : 'e.g., Groceries, Transportation, Bills',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        prefixIcon: Icon(
          isIncome ? Icons.work_outline : Icons.shopping_cart_outlined,
          color: isIncome ? Colors.green[600] : Colors.red[600],
          size: 20,
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter a title';
        }
        return null;
      },
    );
  }

  Widget _buildSubtitleField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      textCapitalization: TextCapitalization.sentences,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        labelText: 'Description',
        hintText: isIncome ? 'e.g., Monthly salary from company' : 'e.g., Weekly grocery shopping',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        prefixIcon: Icon(
          Icons.description_outlined,
          color: Colors.grey[600],
          size: 20,
        ),
      ),
    );
  }

  Widget _buildAmountField(TextEditingController controller) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelText: 'Amount *',
        hintText: '0',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        prefixIcon: Container(
          padding: const EdgeInsets.all(12),
          child: Text(
            'Rp',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),
        suffixIcon: Icon(
          Icons.attach_money,
          color: isIncome ? Colors.green[600] : Colors.red[600],
          size: 20,
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter an amount';
        }
        final amount = double.tryParse(value.trim());
        if (amount == null || amount <= 0) {
          return 'Please enter a valid amount';
        }
        return null;
      },
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    GlobalKey<FormState> formKey,
    TextEditingController titleController,
    TextEditingController subtitleController,
    TextEditingController amountController,
  ) {
    return Row(
      children: [
        Expanded(
          child: TextButton(
            onPressed: () => Navigator.pop(context),
            style: TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Cancel',
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                // Hide keyboard before processing
                FocusScope.of(context).unfocus();

                final amount = double.parse(amountController.text.trim());
                controller.addTransaction(
                  title: titleController.text.trim(),
                  subtitle: subtitleController.text.trim(),
                  amount: amount,
                  isPositive: isIncome,
                );
                Navigator.pop(context);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: isIncome ? Colors.green[600] : Colors.red[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 2,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isIncome ? Icons.add : Icons.remove,
                  size: 18,
                ),
                const SizedBox(width: 6),
                Text(
                  'Add ${isIncome ? 'Income' : 'Expense'}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoText() {
    return Text(
      '* Required fields',
      style: TextStyle(
        fontSize: 11,
        color: Colors.grey[500],
      ),
    );
  }
}
