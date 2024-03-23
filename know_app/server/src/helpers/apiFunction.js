import { config } from "dotenv";
config();
import { OpenAI } from "openai";

const openai = new OpenAI({
  apiKey: process.env.API_KEY, // Replace with your OpenAI API key
});

async function apiFunction(data) {
  let result = "";
  try {
    const response = await openai.chat.completions.create(data);
    result = response.choices[0].message.content;
    console.log(result);
    return result;
  } catch (error) {
    console.log(error);
  }
  return null;
}

export { apiFunction };
