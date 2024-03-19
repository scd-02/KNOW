import { config } from "dotenv";
import { apiFunction } from "./apiFunction.js";
config();

async function propertyList(message) {
  const data = {
    model: process.env.model,
    messages: [
      {
        role: "system",
        content: "donot explain. just provide answers as a code snippet.  ",
      },
      {
        role: "user",
        content: `list me property and group number assigned in a map from the below string : Map<String, String> extractTransactionDetails(String text) {
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
        role: "assistant",
        content: `{ "amount" : 1, "accountNumber" : 2, "date" : 3, "time": 4, "transactionId" :5}`,
      },
      {
        role: "user",
        content: `list me property and group number assigned in a map from the below string : ${message} `,
      },
    ],
  };
  return apiFunction(data);
}

export { propertyList as propertyMap };
