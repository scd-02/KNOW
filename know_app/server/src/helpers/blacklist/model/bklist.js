import mongoose from "mongoose";

const BlackListSchema = new mongoose.Schema(
  {
    feature: String,
    bklist: [
      {
        itemName: String,
      },
    ],
  },
  { timestamps: true, collection: "blackList" }
);

export default mongoose.model("bklist", BlackListSchema, "blackList");
