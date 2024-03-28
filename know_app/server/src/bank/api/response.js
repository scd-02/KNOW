import { apiFunction } from "../../helpers/apiFunction.js";
import { config } from "dotenv";
config();

async function finalResponse(message, error) {
  const data = {
    model: process.env.model,
    messages: [
      {
        role: "system",
        content:
          error == ""
            ? `donot explain. 
            here user asks in reference of a message for wich assistant returns a map whos keys are trasactionType, regexPattern , propertyMap. 
            Disclamers :-
            transactionType : value can only be "credited" or "debited" or "spam". any message that doesn't conclude that amount has already been credited or debited then that message is a "spam".
            regexPattern : create a regex template to extract account number, amount , transaction Id, available balance, date and time from given message. make regex pattern parsable in json. from pattern remove the following if found at start of the result : r'  or RegExp(r' or (r'. remove the following if found at  end of the result : ') or '); .
            propertyMap : a map of property associated with its group number. this map only contains keys mentioned in disclamer for regexPattern. always quote keys of map in \\"key\\" format. If any mentioned key-value is not found in regex pattern, then set values of those keys -1 in returning map. if message is spam then set values of all keys -1.
          `
            : `donot explain. 
          here user asks in reference of a message for wich assistant returns a map whos keys are trasactionType, regexPattern , propertyMap. 
          Disclamers :-
          transactionType : value can only be "credited" or "debited" or "spam". any message that doesn't conclude that amount has already been credited or debited then that message is a "spam".
          regexPattern : create a regex template to extract account number, amount , transaction Id, available balance, date and time from given message. make regex pattern parsable in json. from pattern remove the following if found at start of the result : r'  or RegExp(r' or (r'. remove the following if found at  end of the result : ') or '); . For spam messages return regexPattern "" . consider error in last api call to make regex : ${error}
          propertyMap : a map of property associated with its group number. this map only contains keys mentioned in disclamer for regexPattern. always quote keys of map in \\"key\\" format. if any mentioned key-value is not found in regex pattern, then set values of those keys -1 in returning map.

          `,
      },
      {
        role: "user",
        content:
          " ANURAG JAIN has requested money from you on Google Pay. On approving the request, INR 31.00 will be debited from your A/c - Axis Bank ",
      },
      {
        role: "assistant",
        content: `{
          "transactionType": "spam",
         "regexPattern": "",
          "propertyMap": "{ \\"amount\\" : -1, \\"accountNumber\\" : -1, \\"date\\" : -1, \\"time\\": -1,\\"availableBalance\\": -1, \\"transactionId\\" :-1}"
        }
             `,
      },
      {
        role: "user",
        content:
          " process this message : INR 5590.00 credited to A/c no. XX8926 on 09-11-23 at 11:59:28 IST. Info- UPI/P2A/334365332111/ANURAG JAIN/Axis Bank - Axis Bank. ",
      },
      {
        role: "assistant",
        content: `{
          "transactionType": "credited",
         "regexPattern": "INR (\\\\d+\\\\.\\\\d+) credited to A/c no\\\\. XX(\\\\d+) on (\\\\d{2}-\\\\d{2}-\\\\d{2}) at (\\\\d{2}:\\\\d{2}:\\\\d{2}) IST\\\\. Info- UPI/P2A/(\\\\d+)/.*",
          "propertyMap": "{ \\"amount\\" : 1, \\"accountNumber\\" : 2, \\"date\\" : 3, \\"time\\": 4,\\"availableBalance\\": -1, \\"transactionId\\" :5}"
        }
             `,
      },

      {
        role: "user",
        content: `process this message : ${message} `,
      },
    ],
  };
  return apiFunction(data);
}

export { finalResponse };
