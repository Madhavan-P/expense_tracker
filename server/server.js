import express from "express";
import dotenv from "dotenv";
import expenseRouter from "./routes/expenseTrackerRoutes.js";
import userRouter from "./routes/userRoutes.js";
import errorHandler from "./middleware/errorHandler.js";
import connectDb from "./config/dbConnection.js";
import cors from "cors";

const app = express();
dotenv.config();
const CurrentPORT = process.env.PORT || 3000;
app.use(cors());
app.use(express.json());
connectDb();

console.log(CurrentPORT);

app.get("/", (req, res) => {
  res.status(200).json({ message: `Hello ${Date.now()}` });
});

app.use("/api/expenses", expenseRouter);
app.use("/api/users", userRouter);
app.use(errorHandler);

app.listen(3000, "0.0.0.0", () => {
  console.log("Server is running on 0.0.0.0:3000");
});
