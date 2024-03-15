import { config } from "dotenv";
config();
import { apiFunction } from "./apiFunction.js";

async function regexTemplate(message) {
  const data = {
    model: process.env.model,
    messages: [
      {
        role: "system",
        content:
          "donot explain. just provide answers as a code snippet. donot quote the output. remove the following if found at start of the result : r'  or RegExp(r' or (r'. remove the following if found at  end of the result : ') or '); ",
      },
      {
        role: "user",
        content: `give me value stored in pattern variable in the below string : Map<String, String> extractTransactionDetails(String text) {
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
        content: `INR (\\d+\\.\\d+) credited to A/c no\\. XX(\\d+) on (\\d{2}-\\d{2}-\\d{2}) at (\\d{2}:\\d{2}:\\d{2}) IST\\. Info- UPI/P2A/(\\d+)/.* `,
      },
      {
        role: "user",
        content: `give me value stored in pattern variable in the below string : ${message}`,
      },
    ],
  };

  return apiFunction(data);
}

export { regexTemplate as regexPattern };
