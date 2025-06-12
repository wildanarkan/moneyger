class Transaction {
  final String title;
  final String subtitle;
  final double amount;
  final bool isPositive;
  final String date;

  Transaction({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isPositive,
    required this.date,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      isPositive: json['isPositive'] ?? false,
      date: json['date'] ?? '',
    );
  }
}
