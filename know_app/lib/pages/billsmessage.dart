import 'package:flutter/material.dart';
import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:know/components/commonWidgets/app_bar.dart';
import 'package:permission_handler/permission_handler.dart';

class BillsMessage extends StatefulWidget {
  const BillsMessage({Key? key}) : super(key: key);

  @override
  State<BillsMessage> createState() => _BillsMessageState();
}

class _BillsMessageState extends State<BillsMessage> {
  final SmsQuery _query = SmsQuery();
  List<String?> _creditedMessages = [];
  List<String?> _debitedMessages = [];
  DateTime? _startDate;
  DateTime? _endDate;
  double totalCreditedAmount = 0.0;
  double totalDebitedAmount = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppBar(title: 'Bills Messages'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _DateFilter(
              onStartDateSelected: (date) => _startDate = date,
              onEndDateSelected: (date) => _endDate = date,
            ),
            const SizedBox(height: 10),
            _MessageSection(title: 'Credited', messages: _creditedMessages),
            const SizedBox(height: 10),
            _MessageSection(title: 'Debited', messages: _debitedMessages),
            const SizedBox(height: 10),
            _TotalAmountSection(
              totalCreditedAmount: totalCreditedAmount,
              totalDebitedAmount: totalDebitedAmount,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var permission = await Permission.sms.request();
          if (permission.isGranted) {
            if (_startDate == null || _endDate == null) {
              // Show an error message or handle the case where dates are not selected
              return;
            }

            final messages = await _query.querySms(kinds: [SmsQueryKind.inbox]);

            List<String?> creditedMessages = [];
            List<String?> debitedMessages = [];
            double creditedAmount = 0.0;
            double debitedAmount = 0.0;

            for (var message in messages) {
              String? body = message.body;
              DateTime? messageDate = message.date ?? DateTime.now();

              if (body != null &&
                  (messageDate.isAtSameMomentAs(_startDate!) ||
                      (messageDate.isAfter(_startDate!) &&
                          messageDate
                              .isBefore(_endDate!.add(Duration(days: 1)))))) {
                if (body.toLowerCase().contains('credit') ||
                    body.toLowerCase().contains('credited')) {
                  // Check for 'INR' or 'Rs' in credited message
                  if (body.toLowerCase().contains('inr') ||
                      body.toLowerCase().contains('rs')) {
                    creditedMessages.add(body);

                    // Extract amount from message containing 'INR' or 'Rs'
                    RegExp regExp = RegExp(r'(INR|Rs)[^0-9]*(-?\d+(\.\d+)?)');
                    Match? match = regExp.firstMatch(body);
                    if (match != null) {
                      double amount = double.parse(match.group(2)!);
                      creditedAmount += amount;
                    }
                  } else if (!body.toLowerCase().contains('inr') &&
                      !body.toLowerCase().contains('rs')) {
                    // Extract amount from message containing 'INR' or 'Rs'
                    RegExp regExp = RegExp(r'\b(?:0|[1-9]\d*)\.\d+\b');
                    Match? match = regExp.firstMatch(body);
                    if (match != null) {
                      creditedMessages.add(body);
                      double amount = double.parse(match.group(0)!);
                      creditedAmount += amount;
                    }
                  }
                } else if (body.toLowerCase().contains('debit') ||
                    body.toLowerCase().contains('debited')) {
                  // Check for 'INR' or 'Rs' in debited message
                  if (body.toLowerCase().contains('inr') ||
                      body.toLowerCase().contains('rs')) {
                    debitedMessages.add(body);

                    // Extract amount from message containing 'INR' or 'Rs'
                    RegExp regExp = RegExp(r'(INR|Rs)[^0-9]*(-?\d+(\.\d+)?)');
                    Match? match = regExp.firstMatch(body);
                    if (match != null) {
                      double amount = double.parse(match.group(2)!);
                      debitedAmount += amount;
                    }
                  } else if (!body.toLowerCase().contains('inr') &&
                      !body.toLowerCase().contains('rs')) {
                    // Extract amount from message containing 'INR' or 'Rs'
                    RegExp regExp = RegExp(r'\b(?:0|[1-9]\d*)\.\d+\b');
                    Match? match = regExp.firstMatch(body);
                    if (match != null) {
                      debitedMessages.add(body);
                      double amount = double.parse(match.group(0)!);
                      debitedAmount += amount;
                    }
                  }
                }
              }
            }

            setState(() {
              _creditedMessages = creditedMessages;
              _debitedMessages = debitedMessages;
              totalCreditedAmount = creditedAmount;
              totalDebitedAmount = debitedAmount;
            });
          }
        },
        child: const Icon(Icons.refresh),
      ),
    );
  }
}

class _DateFilter extends StatelessWidget {
  final Function(DateTime)? onStartDateSelected;
  final Function(DateTime)? onEndDateSelected;

  const _DateFilter({
    Key? key,
    this.onStartDateSelected,
    this.onEndDateSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (selectedDate != null && onStartDateSelected != null) {
              onStartDateSelected!(selectedDate);
            }
          },
          child: const Text('Start Date'),
        ),
        ElevatedButton(
          onPressed: () async {
            DateTime? selectedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (selectedDate != null && onEndDateSelected != null) {
              onEndDateSelected!(selectedDate);
            }
          },
          child: const Text('End Date'),
        ),
      ],
    );
  }
}

class _MessageSection extends StatelessWidget {
  const _MessageSection({
    Key? key,
    required this.title,
    required this.messages,
  }) : super(key: key);

  final String title;
  final List<String?> messages;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        if (messages.isNotEmpty)
          Container(
            height: 200, // Set a fixed height or use Expanded
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index]!),
                );
              },
            ),
          )
        else
          Text('No $title messages to show.'),
      ],
    );
  }
}

class _TotalAmountSection extends StatelessWidget {
  final double totalCreditedAmount;
  final double totalDebitedAmount;

  const _TotalAmountSection({
    Key? key,
    required this.totalCreditedAmount,
    required this.totalDebitedAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Total Credited Amount: $totalCreditedAmount',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Text('Total Debited Amount: $totalDebitedAmount',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
