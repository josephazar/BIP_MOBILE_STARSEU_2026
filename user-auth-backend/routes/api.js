const express = require('express');
const router = express.Router();

const User  = require('../controllers/api/Users');

router.post('/register', async function (req, res, next) {
  await User.register(req, res, next);
});
router.post('/login', async function (req, res, next) {
  await User.login(req, res, next);
});
router.post('/check_otp', async function (req, res, next) {
  await User.checkOtp(req, res, next);
});
router.post('/login_with_mobile', async function (req, res, next) {
  await User.loginWithMobile(req, res, next);
});
router.post('/send_password_reset_code', async function (req, res, next) {
  await User.sendPasswordResetCode(req, res, next);
});
router.post('/check_verification_code', async function (req, res, next) {
  await User.checkVerificationCode(req, res, next);
});
router.post('/reset_password', async function (req, res, next) {
  await User.resetPassword(req, res, next);
});
router.get('/user_details/:id', async function (req, res, next) {
  await User.userDetails(req, res, next);
});
router.put('/user_update/:id', async function (req, res, next) {
  await User.userUpdate(req, res, next);
});
router.put('/change_password/:id', async function (req, res, next) {
  await User.changePassword(req, res, next);
});

module.exports = router;
