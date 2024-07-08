import 'package:flutter/material.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  String _errorMessage = '';
  bool _isOtpSent = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _phoneNumberController,
              decoration: InputDecoration(labelText: 'Phone Number'),
            ),
            SizedBox(height: 16.0), // Adding some spacing
            ElevatedButton(
              onPressed: _getOtp,
              child: Text('Get OTP'),
            ),
            SizedBox(height: 16.0), // Adding some spacing
            TextField(
              controller: _otpController,
              decoration: InputDecoration(labelText: 'OTP'),
            ),
            ElevatedButton(
              onPressed: _signIn,
              child: Text('Sign In'),
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

  void _getOtp() async {
    try {
      final formattedPhoneNumber = formatPhoneNumber(_phoneNumberController.text.trim());

      await Amplify.Auth.signIn(
        username: formattedPhoneNumber,
        password: 'tempPassword123!', // Use a temporary password for OTP flow
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
      print('Get OTP error: $e');
    }
  }

  void _signIn() async {
    try {
      final formattedPhoneNumber = formatPhoneNumber(_phoneNumberController.text.trim());
      final otp = _otpController.text.trim();

      SignInResult signInResult = await Amplify.Auth.confirmSignIn(
        confirmationValue: otp,
      );

      if (signInResult.isSignedIn) {
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
      print('Sign in error: $e');
    }
  }
}