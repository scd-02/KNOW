import dotenv from "dotenv";
dotenv.config();

import express from "express";
import connect from "./src/config/mongodbConnection.js";
import morgan from "morgan";
import bankRoutes from "./src/bank/routes/bank.js";

const app = express();
const PORT = process.env.PORT ?? 3000;

// body parser
app.use(express.json());
app.use(morgan("dev"));

app.get("/", (req, res) => {
  res.send("api is working");
});

app.use("/bank/", bankRoutes);

connect()
  .then(() => {
    try {
      app.listen(PORT, () => console.log(`Server is running on port ${PORT}`));
    } catch (error) {
      console.log(`can not connect to server ${error}`);
    }
  })
  .catch((error) => console.log(`Invalid db connection ${error}`));
