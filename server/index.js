// import express from "express";

// const app = express();

// app.get("/", (req, res) => {
//   res.status(200).json({ message: "Hello" });
// });

// app.listen(3000, () => {
//   console.log("Server is running");
// });

import express from "express";
import dotenv from "dotenv";
// import expenseRouter from "./routes/expenseTrackerRoutes.js";
// import errorHandler from "./middleware/errorHandler.js";
// import connectDb from "./config/dbConnection.js";
// import userRouter from "./routes/userRoutes.js";

dotenv.config();
const app = express();
const PORT = process.env.PORT || 3000;
app.use(express.json());
// connectDb();

app.get("/", (req, res) => {
  console.log("Server is RUnning ");
  res.status(200).json({ message: "Server is Running" });
});

// app.use("/api/expenses", expenseRouter);
// app.use("/api/users", userRouter);
// app.use(errorHandler);

app.listen(PORT, () => {
  console.log(`Server is Running on ${PORT}`);
});
