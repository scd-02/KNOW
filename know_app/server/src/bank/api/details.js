import { apiFunction } from "../../helpers/apiFunction.js";
import { config } from "dotenv";
config();

async function details(message) {
  const data = {
    model: process.env.model,
    messages: [
      {
        role: "system",
        content: ` donot explain . 
          here, user asks for a map and assitant replies a map where keys inclosed in double quotes format with following keys : isCreditedOrDebited, accountNo, amount, date, time, transactionId, balance.
           assign value '-1' for the keys not found in the message. 
           isCreditedOrDebited can be either credited or debited .  
           keep amount value and balance value in numeric and only upto two decimal places.
           for transaction id always take numeric part of the string.  `,
      },
      {
        role: "user",
        content: ` Debit INR 500.00 A/c no. XX8926 12-10-23 20:02:19 UPI/P2A/328546155288/ANURAG JAIN SMS BLOCKUPI Cust ID to 01351860002, if not you - Axis Bank- give me output in a map ?`,
      },
      {
        role: "assistant",
        content: `{
          "amount": 500.00,
          "accountNo": "XX8926",
          "date": "12-10-23",
          "time": "20:02:19",
          "transactionId": 328546155288,
          "balance": "-1",
          "isCreditOrDebit": "debited"
        }`,
      },
      {
        role: "user",
        content: `${message} - give me output in a map?  `,
      },
    ],
  };
  return apiFunction(data);
}

export { details };
