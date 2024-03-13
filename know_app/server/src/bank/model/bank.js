import mongoose from "mongoose";

const BankSchema = new mongoose.Schema(
  {
    bankName: String,
    propertyMap: String,
    regexPattern: String,
  },
  { timestamps: true, collection: "bank" }
);

export default mongoose.model("Bank", BankSchema, "bank");
