import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../utils/validators.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _codeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  int _step = 1; // 1: Email, 2: Code, 3: New Password
  String? _emailAddress;
  String? _resetCode;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _sendResetCode() async {
    if (!_formKey.currentState!.validate()) return;

    final authService = context.read<AuthService>();
    final response = await authService.sendPasswordResetCode(
      emailAddress: _emailController.text.trim(),
    );

    if (!mounted) return;

    if (response.success) {
      setState(() {
        _step = 2;
        _emailAddress = _emailController.text.trim();
      });
      _showSuccessDialog('Reset code sent to your email');
    } else {
      _showErrorDialog(response.message);
    }
  }

  Future<void> _verifyCode() async {
    if (_codeController.text.isEmpty) {
      _showErrorDialog('Please enter verification code');
      return;
    }

    final authService = context.read<AuthService>();
    final response = await authService.verifyResetCode(
      emailAddress: _emailAddress!,
      code: _codeController.text.trim(),
    );

    if (!mounted) return;

    if (response.success) {
      setState(() {
        _step = 3;
        _resetCode = _codeController.text.trim();
      });
    } else {
      _showErrorDialog(response.message);
    }
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final authService = context.read<AuthService>();
    final response = await authService.resetPassword(
      emailAddress: _emailAddress!,
      code: _resetCode!,
      password: _passwordController.text,
      confPassword: _confirmPasswordController.text,
    );

    if (!mounted) return;

    if (response.success) {
      _showSuccessDialogAndNavigate();
    } else {
      _showErrorDialog(response.message);
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialogAndNavigate() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: const Text('Password reset successfully! Please login with your new password.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 24),

                // Step Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStepIndicator(1, _step >= 1),
                    _buildStepLine(_step >= 2),
                    _buildStepIndicator(2, _step >= 2),
                    _buildStepLine(_step >= 3),
                    _buildStepIndicator(3, _step >= 3),
                  ],
                ),
                const SizedBox(height: 32),

                if (_step == 1) ..._buildStep1(),
                if (_step == 2) ..._buildStep2(),
                if (_step == 3) ..._buildStep3(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepIndicator(int step, bool active) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: active ? Colors.blue : Colors.grey[300],
      ),
      child: Center(
        child: Text(
          '$step',
          style: TextStyle(
            color: active ? Colors.white : Colors.grey[600],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildStepLine(bool active) {
    return Container(
      width: 40,
      height: 2,
      color: active ? Colors.blue : Colors.grey[300],
    );
  }

  List<Widget> _buildStep1() {
    return [
      Text(
        'Enter your email address',
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 16),
      const Text(
        'We will send you a verification code to reset your password',
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 32),
      TextFormField(
        controller: _emailController,
        decoration: const InputDecoration(
          labelText: 'Email Address',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.email),
        ),
        keyboardType: TextInputType.emailAddress,
        validator: Validators.validateEmail,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (_) => _sendResetCode(),
      ),
      const SizedBox(height: 24),
      Consumer<AuthService>(
        builder: (context, authService, _) {
          return ElevatedButton(
            onPressed: authService.isLoading ? null : _sendResetCode,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: authService.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Send Code', style: TextStyle(fontSize: 16)),
          );
        },
      ),
    ];
  }

  List<Widget> _buildStep2() {
    return [
      Text(
        'Enter verification code',
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 16),
      Text(
        'Check your email $_emailAddress for the code',
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 32),
      TextFormField(
        controller: _codeController,
        decoration: const InputDecoration(
          labelText: 'Verification Code',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.lock),
        ),
        keyboardType: TextInputType.number,
        maxLength: 6,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (_) => _verifyCode(),
      ),
      const SizedBox(height: 24),
      Consumer<AuthService>(
        builder: (context, authService, _) {
          return ElevatedButton(
            onPressed: authService.isLoading ? null : _verifyCode,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: authService.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Verify Code', style: TextStyle(fontSize: 16)),
          );
        },
      ),
    ];
  }

  List<Widget> _buildStep3() {
    return [
      Text(
        'Create new password',
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 32),
      TextFormField(
        controller: _passwordController,
        decoration: InputDecoration(
          labelText: 'New Password',
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.lock),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        obscureText: _obscurePassword,
        validator: Validators.validatePassword,
        textInputAction: TextInputAction.next,
      ),
      const SizedBox(height: 16),
      TextFormField(
        controller: _confirmPasswordController,
        decoration: InputDecoration(
          labelText: 'Confirm Password',
          border: const OutlineInputBorder(),
          prefixIcon: const Icon(Icons.lock_outline),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
            ),
            onPressed: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
          ),
        ),
        obscureText: _obscureConfirmPassword,
        validator: (value) => Validators.validatePasswordConfirmation(
          value,
          _passwordController.text,
        ),
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (_) => _resetPassword(),
      ),
      const SizedBox(height: 24),
      Consumer<AuthService>(
        builder: (context, authService, _) {
          return ElevatedButton(
            onPressed: authService.isLoading ? null : _resetPassword,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: authService.isLoading
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Reset Password', style: TextStyle(fontSize: 16)),
          );
        },
      ),
    ];
  }
}
