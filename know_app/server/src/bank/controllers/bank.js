import { response } from "../../helpers/messages/apiResponse.js";
import { propertyMap } from "../../helpers/messages/propertyList.js";
import { regexPattern } from "../../helpers/messages/regexTemplate.js";
import responseSchema from "../../helpers/responseSchema.js";
import Bank from "../model/bank.js";
const fetchTemplate = async (req, res) => {
  // TODO: Add the logic to handle the request
  try {
    const { bankName } = req.body;
    const allBkTemplates = await Bank.find({ bankName: bankName });
    return res
      .status(200)
      .json(responseSchema(true, "templates fetched", allBkTemplates));
  } catch (error) {
    return res.status(400).json(responseSchema(false, error.toString()));
  }
};
const fetchListTemplate = async (req, res) => {
  // TODO: Add the logic to handle the request
  try {
    const { bankNames } = req.body;
    const allBkTemplates = await Bank.find({ bankName: { $in: bankNames } });
    return res
      .status(200)
      .json(responseSchema(true, "templates fetched", allBkTemplates));
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
    let apiResponse = "";
    let rxPattern = "";
    let propMap = "";
    for (let i = 0; i < 4; i++) {
      apiResponse = await response(message);
      console.log("api response done");
      rxPattern = await regexPattern(apiResponse);
      console.log("rx pattern done");
      propMap = await propertyMap(apiResponse);
      console.log("promap done");

      console.log(rxPattern);
      const pattern = RegExp(rxPattern);
      console.log(pattern);
      const match = pattern.exec(message);
      console.log(match);

      if (match !== null) {
        break;
      }
    }
    const pattern = RegExp(rxPattern);
    const match = pattern.exec(message);

    if (match == null) {
      return res
        .status(400)
        .json(responseSchema(false, "Pattern not found", null));
    }

    const preExistingList = Bank.find({ bankName: bankName });

    await preExistingList.forEach((document) => {
      if (document.regexPattern) {
        const patrn = RegExp(document.regexPattern);
        const matched = patrn.exec(message);
        if (matched !== null) {
          return res.status(400).json(responseSchema(false, "Already Exists!"));
        }
      }
    });

    const newBankTemplate = new Bank({
      bankName: bankName,
      propertyMap: propMap,
      regexPattern: rxPattern,
    });

    await newBankTemplate.save();
    return res
      .status(200)
      .json(responseSchema(true, "bank template added", newBankTemplate));
  } catch (error) {
    return res.status(400).json(responseSchema(false, error.toString()));
  }
};

export { fetchAllTemplates, fetchTemplate, addTemplate, fetchListTemplate };
