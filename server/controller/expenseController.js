import asyncHandler from "express-async-handler";
import expenseModel from "../model/expenseModel.js";

export const getExpense = asyncHandler(async (req, res) => {
  console.log("Get Request from:", req.user);

  const expenses = await expenseModel.find({ user_id: req.user.id });

  return res.status(200).json(expenses);
});

export const createExpense = asyncHandler(async (req, res) => {
  console.log("Post Request");
  const { title, amount, date, description, category, type } = req.body;
  if (!title || !amount || !date || !description || !category || !type) {
    res.status(400);
    throw new Error("All Fields are mandatory !");
  }
  const expense = await expenseModel.create({
    user_id: req.user.id,
    title,
    amount,
    date,
    description,
    category,
    type,
  });
  return res.status(201).json(expense);
});

export const getExpenseId = asyncHandler(async (req, res) => {
  const id = req.params.id;
  const findId = await expenseModel.findById(id);
  if (!findId) {
    res.status(404);
    throw new Error("Id Not Found");
  }
  res.status(200).json(findId);
});

export const updateExpenses = asyncHandler(async (req, res) => {
  const id = req.params.id;
  const findId = await expenseModel.findById(id);
  if (!findId) {
    res.status(404);
    throw new Error("Id Not Found");
  }

  if (findId.user_id.toString() !== req.user.id) {
    res.status(403);
    throw new Error(
      "user is don't have authorized permission to update others expenses"
    );
  }
  const updatedExpense = await expenseModel.findByIdAndUpdate(id, req.body, {
    new: true,
  });
  res.status(200).json(updatedExpense);
});

export const deleteExpenses = asyncHandler(async (req, res) => {
  console.log("Delete Request");
  const id = req.params.id;
  const findId = await expenseModel.findById(id);
  if (!findId) {
    res.status(404);
    throw new Error("Id Not Found");
  }

  if (findId.user_id.toString() !== req.user.id) {
    res.status(403);
    throw new Error(
      "user is don't have authorized permission to delete others expenses"
    );
  }
  await findId.deleteOne({ _id: id });
  res.status(200).json(findId);
});
