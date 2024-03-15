import { apiFunction } from "./apiFunction.js";
import { config } from "dotenv";
config();

async function response(message) {
  const data = {
    model: process.env.model,
    messages: [
      {
        role: "system",
        content: "donot explain. just provide answers as a code snippet.",
      },
      {
        role: "user",
        content:
          " give a dart function that takes text as input then creates a template to extract account number, amount , transaction Id, available balance, date and time from the given string, and returns these values as a map . if any mentioned fields not found in input string, then remove those fields in returning map. message : INR 5590.00 credited to A/c no. XX8926 on 09-11-23 at 11:59:28 IST. Info- UPI/P2A/334365332111/ANURAG JAIN/Axis Bank - Axis Bank. ",
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
                  'account_number': accountNumber,
                  'date': date,
                  'time': time,
                  'transaction_id': transactionId
                };
              } else {
                return {};
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
