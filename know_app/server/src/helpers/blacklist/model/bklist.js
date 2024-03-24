import mongoose from "mongoose";

const BlackListSchema = new mongoose.Schema(
  {
    feature: String,
    list: [
      {
        itemName: String,
        itemContent: String,
      },
    ],
  },
  { timestamps: true, collection: "blackList" }
);

export default mongoose.model("bklist", BlackListSchema, "blackList");
