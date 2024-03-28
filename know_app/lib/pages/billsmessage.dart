import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'dart:convert';
import 'package:know/components/commonWidgets/app_bar.dart';
import 'package:telephony/telephony.dart';
import 'bills/date_filter.dart';
import 'bills/bank_names.dart';
import 'bills/message_section.dart';
import 'bills/total_amount_section.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BillsMessage extends StatefulWidget {
  const BillsMessage({Key? key}) : super(key: key);

  @override
  State<BillsMessage> createState() => _BillsMessageState();
}

class _BillsMessageState extends State<BillsMessage> {
  final Telephony telephony = Telephony.instance;
  List<String?> _creditedMessages = [];
  List<String?> _debitedMessages = [];
  DateTime? _startDate;
  DateTime? _endDate;
  double totalCreditedAmount = 0.0;
  double totalDebitedAmount = 0.0;

  late SharedPreferences _prefs;
  final Map<String, dynamic> bankTemplates = {};
  Set<String> promotionalMessageList = {};

  @override
  void initState() {
    super.initState();
    _loadBankTemplates(); // Load bank templates from local storage when the widget is initialized
    _loadPromotionalMessageList(); // Load promotional message list from local storage when the widget is initialized
  }

  Future<void> _loadBankTemplates() async {
    _prefs = await SharedPreferences.getInstance();
    // Load bank templates from local storage
    final String? bankTemplatesJson = _prefs.getString('bank_templates');
    if (bankTemplatesJson != null) {
      setState(() {
        // bankTemplates
        //     .clear(); // Clear the map before loading from local storage
        bankTemplates.addAll(json.decode(bankTemplatesJson));
      });
    }
  }

  Future<void> _saveBankTemplates() async {
    // Save bank templates to local storage
    await _prefs.setString('bank_templates', json.encode(bankTemplates));
  }

  // promotional Message

  Future<void> _loadPromotionalMessageList() async {
    _prefs = await SharedPreferences.getInstance();
    // Load promotional message list from local storage
    final String? promotionalMessageJson =
        _prefs.getString('promotional_message');
    if (promotionalMessageJson != null) {
      setState(() {
        // promotionalMessageList
        //     .clear(); // Clear the map before loading from local storage
        promotionalMessageList.addAll(json.decode(promotionalMessageJson));
      });
    }
  }

