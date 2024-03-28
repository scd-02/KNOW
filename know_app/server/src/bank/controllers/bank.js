import { addToList } from "../../helpers/blacklist/controllers/bklist.js";
import bklist from "../../helpers/blacklist/model/bklist.js";
import responseSchema from "../../helpers/responseSchema.js";
import Bank from "../model/bank.js";
import { details } from "../api/details.js";
import { finalResponse } from "../api/response.js";
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

const updateTemplate = async (req, res) => {
  try {
    const { bankName, message } = req.body; // Extract the message from the request body

    // Find the bank object by bankName
    const bank = await Bank.findOne({ bankName });

    if (!bank) {
      return res.status(404).json({ message: "Bank not found" });
    }

    // Iterate over the template array to check for matching patterns
    let matchingPatternIndex = -1;
    for (let i = 0; i < bank.template.length; i++) {
      const regex = new RegExp(bank.template[i].regexPattern, "i"); // Case insensitive match
      if (regex.test(message)) {
        matchingPatternIndex = i;
        break;
      }
    }

    if (matchingPatternIndex === -1) {
      // If no matching pattern is found, return the bank object
      return res.status(200).json(bank);
    } else {
      // If a matching pattern is found, remove it from the template array
      bank.template.splice(matchingPatternIndex, 1);
      await bank.save();
      return await addTemplate(req, res);
    }
  } catch (error) {
    return res.status(400).json(responseSchema(false, error.toString()));
  }
};

const addTemplate = async (req, res) => {
  // TODO: Add the logic to handle the request
  try {
    var { bankName, message } = req.body;
    bankName = bankName.toString();

    // const isBlackListed = await bklist.findOne({
    //   feature: "bank",
    //   "list.itemName": bankName,
    // });
    // // if (isBlackListed) {
    // if (isBlackListed) {
    //   let features = await details(message);
    //   let result = { bankName: bankName, features: features };
    //   return await res
    //     .status(201)
    //     .json(responseSchema(true, "Pattern not found, details sent!", result));
    // }
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
    let transType = "";
    var pattern = null;
    var match = null;
    var err = "";
    for (let i = 0; i < 2; i++) {
      apiResponse = await finalResponse(message, err);
      const obj = JSON.parse(apiResponse);
      if (obj.transactionType == "spam") {
        let msgResponse = `{
          "amount": -1 ,
          "accountNo": -1 ,
          "date": -1 ,
          "time": -1,
          "transactionId": -1,
          "balance": -1,
          "transactionType": "spam"
        }`;
        let result = { bankName: bankName, features: msgResponse };
        return await res
          .status(201)
          .json(responseSchema(true, "Spam message!", result));
      }
      rxPattern = obj.regexPattern;
      propMap = obj.propertyMap;
      transType = obj.transactionType;
      pattern = RegExp(rxPattern);
      match = message.match(pattern);
      if (match !== null) {
        try {
          var map = JSON.parse(propMap);
          for (const key in map) {
            if (map[key] !== -1) {
              var temp = match[map[key]];
            }
          }
        } catch (error) {
          err = error.toString();
          continue;
        }
        break;
      }
    }
    if (match == null) {
      // await addToList("bank", bankName, message);
      let features = await details(message);
      let result = { bankName: bankName, features: features };
      return await res
        .status(201)
        .json(responseSchema(true, "Pattern not found, details sent!", result));
    } else {
      if (preExistingList) {
        preExistingList.template = [
          ...preExistingList.template,
          {
            regexPattern: rxPattern,
            propertyMap: propMap,
            transactionType: transType,
          },
        ];
        await preExistingList.save();
        return res
          .status(200)
          .json(responseSchema(true, "bank template updated", preExistingList));
      } else {
        var newBankTemplate = new Bank({
          bankName: bankName,
          template: [
            {
              regexPattern: rxPattern,
              propertyMap: propMap,
              transactionType: transType,
            },
          ],
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

export {
  fetchAllTemplates,
  fetchTemplate,
  addTemplate,
  fetchListTemplate,
  updateTemplate,
};
