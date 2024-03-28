import 'package:flutter/material.dart';

class TotalAmountSection extends StatelessWidget {
  final double totalCreditedAmount;
  final double totalDebitedAmount;

  const TotalAmountSection({
    Key? key,
    required this.totalCreditedAmount,
    required this.totalDebitedAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Round credited and debited amounts to two decimal places
    String creditedAmountString = totalCreditedAmount.toStringAsFixed(2);
    String debitedAmountString = totalDebitedAmount.toStringAsFixed(2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Total Credited Amount: $creditedAmountString',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text('Total Debited Amount: $debitedAmountString',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
