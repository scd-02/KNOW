import { Router } from "express";
import {
  addTemplate,
  fetchAllTemplates,
  fetchListTemplate,
  fetchTemplate,
} from "../controllers/bank.js";

const bankRoutes = Router();

bankRoutes.get("/one", fetchTemplate);
bankRoutes.get("/list", fetchListTemplate);
bankRoutes.get("/all", fetchAllTemplates);
//
bankRoutes.post("/add", addTemplate);

export default bankRoutes;
