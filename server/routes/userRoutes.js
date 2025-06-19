import express from "express";
import validateToken from "../middleware/validateToken.js";
import {
  registerUser,
  loginUser,
  currentUser,
} from "../controller/userController.js";
const userRouter = express.Router();

userRouter.post("/register", registerUser);
userRouter.post("/login", loginUser);
userRouter.post("/current", validateToken, currentUser);

export default userRouter;
