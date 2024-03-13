import { response } from "../../helpers/messages/apiResponse.js";
import { propertyMap } from "../../helpers/messages/propertyList.js";
import { regexPattern } from "../../helpers/messages/regexTemplate.js";
import responseSchema from "../../helpers/responseSchema.js";
import Bank from "../model/bank.js";
const fetchTemplate = async (req, res) => {
  // TODO: Add the logic to handle the request
  try {
    const { bankName } = req.body;
    const allBkTemplates = await Bank.findOneAndDelete({ bankName: bankName });
    return res
      .status(200)
      .json(responseSchema(true, "user found", allBkTemplates));
  } catch (error) {
    return res.status(400).json(responseSchema(false, error.toString()));
  }
};

const fetchAllTemplates = async (req, res) => {
  // TODO: Add the logic to handle the request
  try {
    const result = await Bank.find();
    return res
      .status(200)
      .json(responseSchema(true, "all templates fetched", result));
  } catch (error) {
    return res.status(400).json(responseSchema(false, error.toString()));
  }
};

const addTemplate = async (req, res) => {
  // TODO: Add the logic to handle the request
  try {
    const { bankName, message } = req.body;
    const apiResponse = "";
    const rxPattern = "";
    const propMap = "";
    for (let i = 0; i < 10; i++) {
      apiResponse = response(message);
      rxPattern = regexPattern(apiResponse);
      propMap = propertyMap(apiResponse);

      const pattern = RegExp(rxPattern);
      const match = pattern.exec(message);

      if (match !== null) {
        break;
      }
    }
    const newBankTemplate = new Bank({
      bankName: bankName,
      propertyMap: propMap,
      regexPattern: rxPattern,
    });
    const alreadyExists = await Bank.findOne({
      $and: [{ regexPattern: rxPattern, bankName: bankName }],
    });
    if (alreadyExists) {
      return res.status(400).json(responseSchema(false, "Already Exists!"));
    }
    await newBankTemplate.save();
    return res
      .status(200)
      .json(responseSchema(true, "bank template added", result));
  } catch (error) {
    return res.status(400).json(responseSchema(false, error.toString()));
  }
};

export { fetchAllTemplates, fetchTemplate, addTemplate, deleteTemplate };
