import mongoose from "mongoose";

async function connect() {
  const uri = `mongodb+srv://${process.env.user}:${process.env.pass}@cluster0.qauufi8.mongodb.net/`;

  mongoose.set("strictQuery", true);
  const db = await mongoose.connect(uri, {});
  console.log("Database connected");
  return db;
}

export default connect;
