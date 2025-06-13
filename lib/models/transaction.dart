class Transaction {
  final String title;
  final String subtitle;
  final double amount;
  final bool isPositive;
  final DateTime createdAt;

  Transaction({
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.isPositive,
    required this.createdAt,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      title: json['title']?.toString() ?? '',
      subtitle: json['subtitle']?.toString() ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      isPositive: json['isPositive'] ?? false,
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'subtitle': subtitle,
      'amount': amount,
      'isPositive': isPositive,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
