import { Router } from "express";
import {
  addTemplate,
  fetchAllTemplates,
  fetchTemplate,
} from "../controllers/bank.js";

const bankRoutes = Router();

bankRoutes.get("/", fetchTemplate);
bankRoutes.get("/all", fetchAllTemplates);
bankRoutes.post("/", addTemplate);

export default bankRoutes;
