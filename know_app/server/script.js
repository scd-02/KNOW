import { config } from "dotenv";
config();
import { OpenAI } from "openai";

const openai = new OpenAI({
  apiKey: process.env.API_KEY, // Replace with your OpenAI API key
});

const message =
  "A/c *9172 Credited for Rs:20.00 on 03-02-2024 16:41:53 by Mob Bk ref no 403416406046 Avl Bal Rs:468.00.Never Share OTP/PIN/CVV-Union Bank of India";

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

let response1 = "";
try {
  const response = await openai.chat.completions.create(data);
  response1 = response.choices[0].message.content;
  console.log(response1);
  // Now you can use the response variable for further processing
} catch (error) {
  console.error(error);
}

const data2 = {
  model: "gpt-3.5-turbo-0125",
  messages: [
    {
      role: "user",
      content:
        "desclaimer: donot explain, donot provide any main function, do not show implementation. Reference Question : just give a dart function that takes text as input then creates a template to extract account number, amount , transaction Id, available balance, date and time from the given string, and returns these values as a map . if any mentioned fields not found in input string, then remove those fields in returning map: INR 5590.00 credited to A/c no. XX8926 on 09-11-23 at 11:59:28 IST. Info- UPI/P2A/334365332111/ANURAG JAIN/Axis Bank - Axis Bank. ",
    },
    {
      role: "assistant",
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
      content: `give me value stored in pattern variable in the below string : ${response1}`,
    },
  ],
};

let regexTemplate = "";
try {
  const response = await openai.chat.completions.create(data2);
  regexTemplate = response.choices[0].message.content;
  console.log(regexTemplate);
  // Now you can use the response variable for further processing
} catch (error) {
  console.error(error);
}

const data3 = {
  model: "gpt-3.5-turbo-0125",
  messages: [
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
      content: `list me property and group number assigned in a map from the below string : ${response1} `,
    },
  ],
};

let propertyMap = "";
try {
  const response = await openai.chat.completions.create(data3);
  propertyMap = response.choices[0].message.content;
  console.log(propertyMap);
  // Now you can use the response variable for further processing
} catch (error) {
  console.error(error);
}

const pattern = RegExp(regexTemplate);
const match = pattern.exec(message);
if (match !== null) {
  const keyVal = JSON.parse(propertyMap);
  let result = {};
  for (const key in keyVal) {
    result = { ...result, [key]: match[keyVal[key]] };
  }
  console.log(result);
}
console.log(match);
