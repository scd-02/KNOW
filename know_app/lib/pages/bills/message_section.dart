// import 'package:flutter/material.dart';

// class MessageSection extends StatelessWidget {
//   const MessageSection({
//     Key? key,
//     required this.transactionInfoList,
//   }) : super(key: key);

//   final List<Map<String, dynamic>> transactionInfoList;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: transactionInfoList.map((transactionInfo) {
//         return _buildMessageContainer(transactionInfo);
//       }).toList(),
//     );
//   }

/// message_container.dart
import 'package:flutter/material.dart';

Widget buildMessageContainer(Map<String, dynamic> transactionInfo) {
  double amount = transactionInfo['amount'];
  String? accountNumber = transactionInfo['accountNumber'];
  String date = transactionInfo['date'];
  String time = transactionInfo['time'];
  String transactionId = transactionInfo['transactionId'];
  String type = transactionInfo['transactionType'];

  return Container(
    padding: const EdgeInsets.all(10),
    margin: const EdgeInsets.symmetric(vertical: 5),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          type,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Text(
              'Amount: $amount',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const Spacer(),
            Text(
              'Date: $date',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            Text(
              'A|C: $accountNumber',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const Spacer(),
            Text(
              'Time: $time',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const Spacer(),
            Text(
              'T-ID: $transactionId',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ],
    ),
  );
}
