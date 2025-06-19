import mongoose from "mongoose";

const expenseSchema = mongoose.Schema({
  user_id: {
    type: mongoose.Schema.Types.ObjectId,
    required: true,
    ref: "User",
  },
  title: {
    type: String,
    required: [true, "Please Enter the title of the Expenses"],
  },
  amount: {
    type: Number,
    required: [true, "Please Enter the amount"],
  },
  date: {
    type: Date,
    required: [true, "Please Enter the Date"],
  },
  description: {
    type: String,
    required: [true, "Please Enter the description"],
  },
  category: {
    type: String,
    required: [true, "Please Enter the category of the Expenses"],
  },
  type: {
    type: String,
    required: [true, "Please Enter the type of the Expenses(Income / Expense)"],
  },
});

const expenseModel = mongoose.model("Expenses", expenseSchema);
export default expenseModel;
