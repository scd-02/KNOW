import mongoose from "mongoose";

const BankSchema = new mongoose.Schema(
  {
    bankName: String,
    transactionType: String,
    template: [
      {
        regexPattern: String,
        propertyMap: String,
      },
    ],
  },
  { timestamps: true, collection: "bank" }
);

export default mongoose.model("Bank", BankSchema, "bank");
