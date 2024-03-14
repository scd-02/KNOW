const filterText = require("./filterText");
const matchTemplate = require("./matchTemplate");
const getBnkFeatureAPI = require("./getBnkFeatureAPI");
const featureTemplate = require("./featureTemplate");
const getFeatureList = require("./getFeatureList");

const text =
  "Debit INR 500.00 A/c no. XX8926 12-10-23 20:02:19 UPI/P2A/328546155288/ANURAG JAIN SMS BLOCKUPI Cust ID to 01351860002, if not you - Axis Bank";
// const text = "Debit INR 500.00 A/c no. XX8926 12-10-23 20:02:19 P2A/328546155288/ANURAG JAIN SMS BLOCKUPI Cust ID to 01351860002, if not you - Axis Bank UPI/";
const sender = "CP-SBIUPI";

const senderStringList = filterText.templateTxt(sender);
const senderLargestString = filterText.getLargestString(senderStringList);

const paymentTypes = [
  "upi",
  "npci",
  "card",
  "imps",
  "aeps",
  "bbps",
  "netc",
  "e-rupi",
  "ussd",
  "neft",
  "rtgs",
];
let paymentType = "";
for (const type of paymentTypes) {
  if (text.toLowerCase().includes(type)) {
    paymentType = type;
    break;
  }
}

const token = filterText.tokenizeTxt(text);
console.log(token);

const template = filterText.templateTxt(text);
console.log(template);

const matchNumber = matchTemplate.matchTemplate(template, token);
let featureTemp = [];
let featureList = [];

if (featureTemp.length !== 0 && matchNumber / template.length >= 0.7) {
  featureList = getFeatureList.featureList(featureTemp, token);
} else {
  const apiResult = getBnkFeatureAPI.getBnkFeatures(text);
  featureTemp = featureTemplate.makeFeatureTemplate(token, apiResult);
  console.log(featureTemp);
  featureList = getFeatureList.featureList(featureTemp, token);
  console.log(featureList);
}
