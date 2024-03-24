import { apiFunction } from "../../helpers/apiFunction.js";
import { config } from "dotenv";
config();

async function response(message) {
  const data = {
    model: process.env.model,
    messages: [
      {
        role: "system",
        content:
          // "donot explain. just provide answers as a code snippet. donot ignore transaction ids of the format : {any-text}/{any-text}/{transaction-id}/{any-text} , ref- {transaction-id}. apart from given format of transaction id, there can be other formats too, so read messages carefully. Here transaction type refers credit or debit or else.",
          "donot explain. just provide answers as a code snippet. Transaction ids are always numeric part of string. donot ignore transaction ids of the format : {any-text}/{any-text}/{transaction-id}/{any-text} , ref- {transaction-id}. apart from given format of transaction id, there can be other formats too, so read messages carefully.",
      },
      {
        role: "user",
        content:
          " give a dart function that takes text as input then creates a template to extract account number, amount , transaction Id, available balance, date and time from the given string, and returns these values as a map having keys accountNumber, amount , transactionId, availableBalance, date and time  . if any mentioned fields not found in input string, then set values of those fields -1 in returning map. message : INR 5590.00 credited to A/c no. XX8926 on 09-11-23 at 11:59:28 IST. Info- UPI/P2A/334365332111/ANURAG JAIN/Axis Bank - Axis Bank. ",
        // " give a dart function that takes text as input then creates a template to extract transaction type, account number, amount , transaction Id, available balance, date and time from the given string, and returns these values as a map having keys accountNumber, amount , transactionId, availableBalance, date and time  . if any mentioned fields not found in input string, then set values of those fields -1 in returning map. message : INR 5590.00 credited to A/c no. XX8926 on 09-11-23 at 11:59:28 IST. Info- UPI/P2A/334365332111/ANURAG JAIN/Axis Bank - Axis Bank. ",
      },
      {
        role: "assistant",
        content: `Map<String, String> extractTransactionDetails(String text) {
              RegExp pattern = RegExp(r'INR (\\d+\\.\\d+) credited to A/c no\\. XX(\\d+) on (\\d{2}-\\d{2}-\\d{2}) at (\\d{2}:\\d{2}:\\d{2}) IST\\. Info- UPI/P2A/(\\d+)/.*');
              Match? match = pattern.firstMatch(text);
              if (match != null) {
                String amount = match.group(1)!;
                String accountNumber = match.group(2)!;
                String date = match.group(3)!;
                String time = match.group(4)!;
                String transactionId = match.group(5)!;
                return {
                  'amount': amount,
                  'accountNumber': accountNumber,
                  'date': date,
                  'time': time,
                  'availableBalance': '-1',
                  'transactionId': transactionId
                };
              } else {
                return {
                  'accountNumber': '-1',
                  'amount': '-1',
                  'date': '-1',
                  'transactionId': '-1',
                  'availableBalance': '-1',
                  'time': '-1'
                };
              }
            }`,
      },

      {
        role: "user",
        content: `same question as above but for the message : ${message} `,
      },
    ],
  };
  return apiFunction(data);
}

export { response };
