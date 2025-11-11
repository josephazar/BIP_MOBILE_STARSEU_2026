const { UsersModel } = require('../../models');
const nodemailer = require('nodemailer');

exports.register = async (req, res, next) => {
  try {
    const { name, mobile_number, email_address, password, confirmPassword } = req.body;

    // Check for empty fields
    const missingFields = [];
    if (!name) missingFields.push('Name');
    if (!mobile_number) missingFields.push('Mobile number');
    if (!email_address) missingFields.push('Email address');
    if (!password) missingFields.push('Password');
    if (!confirmPassword) missingFields.push('Confirm password');

    if (missingFields.length > 0) {
      const message = `The following fields are required: ${missingFields.join(', ')}`;
      return res.status(200).json({ success: false, message });
    }

    // Check if passwords match
    if (password !== confirmPassword) {
      return res.status(200).json({ success: false, message: "Passwords do not match" });
    }

    // Validate email address format
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email_address)) {
      return res.status(200).json({ success: false, message: "Invalid email address" });
    }

    // Check if user_code already exists
    const existingUser = await UsersModel.findOne({ where: { email_address } });
    if (existingUser) {
      return res.status(200).json({ success: false, message: "User code already exists" });
    }

    // Create user
    const user = await UsersModel.create({ name, mobile_number, email_address, password });

    // Return success response
    res.status(200).json({ success: true, message: "User registered successfully", result: user });
  } catch (error) {
    console.error(error);
    res.status(200).json({ success: false, message: "Internal server error" });
  }
};
exports.login = async (req, res, next) => {
  try {
    const { email_address, password } = req.body;

    // Find user by user_code
    const user = await UsersModel.findOne({ where: { email_address } });

    // Check if user exists and password matches
    if (!user || user.password !== password) {
      return res.status(200).json({ success: false, message: "Invalid email address or password" });
    }

    // Return success response
    res.status(200).json({ success: true, message: "Login successful", result: user });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: "Internal server error" });
  }
}
exports.loginWithMobile = async (req, res, next) => {
  try {
    const { mobile_number } = req.body;

    if (!mobile_number) {
      return res.status(200).json({ success: false, message: "Please enter your mobile number" });
    }

    // Check mobile number in the database
    const user = await UsersModel.findOne({ where: { mobile_number } });

    if (!user) {
      return res.status(200).json({ success: false, message: "Mobile number not found!" });
    }

    // Generate mobile verification code
    const smsCode = generateSMSCode();

    // Save verification code in the database
    await UsersModel.update({ otp: smsCode }, { where: { mobile_number } });

    // Send SMS () via your sms service provider
    const smsResponse = await sendSMS(mobile_number, smsCode);

    // Prepare response
    const response = {
      success: true,
      message: "Data found!",
      result: user
    };
    return res.json(response);
  } catch (error) {
    console.error("Error:", error);
    res.status(500).json({ success: false, message: "Server error", error: error.message });
  }

}
exports.checkOtp = async (req, res, next) => {
  try {
    const { mobile_number, otp } = req.body;

    if (!mobile_number) {
      return res.status(200).json({ success: false, message: "Please enter your mobile number" });
    }

    if (!otp) {
      return res.status(200).json({ success: false, message: "Please enter otp code" });
    }

    const user = await UsersModel.findOne({where: { mobile_number, otp }});

    if (!user) {
      return res.status(200).json({ success: false, message: "Please check your otp" });
    }

    // Assuming the UpdateLoginOpt updates some data related to login verification
    const updateResult = await UsersModel.update({otp: ""}, {where: { mobile_number }});

    if (updateResult) {
      return res.status(200).json({ success: true, message: "Data found!", result: user });
    } else {
      return res.status(200).json({ success: false, message: "Database Server error!" });
    }
  } catch (error) {
    console.error("Error:", error);
    return res.status(500).json({ success: false, message: "Server error", error: error.message });
  }
}
exports.sendPasswordResetCode = async (req, res, next) => {
  try {
    const { email_address } = req.body;

    if (!email_address) {
      return res.status(200).json({ success: false, message: "Please enter your email_address" });
    }

    // Check email address in the database
    const user = await UsersModel.findOne({ where: { email_address } });

    if (!user) {
      return res.status(200).json({ success: false, message: "Email address not found!" });
    }

    // Generate verification code
    const verificationCode = generateVerificationCode();

    // Update user's verificationCode field in database
    await UsersModel.update({ password_reset_code: verificationCode }, { where: { email_address } });

    // Send verification code email
    await sendVerificationCodeEmail(email_address, verificationCode);

    const response = {
      success: true,
      message: "Data found!",
      result: user
    };
    return res.json(response);
  } catch (error) {
    console.error("Error:", error);
    res.status(500).json({ success: false, message: "Server error", error: error.message });
  }

}
exports.checkVerificationCode = async (req, res, next) => {
  try {
    const { email_address, password_reset_code } = req.body;

    if (!email_address) {
      return res.status(200).json({ success: false, message: "Please enter your email address" });
    }

    if (!password_reset_code) {
      return res.status(200).json({ success: false, message: "Please enter verification code" });
    }

    const user = await UsersModel.findOne({where: { email_address, password_reset_code }});

    if (!user) {
      return res.status(200).json({ success: false, message: "Please check your verification code" });
    }

    return res.status(200).json({ success: true, message: "Data found!", result: user });

  } catch (error) {
    console.error("Error:", error);
    return res.status(500).json({ success: false, message: "Server error", error: error.message });
  }
}
exports.resetPassword = async (req, res, next) => {
  try {
    const { email_address, password_reset_code, password, confPassword } = req.body;

    // Check if newPassword and confirmPassword match
    if (password !== confPassword) {
      return res.status(200).json({ success: false, message: 'Passwords do not match' });
    }

    // Find user by email and verification code
    const user = await UsersModel.findOne({ where: { email_address, password_reset_code } });

    if (!user) {
      return res.status(200).json({ success: false, message: 'Invalid verification code' });
    }

    // Update user's password and clear verification code
    await UsersModel.update({ password: password, password_reset_code: null }, { where: { email_address } });

    res.status(200).json({ success: true, message: 'Password reset successfully', result: user});
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
}
exports.userDetails = async (req, res, next) => {
  try {
    const id = req.params.id;

    // Find user by user_code
    const user = await UsersModel.findOne({ where: { id } });

    // Check if user exists
    if (!user) {
      return res.status(200).json({ success: false, message: "Invalid user" });
    }

    // Return success response
    res.status(200).json({ success: true, message: "User Found", result: user });
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: "Internal server error" });
  }
}
exports.userUpdate = async (req, res, next) => {
  try {
    const { name, mobile_number, email_address  } = req.body;
    const id = req.params.id;

    // Check for empty fields
    const missingFields = [];
    if (!name) missingFields.push('Name');
    if (!mobile_number) missingFields.push('Mobile number');
    if (!email_address) missingFields.push('Email address');

    if (missingFields.length > 0) {
      const message = `The following fields are required: ${missingFields.join(', ')}`;
      return res.status(200).json({ success: false, message });
    }

    // Find user by user_code
    const user = await UsersModel.findOne({ where: { id } });

    // Check if user exists
    if (!user) {
      return res.status(200).json({ success: false, message: "Invalid user" });
    }

    // Update user's information
    await UsersModel.update({ name, mobile_number, email_address }, { where: { id } });

    const updateUserInfo = await UsersModel.findOne({ where: { id } });

    res.status(200).json({ success: true, message: 'User information update successfully', result: updateUserInfo});
  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
}
exports.changePassword = async (req, res, next) => {
  try {
    const { old_password, password, confPassword  } = req.body;
    const id = req.params.id;

    // Check if newPassword and confirmPassword match
    if (password !== confPassword) {
      return res.status(200).json({ success: false, message: 'Passwords do not match' });
    }

    // Find user by id and password
    const user = await UsersModel.findOne({ where: { id, password: old_password } });

    if (!user) {
      return res.status(200).json({ success: false, message: 'not match old password' });
    }

    // Update user's password
    await UsersModel.update({ password: password }, { where: { id } });

    res.status(200).json({ success: true, message: 'Password change successfully', result: user});

  } catch (error) {
    console.error(error);
    res.status(500).json({ success: false, message: 'Internal server error' });
  }
}

function generateSMSCode() {
  return Math.floor(100000 + Math.random() * 900000).toString();
}
async function sendSMS(mobileNumber, code) {
  try {
    // Write code to send an SMS using your SMS service provider.
    return {};
  } catch (error) {
    throw error;
  }
}
const generateVerificationCode = () => {
  return Math.floor(100000 + Math.random() * 900000);
};
const transporter = nodemailer.createTransport({
  // configure your email provider
  service: 'gmail',
  auth: {
    user: 'your_email@gmail.com',
    pass: 'your_email_password'
  }
});
const sendVerificationCodeEmail = async (email, verificationCode) => {
  // Here configure your email address and message
  // const mailOptions = {
  //   from: 'your_email@gmail.com',
  //   to: email,
  //   subject: 'Password Reset Verification Code',
  //   text: `Your password reset verification code is: ${verificationCode}\n\n`
  //     + `If you did not request this, please ignore this email and your password will remain unchanged.\n`
  // };
  //
  // await transporter.sendMail(mailOptions);
};
