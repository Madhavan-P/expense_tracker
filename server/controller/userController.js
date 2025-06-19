import asyncHandler from "express-async-handler";
import userModel from "../model/user_model.js";
import bcrypt from "bcrypt";
import jwt from "jsonwebtoken";

export const loginUser = asyncHandler(async (req, res) => {
  const { username, password } = req.body;
  if (!username || !password) {
    res.status(400);
    throw new Error("All Fields are mandatory !");
  }
  const user = await userModel.findOne({ username });

  if (user && (await bcrypt.compare(password, user.password))) {
    const accessToken = jwt.sign(
      {
        user: {
          username: user.username,
          email: user.email,
          id: user.id,
        },
      },
      process.env.ACCESS_TOKEN_SECRET_KEY,
      { expiresIn: "24h" }
    );
    res.status(200).json({ accessToken, user });
  } else {
    res.status(200);
    throw new Error("Invalid Credentials");
  }
});

export const registerUser = asyncHandler(async (req, res) => {
  const { username, email, password } = req.body;
  if (!username || !email || !password) {
    res.status(400);
    throw new Error("All Fields are mandatory !");
  }

  const user = await userModel.findOne({ email });
  if (user) {
    res.status(400);
    throw new Error("user Already registered !");
  }
  const hashedPassword = await bcrypt.hash(password, 10);
  const newUser = await userModel.create({
    username,
    email,
    password: hashedPassword,
  });

  if (newUser) {
    console.log(newUser);
    res.status(200).json({ newUser });
  } else {
    res.status(400);
    throw new Error(" User data is not valid");
  }
});

export const currentUser = asyncHandler(async (req, res) => {
  res.json(req.user);
});
