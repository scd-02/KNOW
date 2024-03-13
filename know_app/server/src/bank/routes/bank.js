import { Router } from "express";
import {
  addTemplate,
  deleteTemplate,
  fetchAllTemplates,
  fetchTemplate,
} from "../controllers/bank";

const bankRoutes = Router();

bankRoutes.get("/", fetchTemplate);
bankRoutes.get("/all", fetchAllTemplates);
bankRoutes.post("/", addTemplate);

export default captainRoutes;
