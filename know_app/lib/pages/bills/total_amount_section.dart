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
    String creditedAmountString = 'Rs. ${totalCreditedAmount.toStringAsFixed(2)}';
    String debitedAmountString = 'Rs. ${totalDebitedAmount.toStringAsFixed(2)}';

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              creditedAmountString,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Container(
          width: MediaQuery.of(context).size.width * 0.4,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Text(
              debitedAmountString,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
