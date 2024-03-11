import 'package:flutter/material.dart';
// import 'package:flutter_sms_inbox/flutter_sms_inbox.dart';
import 'package:know/components/commonWidgets/app_bar.dart';
import 'package:telephony/telephony.dart';
// import 'package:permission_handler/permission_handler.dart';

class BillsMessage extends StatefulWidget {
  const BillsMessage({Key? key}) : super(key: key);

  @override
  State<BillsMessage> createState() => _BillsMessageState();
}

class _BillsMessageState extends State<BillsMessage> {
  // final SmsQuery _query = SmsQuery();
  final Telephony telephony = Telephony.instance;
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
          // var permission = await Permission.sms.request();
          bool? permission = await telephony.requestPhoneAndSmsPermissions;
          if (permission == true) {
            if (_startDate == null || _endDate == null) {
              // Show an error message or handle the case where dates are not selected
              return;
            }

            // final messages = await _query.querySms(kinds: [SmsQueryKind.inbox]);

            List<String?> creditedMessages = [];
            List<String?> debitedMessages = [];
            double creditedAmount = 0.0;
            double debitedAmount = 0.0;

            List<String> bankNameList = [
              "axisbk",
              "jrgbnk",
              "sbiupi",
              "sbipsg",
              "cbssbi",
              "unionb",
              "hdfcbk",
              "fedbnk",
              "kotakb"
            ];

            List<SmsMessage> messages = [];

            for (var bankName in bankNameList) {
              List<SmsMessage> bankMessages = await telephony.getInboxSms(
                columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
                filter: SmsFilter.where(SmsColumn.ADDRESS)
                    .like('%$bankName')
                    .and(SmsColumn.DATE)
                    .greaterThanOrEqualTo(
                        _startDate!.millisecondsSinceEpoch.toString())
                    .and(SmsColumn.DATE)
                    .lessThanOrEqualTo((_endDate!.add(const Duration(days: 1)))
                        .millisecondsSinceEpoch
                        .toString()), // Ensure the end date includes the entire day
                sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
              );
              messages.addAll(bankMessages);
            }

            messages.sort((a, b) => (b.date ?? 0).compareTo(a.date ?? 0));

            for (var message in messages) {
              // if message.body is null, it will assign an empty string ('') to body
              String body = (message.body ?? '').replaceAll('\n', ' ');
              double amount = _extractAmount(body);

              //if (body.contains('UPI') || body.contains('IMPS') || body.contains('NEFT') || body.contains('UPI LITE') || body.contains('NPCI') || body.contains('POS') || body.contains('AePS') || body.contains('MPOS') || body.contains('BBPS') || body.contains('NETS') || body.contains('RFID') || body.contains('e-RUPI') || body.contains('UPI 123PAY') || body.contains('SELF'))

              print('Message: $body');
              if (body.toLowerCase().contains('credit') ||
                  body.toLowerCase().contains('credited')) {
                creditedMessages.add(body);
                creditedAmount += amount;
              } else if ((body.toLowerCase().contains('debit') ||
                  body.toLowerCase().contains('debited'))) {
                debitedMessages.add(body);
                debitedAmount += amount;
                print(amount);
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

  double _extractAmount(String body) {
    RegExp regExp = RegExp(r'\b(?:0|[1-9]\d*)\.\d+\b');
    Match? match = regExp.firstMatch(body);
    return match != null ? double.parse(match.group(0)!) : 0.0;
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
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        if (messages.isNotEmpty)
          SizedBox(
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
