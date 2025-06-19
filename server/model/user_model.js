import mongoose from "mongoose";

const userSchema = mongoose.Schema(
  {
    username: {
      type: String,
      required: [true, "Please Enter the username"],
      unique: [true, "username is already exist"],
    },
    email: {
      type: String,
      required: [true, "Please Enter the email"],
      unique: [true, "email is already taken"],
    },
    password: {
      type: String,
      required: [true, "Please Enter password"],
    },
  },
  {
    timestamps: true,
  }
);

const userModel = mongoose.model("User", userSchema);
export default userModel;
