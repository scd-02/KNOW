// // import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'dart:convert';
// // import 'package:know/components/commonWidgets/app_bar.dart';
// // import 'package:telephony/telephony.dart';
// // import 'date_filter.dart';
// // import 'bank_names.dart';
// import 'message_section.dart';
// import 'total_amount_section.dart';
// // import 'package:shared_preferences/shared_preferences.dart';

// class MessageUtils {
//   Future<bool> updateTemplate(Map<String, dynamic> bankTemplates, String bankName, String message) async {
//     try {
//       print(bankName);
//       print(message);
//       var response = await Dio().put(
//         'http://192.168.85.139:8000/bank/update',
//         data: {
//           'bankName': bankName,
//           'message': message,
//         },
//       );
//       if (response.statusCode == 200 && response.data['success'] == true) {
//         // Template added successfully, update bankTemplates
//         var newTemplate = response.data['data']['template'];
//         bankTemplates[bankName] = newTemplate;
//         print('Unmatched Template removed successfully for bank $bankName');
//         return true;
//       } else {
//         print('Failed to remove unmatched template for bank $bankName');
//         return false;
//       }
//     } catch (e) {
//       print('Error adding template for bank $bankName: $e');
//     }
//     return false;
//   }

//   void createTransactionInfo(List<dynamic> bankObjList,
//       Map<String, dynamic> transactionInfo, String body) {
//     for (var bankObj in bankObjList) {
//       var regex = RegExp(bankObj['regexPattern']);
//       var match = regex.firstMatch(body);
//       var propertyMapString = bankObj['propertyMap'];
//       var propertyMap = json.decode(propertyMapString);
//       transactionInfo = {
//         'accountNumber': int.parse(propertyMap['accountNumber'].toString()) ==
//                 -1
//             ? ""
//             : match!.group(int.parse(propertyMap['accountNumber'].toString())),
//         'date': int.parse(propertyMap['date'].toString()) == -1
//             ? ""
//             : match!.group(int.parse(propertyMap['date'].toString())),
//         'time': int.parse(propertyMap['time'].toString()) == -1
//             ? ""
//             : match!.group(int.parse(propertyMap['time'].toString())),
//         'transactionId': int.parse(propertyMap['transactionId'].toString()) ==
//                 -1
//             ? ""
//             : match!.group(int.parse(propertyMap['transactionId'].toString())),
//         'transactionType': bankObj['transactionType'],
//       };

//       // Extract amount if it exists in propertyMap
//       if (propertyMap.containsKey('amount')) {
//         var amountIndex = propertyMap['amount'];
//         var amountString = match?.group(amountIndex);
//         if (amountString != null) {
//           // Remove commas from the amount string
//           var cleanedAmountString = amountString.replaceAll(",", "");
//           // Convert the cleaned amount string to a double
//           transactionInfo['amount'] = double.parse(cleanedAmountString);
//         } else {
//           // Handle the case when amount is not captured
//           transactionInfo['amount'] = null; // Or any other default value
//         }
//       } else {
//         transactionInfo['amount'] = 0;
//       }

//       // Check if body contains 'credit' or 'debit' and set type accordingly
//       if (transactionInfo['transactionType'] == 'credited') {
//         print("credited");
//         transactionInfo['type'] = 'credited';
//         creditedMessages.add(body);
//         creditedAmount += transactionInfo['amount'];
//       } else if (transactionInfo['transactionType'] == 'debited') {
//         transactionInfo['type'] = 'debited';
//         debitedMessages.add(body);
//         debitedAmount += transactionInfo['amount'];
//       } else {
//         transactionInfo['transactionType'] = null; // Neither credit nor debit
//       }

//       // Print transaction info
//       print('Transaction Info: $transactionInfo');
//     }
//   }

//   Future<bool> checkRegexMatch(
//       List<dynamic> bankObjList, String body, String bankName) async {
//     try {
//       for (var bankObj in bankObjList) {
//         var regex = RegExp(bankObj['regexPattern']);
//         var match = regex.firstMatch(body);
//         if (match != null) {
//           print('Regex pattern matched');
//           return true;
//         }
//       }
//       return false; // Return false if no template matches
//     } catch (e) {
//       print('Error while checking regex match: $e');
//       // User can report and the existing template
//       // if(await updateTemplate(bankName, body)) {
//       //   print("Template removed successfully");
//       // };
//       // await addNewTemplate(bankName, body);
//       // we will get a report add messaages to probablySpamList
//       return false;
//     }
//   }

