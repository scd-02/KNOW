import { config } from "dotenv";
config();
import { OpenAI } from "openai";

const openai = new OpenAI({
  apiKey: process.env.API_KEY, // Replace with your OpenAI API key
});

async function response(message) {
  const data = {
    model: "gpt-3.5-turbo",
    messages: [
      {
        role: "user",
        content:
          "desclaimer: donot explain, donot provide any main function, do not show implementation. Reference Question : just give a dart function that takes text as input then creates a template to extract account number, amount , transaction Id, available balance, date and time from the given string, and returns these values as a map . if any mentioned fields not found in input string, then remove those fields in returning map: INR 5590.00 credited to A/c no. XX8926 on 09-11-23 at 11:59:28 IST. Info- UPI/P2A/334365332111/ANURAG JAIN/Axis Bank - Axis Bank. ",
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

export { response };
