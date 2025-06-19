import asyncHandler from "express-async-handler";
import jwt from "jsonwebtoken";

const validateToken = asyncHandler(async (req, res, next) => {
  let token;
  let authHeader = req.headers.authorization || req.headers.Authorization;
  if (!authHeader || !authHeader.startsWith("Bearer")) {
    res.status(401);
    throw new Error("Authorization header missing or invalid");
  }

  token = authHeader.split(" ")[1];
  if (!token) {
    res.status(401);
    throw new Error("Token is missing");
  }

  jwt.verify(token, process.env.ACCESS_TOKEN_SECRET_KEY, (err, decoded) => {
    if (err) {
      res.status(401);
      throw new Error("User is not authorized");
    }
    req.user = decoded.user;
    next();
  });
});

export default validateToken;
