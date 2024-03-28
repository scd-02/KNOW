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
          here, user asks for a map and assitant replies a map where keys inclosed in double quotes format with following keys : transactionType, accountNo, amount, date, time, transactionId, balance.
           assign value -1 for the keys not found in the message. 
           transactionType can only be either "credited" or "debited" or "spam". any message that doesn't conclude that amount has already been credited or debited then that message is a "spam".  
           keep amount value and balance value in numeric and only upto two decimal places.
           for transaction id always take numeric part of the string. For messages with transaction type spam, assign value of each key -1 except the transactionType key. `,
      },
      {
        role: "user",
        content: ` Debit INR 500.00 A/c no. XX8926 12-10-23 20:02:19 UPI/P2A/328546155288/ANURAG JAIN SMS BLOCKUPI Cust ID to 01351860002, if not you - Axis Bank`,
      },
      {
        role: "assistant",
        content: `{
          "amount": 500.00,
          "accountNo": "XX8926",
          "date": "12-10-23",
          "time": "20:02:19",
          "transactionId": 328546155288,
          "balance": -1,
          "transactionType": "debited"
        }`,
      },
      {
        role: "user",
        content: ` ANURAG JAIN has requested money from you on Google Pay. On approving the request, INR 31.00 will be debited from your A/c - Axis Bank`,
      },
      {
        role: "assistant",
        content: `{
          "amount": -1 ,
          "accountNo": -1 ,
          "date": -1 ,
          "time": -1,
          "transactionId": -1,
          "balance": -1,
          "transactionType": "spam"
        }`,
      },
      {
        role: "user",
        content: `${message}`,
      },
    ],
  };
  return apiFunction(data);
}

export { details };
