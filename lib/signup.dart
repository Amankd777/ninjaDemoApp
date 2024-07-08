import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  String _errorMessage = '';
  bool _isOtpSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 16.0), // Adding some spacing
            ElevatedButton(
              onPressed: _signUp,
              child: Text('Sign Up'),
            ),
            SizedBox(height: 16.0), // Adding some spacing
            TextField(
              controller: _otpController,
              decoration: InputDecoration(labelText: 'OTP'),
            ),
            ElevatedButton(
              onPressed: _verifyOtp,
              child: Text('Verify OTP'),
            ),
            if (_errorMessage.isNotEmpty)
              Text(
                _errorMessage,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  String formatPhoneNumber(String phoneNumber) {
    String digits = phoneNumber.replaceAll(RegExp(r'\D'), '');
    if (!digits.startsWith('+')) {
      digits = '+91$digits'; // Replace '+91' with the appropriate country code
    }
    return digits;
  }

  void _signUp() async {
    try {
      final formattedPhoneNumber = formatPhoneNumber(_phoneNumberController.text.trim());

      SignUpResult signUpResult = await Amplify.Auth.signUp(
        username: formattedPhoneNumber,
        password: 'tempPassword123!', // A temporary password
        options: SignUpOptions(
          userAttributes: {
            CognitoUserAttributeKey.phoneNumber: formattedPhoneNumber,
            CognitoUserAttributeKey.name: _nameController.text.trim(),
          },
        ),
      );

      // If no exception is thrown, it means OTP has been sent
      setState(() {
        _isOtpSent = true;
        _errorMessage = ''; // Clear any previous error messages
      });

    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      print('Sign up error: $e');
    }
  }

  void _verifyOtp() async {
    try {
      final formattedPhoneNumber = formatPhoneNumber(_phoneNumberController.text.trim());
      final otp = _otpController.text.trim();

      SignUpResult confirmSignUpResult = await Amplify.Auth.confirmSignUp(
        username: formattedPhoneNumber,
        confirmationCode: otp,
      );

      if (confirmSignUpResult.isSignUpComplete) {
        // Navigate to the home page
        Navigator.pushNamed(context, '/home');
      } else {
        setState(() {
          _errorMessage = 'OTP verification failed. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
      print('OTP verification error: $e');
    }
  }
}