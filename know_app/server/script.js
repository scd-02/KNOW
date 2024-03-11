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
        "desclaimer: donot explain, just give a dart function that takes text as input then creates a template to extract account number, amount , transaction Id, available balance, date and time from the given string, and returns these values as a map . if any mentioned fields not found in input string, then remove those fields in returning map: A/c *9172 Credited for Rs:20.00 on 03-02-2024 16:41:53 by Mob Bk ref no 403416406046 Avl Bal Rs:468.00.Never Share OTP/PIN/CVV-Union Bank of India",
    },
  ],
};

try {
  const response = await openai.chat.completions.create(data);
  console.log(response.choices[0].message.content);
  // Now you can use the response variable for further processing
} catch (error) {
  console.error(error);
}

console.log(process.env.API_KEY);
