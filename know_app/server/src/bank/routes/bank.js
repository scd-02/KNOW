import { Router } from "express";
import {
  addTemplate,
  fetchAllTemplates,
  fetchListTemplate,
  fetchTemplate,
  updateTemplate,
} from "../controllers/bank.js";

const bankRoutes = Router();

bankRoutes.get("/one", fetchTemplate);
bankRoutes.get("/list", fetchListTemplate);
bankRoutes.get("/all", fetchAllTemplates);
bankRoutes.put("/update", updateTemplate);
bankRoutes.post("/", addTemplate);

export default bankRoutes;
