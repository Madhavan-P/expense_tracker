import express from "express";
import {
  getExpense,
  createExpense,
  getExpenseId,
  updateExpenses,
  deleteExpenses,
} from "../controller/expenseController.js";
import validateToken from "../middleware/validateToken.js";

const expenseRouter = express.Router();

expenseRouter.use(validateToken);

expenseRouter.get("/", getExpense);
expenseRouter.post("/", createExpense);
expenseRouter.get("/:id", getExpenseId);
expenseRouter.put("/:id", updateExpenses);
expenseRouter.delete("/:id", deleteExpenses);

export default expenseRouter;
