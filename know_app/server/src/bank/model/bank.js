import mongoose from "mongoose";

const BankSchema = new mongoose.Schema(
  {
    bankName: String,

    template: [
      {
        transactionType: String,
        regexPattern: String,
        propertyMap: String,
      },
    ],
  },
  { timestamps: true, collection: "bank" }
);

export default mongoose.model("Bank", BankSchema, "bank");
