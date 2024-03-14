const { Login, ChatBot } = require("hugchat");
const fs = require("fs");

async function getBnkFeatures(text) {
  let apiResult = {};
  const sign = new Login("", "");
  const cookies = await sign.login();

  // Save cookies to a directory
  const cookiePathDir = "./cookies_snapshot";
  sign.saveCookiesToDir(cookiePathDir);

  // Create a ChatBot
  const chatbot = new ChatBot({ cookies: cookies.get_dict() });

  while (true) {
    try {
      await chatbot.query(
        "from now onwards just give precise answer, donot provide any explanations and decorations for the answers "
      );
      const queryResult = await chatbot.query(
        `${text} : give me output in a python dictionary where keys inclosed in double quotes format with following keys : isCreditedOrDebited, accountNo, paymentMethod, amount, date, time, transactionId, balance. assign value '' for the keys not found in the message. isCreditedOrDebited can be either credited or debited or notfound.  keep amount value and balance value in numeric and only upto two decimal places . and fit it in one token ?`
      );

      // Parse JSON result
      const result = queryResult.substring(
        queryResult.indexOf("{"),
        queryResult.lastIndexOf("}") + 1
      );
      console.log(result);
      apiResult = JSON.parse(result);
      break; // Break the loop if successful
    } catch (error) {
      console.error("Error: Unexpected error occurred", error);
      // Retry the operation
      continue;
    }
  }
  return apiResult;
}
