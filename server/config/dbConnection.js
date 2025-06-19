import mongoose from "mongoose";
import dotenv from "dotenv";

dotenv.config();

const connectDb = async () => {
  try {
    const connect = await mongoose.connect(process.env.DB_URL);
  } catch (err) {
    console.log(err);
    process.exit(1);
  }
};
export default connectDb;