//   Future<void> addNewTemplate(Map<String, dynamic> bankTemplates, Map<String, dynamic> transactionInfo, Set<String> promotionalMessageList, String bankName, String message) async {
//     try {
//       print(bankName);
//       print(message);
//       var response = await Dio().post(
//         'http://192.168.85.139:8000/bank/add',
//         data: {
//           'bankName': bankName,
//           'message': message,
//         },
//       );
//       if (response.statusCode == 200 && response.data['success'] == true) {
//         // Template added successfully, update bankTemplates
//         // if (response.data['msg']
//         //     .tolowercase()
//         //     .contains('pattern not found')) {
//         //   promotionalMessageList.add(message);
//         //   await _savePromotionalMessageList();
//         //   return;
//         // }
//         var newTemplate = response.data['data']['template'];

//         bankTemplates[bankName] = newTemplate;
//         await _saveBankTemplates();
//         var updatedBankObj = bankTemplates[bankName];
//         if (await checkRegexMatch(updatedBankObj, message, bankName)) {
//           createTransactionInfo(updatedBankObj, transactionInfo, message);
//           print(
//               'Regex pattern matched for bank $bankName after adding new template');
//           // Handle the matched pattern accordingly
//         } else {
//           print(
//               'Regex pattern still did not match for bank $bankName after adding new template');
//           // Handle the case where the regex pattern still doesn't match after adding new template
//         }
//         print('Template added successfully for bank $bankName');
//       } else if (response.statusCode == 201 &&
//           response.data['success'] == true) {
//         print("Map returned from backend");
//         // let result = { bankName: bankName, features: features };
//         var tempMap = json.decode(response.data['data']['features']);

//         if (tempMap['amount'].toString() == "-1") {
//           promotionalMessageList.add(message);
//           await _savePromotionalMessageList();
//           print("Invalid Map, maybe promotional message");
//           return;
//         }

//         transactionInfo = {
//           'accountNumber': tempMap['accountNumber'],
//           'date': tempMap['date'],
//           'time': tempMap['time'],
//           'amount': tempMap['amount'],
//           'transactionId': tempMap['transactionId'],
//           'transactionType': tempMap['isCreditOrDebit'],
//         };

//         if (transactionInfo['amount'] is String) {
//           var cleanedAmountString =
//               transactionInfo['amount'].replaceAll(",", "");
//           transactionInfo['amount'] = double.parse(cleanedAmountString);
//         }

//         // Check if body contains 'credit' or 'debit' and set type accordingly
//         if (transactionInfo['transactionType'] == 'credited') {
//           print("credited");
//           // transactionInfo['type'] = 'credited';
//           creditedMessages.add(message);
//           creditedAmount += transactionInfo['amount'];
//         } else if (transactionInfo['transactionType'] == 'debited') {
//           // transactionInfo['type'] = 'debited';
//           debitedMessages.add(message);
//           debitedAmount += transactionInfo['amount'];
//         } else {
//           transactionInfo['transactionType'] = null; // Neither credit nor debit
//         }

//         print(transactionInfo);
//       } else {
//         print('Failed to add template for bank $bankName');
//       }
//     } catch (e) {
//       print('Error adding template for bank $bankName: $e');
//     }
//   }

//   Future<void> getData(Map<String, dynamic> bankTemplates, Map<String, dynamic> transactionInfo, Set<String> promotionalMessageList, String bankName, String body) async {
//     try {
//       if (bankTemplates.containsKey(bankName)) {
//         var bankObj = bankTemplates[bankName];

//         // Check if the regex pattern matches the body
//         if (await checkRegexMatch(bankObj, body, bankName)) {
//           createTransactionInfo(bankObj, transactionInfo, body);
//           print('Regex pattern matched for bank $bankName');
//           // Handle the matched pattern accordingly
//           return;
//         } else {
//           print(
//               'Regex pattern did not match for bank $bankName. Wait while creating new template.');
//           await addNewTemplate(bankTemplates, transactionInfo, promotionalMessageList, bankName, body);
//           // Check again if regex pattern matches after adding new template
//         }
//       } else {
//         await addNewTemplate(bankTemplates, transactionInfo, promotionalMessageList, bankName, body);
//         // Check again if regex pattern matches after adding new template
//       }
//     } catch (e) {
//       print(e);
//     }
//   }
// }