  Future<void> _savePromotionalMessageList() async {
    // Save bank templates to local storage
    await _prefs.setString(
        'promotional_message', json.encode(promotionalMessageList));
  }

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
            DateFilter(
              onStartDateSelected: (date) => _startDate = date,
              onEndDateSelected: (date) => _endDate = date,
            ),
            const SizedBox(height: 10),
            MessageSection(title: 'Credited', messages: _creditedMessages),
            const SizedBox(height: 10),
            MessageSection(title: 'Debited', messages: _debitedMessages),
            const SizedBox(height: 10),
            TotalAmountSection(
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

            List<String?> creditedMessages = [];
            List<String?> debitedMessages = [];
            double creditedAmount = 0.0;
            double debitedAmount = 0.0;

            Set<String> userBankNameList = {};

            List<SmsMessage> userMessageHeader = await telephony.getInboxSms(
              columns: [SmsColumn.ADDRESS],
              filter: SmsFilter.where(SmsColumn.ADDRESS).like('%-%'),
            );

            for (SmsMessage messageHeader in userMessageHeader) {
              String? address = messageHeader.address;
              if (address != null) {
                int lastIndex = address.lastIndexOf('-') + 1;
                String substring = address.substring(lastIndex);
                if (bankNameList.contains(substring)) {
                  userBankNameList.add(substring);
                }
              }
            }

            final String endDateString =
                (_endDate!.add(const Duration(days: 1)))
                    .millisecondsSinceEpoch
                    .toString();

            final String startDateString =
                _startDate!.millisecondsSinceEpoch.toString();

            List<SmsMessage> bankMessages = [];

            for (var bankName in userBankNameList) {
              bankName = bankName.toLowerCase();
              bankMessages += await telephony.getInboxSms(
                columns: [SmsColumn.ADDRESS, SmsColumn.BODY, SmsColumn.DATE],
                filter: SmsFilter.where(SmsColumn.ADDRESS)
                    .like('%$bankName')
                    .and(SmsColumn.DATE)
                    .greaterThanOrEqualTo(startDateString)
                    .and(SmsColumn.DATE)
                    .lessThanOrEqualTo(endDateString),
                // sortOrder: [OrderBy(SmsColumn.DATE, sort: Sort.DESC)],
              );
            }

            Future<bool> updateTemplate(String bankName, String message) async {
              try {
                print(bankName);
                print(message);
                var response = await Dio().put(
                  'http://192.168.124.139:8000/bank/update',
                  data: {
                    'bankName': bankName,
                    'message': message,
                  },
                );
                if (response.statusCode == 200 &&
                    response.data['success'] == true) {
                  // Template added successfully, update bankTemplates
                  var newTemplate = response.data['data']['template'];
                  bankTemplates[bankName] = newTemplate;
                  print(
                      'Unmatched Template removed successfully for bank $bankName');
                  return true;
                } else {
                  print(
                      'Failed to remove unmatched template for bank $bankName');
                  return false;
                }
              } catch (e) {
                print('Error adding template for bank $bankName: $e');
              }
              return false;
            }

            Map<String, dynamic> transactionInfo = {};
            List<Map<String, dynamic>> transactionInfoList = [];

            void createTransactionInfo(List<dynamic> bankObjList,
                Map<String, dynamic> transactionInfo, String body) {
              for (var bankObj in bankObjList) {
                var regex = RegExp(bankObj['regexPattern']);
                var match = regex.firstMatch(body);
                var propertyMapString = bankObj['propertyMap'];
                var propertyMap = json.decode(propertyMapString);
                transactionInfo = {
                  'accountNumber': int.parse(
                              propertyMap['accountNumber'].toString()) ==
                          -1
                      ? ""
                      : match!.group(
                          int.parse(propertyMap['accountNumber'].toString())),
                  'date': int.parse(propertyMap['date'].toString()) == -1
                      ? ""
                      : match!.group(int.parse(propertyMap['date'].toString())),
                  'time': int.parse(propertyMap['time'].toString()) == -1
                      ? ""
                      : match!.group(int.parse(propertyMap['time'].toString())),
                  'transactionId': int.parse(
                              propertyMap['transactionId'].toString()) ==
                          -1
                      ? ""
                      : match!.group(
                          int.parse(propertyMap['transactionId'].toString())),
                  'transactionType': bankObj['transactionType'],
                };

                // Extract amount if it exists in propertyMap
                if (propertyMap.containsKey('amount')) {
                  var amountIndex = propertyMap['amount'];
                  var amountString = match?.group(amountIndex);
                  if (amountString != null) {
                    // Remove commas from the amount string
                    var cleanedAmountString = amountString.replaceAll(",", "");
                    // Convert the cleaned amount string to a double
                    transactionInfo['amount'] =
                        double.parse(cleanedAmountString);
                  } else {
                    // Handle the case when amount is not captured
                    transactionInfo['amount'] =
                        null; // Or any other default value
                  }
                } else {
                  transactionInfo['amount'] = null;
                }

                // Check if body contains 'credit' or 'debit' and set type accordingly
                if (transactionInfo['transactionType'] == 'credited') {
                  print("credited");
                  // transactionInfo['type'] = 'credited';
                  creditedMessages.add(body);
                  creditedAmount += transactionInfo['amount'];
                } else if (transactionInfo['transactionType'] == 'debited') {
                  // transactionInfo['type'] = 'debited';
                  debitedMessages.add(body);
                  debitedAmount += transactionInfo['amount'];
                } else {
                  transactionInfo['transactionType'] =
                      null; // Neither credit nor debit
                }

                // Add transaction info to the list
                transactionInfoList.add(transactionInfo);

                // Print transaction info
                print('Transaction Info: $transactionInfo');
              }
            }

            Future<bool> checkRegexMatch(
                List<dynamic> bankObjList, String body, String bankName) async {
              try {
                for (var bankObj in bankObjList) {
                  var regex = RegExp(bankObj['regexPattern']);
                  var match = regex.firstMatch(body);
                  if (match != null) {
                    print('Regex pattern matched');
                    return true;
                  }
                }
                return false; // Return false if no template matches
              } catch (e) {
                print('Error while checking regex match: $e');
                // User can report and the existing template
                // if(await updateTemplate(bankName, body)) {
                //   print("Template removed successfully");
                // };
                // await addNewTemplate(bankName, body);
                // we will get a report add messaages to probablySpamList
                return false;
              }
            }

            Future<void> addNewTemplate(String bankName, String message) async {
              try {
                print(bankName);
                print(message);
                var response = await Dio().post(
                  'http://192.168.124.139:8000/bank/add',
                  data: {
                    'bankName': bankName,
                    'message': message,
                  },
                );
                if (response.statusCode == 200 &&
                    response.data['success'] == true) {
                  // Template added successfully, update bankTemplates
                  // if (response.data['msg']
                  //     .tolowercase()
                  //     .contains('pattern not found')) {
                  //   promotionalMessageList.add(message);
                  //   await _savePromotionalMessageList();
                  //   return;
                  // }

                  
                  var newTemplate = response.data['data']['template'];

                  bankTemplates[bankName] = newTemplate;
                  await _saveBankTemplates();
                  var updatedBankObj = bankTemplates[bankName];
                  if (await checkRegexMatch(
                      updatedBankObj, message, bankName)) {
                    createTransactionInfo(
                        updatedBankObj, transactionInfo, message);
                    print(
                        'Regex pattern matched for bank $bankName after adding new template');
                    // Handle the matched pattern accordingly
                  } else {
                    print(
                        'Regex pattern still did not match for bank $bankName after adding new template');
                    // Handle the case where the regex pattern still doesn't match after adding new template
                  }
                  print('Template added successfully for bank $bankName');
                } else if (response.statusCode == 201 &&
                    response.data['success'] == true) {
                  print("Map returned from backend");
                  // let result = { bankName: bankName, features: features };
                  var tempMap = json.decode(response.data['data']['features']);

                  if (tempMap['amount'].toString() == "-1" ||
                      tempMap['transactionId'].toString() == "-1") {
                    promotionalMessageList.add(message);
                    await _savePromotionalMessageList();
                    print("Invalid Map, maybe promotional message");
                    return;
                  }

                  transactionInfo = {
                    'accountNumber': tempMap['accountNumber'],
                    'date': tempMap['date'],
                    'time': tempMap['time'],
                    'amount': tempMap['amount'],
                    'transactionId': tempMap['transactionId'],
                    'transactionType': tempMap['isCreditOrDebit'],
                  };

                  if (transactionInfo['amount'] is String) {
                    var cleanedAmountString =
                        transactionInfo['amount'].replaceAll(",", "");
                    transactionInfo['amount'] =
                        double.parse(cleanedAmountString);
                  }

                  // Check if body contains 'credit' or 'debit' and set type accordingly
                  if (transactionInfo['transactionType'] == 'credited') {
                    print("credited");
                    // transactionInfo['type'] = 'credited';
                    creditedMessages.add(message);
                    creditedAmount += transactionInfo['amount'];
                  } else if (transactionInfo['transactionType'] == 'debited') {
                    // transactionInfo['type'] = 'debited';
                    debitedMessages.add(message);
                    debitedAmount += transactionInfo['amount'];
                  } else {
                    transactionInfo['transactionType'] =
                        null; // Neither credit nor debit
                  }

                  // Add transaction info to the list
                  transactionInfoList.add(transactionInfo);

                  print(transactionInfo);
                } else {
                  print('Failed to add template for bank $bankName');
                }
              } catch (e) {
                print('Error adding template for bank $bankName: $e');
              }
            }

            Future<void> getData(String bankName, String body) async {
              try {
                if (bankTemplates.containsKey(bankName)) {
                  var bankObj = bankTemplates[bankName];

                  // Check if the regex pattern matches the body
                  if (await checkRegexMatch(bankObj, body, bankName)) {
                    createTransactionInfo(bankObj, transactionInfo, body);
                    print('Regex pattern matched for bank $bankName');
                    // Handle the matched pattern accordingly
                    return;
                  } else {
                    print(
                        'Regex pattern did not match for bank $bankName. Wait while creating new template.');
                    await addNewTemplate(bankName, body);
                    // Check again if regex pattern matches after adding new template
                  }
                } else {
                  await addNewTemplate(bankName, body);
                  // Check again if regex pattern matches after adding new template
                }
              } catch (e) {
                print(e);
              }
            }

            for (var messageObj in bankMessages) {
              String header = messageObj.address ?? '';
              if (header.length > 6) {
                header = header.substring(header.length - 6).toLowerCase();
              }
              if (!promotionalMessageList
                  .contains((messageObj.body ?? '').toLowerCase())) {
                String body = (messageObj.body ?? '').replaceAll('\n', ' ');
                if ((body.toLowerCase().contains('credit') ||
                    body.toLowerCase().contains('debit') ||
                    body.toLowerCase().contains('credited') ||
                    body.toLowerCase().contains('sent') ||
                    body.toLowerCase().contains('inr') ||
                    body.toLowerCase().contains('rs') ||
                    body.toLowerCase().contains('received'))) {
                  await getData(header, body);
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
