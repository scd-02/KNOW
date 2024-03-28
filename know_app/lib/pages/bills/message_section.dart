import 'package:flutter/material.dart';

class MessageSection extends StatelessWidget {
  const MessageSection({
    Key? key,
    required this.transactionInfoList,
  }) : super(key: key);

  final List<Map<String, dynamic>> transactionInfoList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactionInfoList.length,
      itemBuilder: (context, index) {
        return _buildMessageContainer(transactionInfoList[index]);
      },
    );
  }

  Widget _buildMessageContainer(Map<String, dynamic> transactionInfo) {
    double amount = transactionInfo['amount'];
    String? accountNumber = transactionInfo['accountNumber'];
    String date = transactionInfo['date'];
    String time = transactionInfo['time'];
    String transactionId = transactionInfo['transactionId'];
    String type = transactionInfo['transactionType'];

    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              type,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Amount: $amount',
                  style: const TextStyle(fontSize: 16, color: Colors.grey)),
                const Spacer(),
                Text('Date: $date',
                  style: const TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Account Number: $accountNumber',
                  style: const TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Text('Time: $time',
                  style: const TextStyle(fontSize: 16, color: Colors.grey)),
                const Spacer(),
                Text('Transaction ID: $transactionId',
                  style: const TextStyle(fontSize: 16, color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
