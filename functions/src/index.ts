import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as nodemailer from "nodemailer";

admin.initializeApp();


// إعدادات النقل للبريد الإلكتروني باستخدام nodemailer
const transporter = nodemailer.createTransport({
  service: "gmail",
  auth: {
    user: "your-email@gmail.com",
    pass: "your-email-password",
  },
});

export const sendEmail = functions.https.onRequest(async (req, res) => {
  const mailOptions = {
    from: "your-email@gmail.com",
    to: "recipient-email@gmail.com",
    subject: "Test Email",
    text: "This is a test email sent from Firebase functions.",
  };

  try {
    await new Promise((resolve, reject) => {
      transporter.sendMail(mailOptions, (error, info) => {
        if (error) {
          reject(error);
        } else {
          resolve(info);
        }
      });
    });

    res.status(200).send("Email sent successfully:");
  } catch (error) {
    res.status(500).send("Failed to send email:");
  }
});
