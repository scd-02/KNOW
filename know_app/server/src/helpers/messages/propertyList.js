import { config } from "dotenv";
config();
import { OpenAI } from "openai";

const openai = new OpenAI({
  apiKey: process.env.API_KEY, // Replace with your OpenAI API key
});

async function propertyList(message) {
  const data = {
    model: "gpt-3.5-turbo-0125",
    messages: [
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
        content: `INR (\\d+\\.\\d+) credited to A/c no\\. XX(\\d+) on (\\d{2}-\\d{2}-\\d{2}) at (\\d{2}:\\d{2}:\\d{2}) IST\\. Info- UPI/P2A/(\\d+)/.*`,
      },
      {
        role: "user",
        content: `give me value stored in pattern variable in the below string : ${message}`,
      },
    ],
  };
  let result = "";
  try {
    const response = await openai.chat.completions.create(data);
    result = response.choices[0].message.content;
    return result;
  } catch (error) {
    console.log(error);
  }
  return null;
}

export { propertyList as propertyMap };
