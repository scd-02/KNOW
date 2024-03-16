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

    const preExistingList = await Bank.findOne({ bankName: bankName });
    if (preExistingList) {
      for (const document of preExistingList.template) {
        if (document.regexPattern) {
          const patrn = RegExp(document.regexPattern);
          const matched = patrn.exec(message);
          if (matched !== null) {
            return res
              .status(200)
              .json(responseSchema(true, "Already Exists!", preExistingList));
          }
        }
      }
    }
    let apiResponse = "";
    let rxPattern = "";
    let propMap = "";
    var pattern = null;
    var match = null;
    for (let i = 0; i < 4; i++) {
      apiResponse = await response(message);
      rxPattern = await regexPattern(apiResponse);
      propMap = await propertyMap(apiResponse);

      pattern = RegExp(rxPattern);
      match = pattern.exec(message);

      if (match !== null) {
        break;
      }
    }
    if (match == null) {
      return await res
        .status(400)
        .json(responseSchema(false, "Pattern not found", null));
    } else {
      if (preExistingList) {
        preExistingList.template = [
          ...preExistingList.template,
          { regexPattern: rxPattern, propertyMap: propMap },
        ];
        await preExistingList.save();
        return res
          .status(200)
          .json(responseSchema(true, "bank template updated", preExistingList));
      } else {
        var newBankTemplate = new Bank({
          bankName: bankName,
          template: [{ regexPattern: rxPattern, propertyMap: propMap }],
        });
        await newBankTemplate.save();
        return res
          .status(200)
          .json(responseSchema(true, "bank template added", newBankTemplate));
      }
    }
  } catch (error) {
    return res.status(400).json(responseSchema(false, error.toString()));
  }
};

export { fetchAllTemplates, fetchTemplate, addTemplate, fetchListTemplate };
