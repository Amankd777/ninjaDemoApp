import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final bool isSignUp;

  const OtpVerificationPage({super.key, required this.phoneNumber, required this.isSignUp});

  @override
  _OtpVerificationPageState createState() => _OtpVerificationPageState();
}

class _OtpVerificationPageState extends State<OtpVerificationPage> {
  final _otpController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _sendOtp();
  }

  void _sendOtp() async {
    try {
      if (widget.isSignUp) {
        final signUpResult = await Amplify.Auth.signUp(
          username: widget.phoneNumber,
          password: 'dummy_password',
          options: SignUpOptions(
            userAttributes: {
              CognitoUserAttributeKey.phoneNumber: widget.phoneNumber,
              CognitoUserAttributeKey.name: "Aman Vignesh Kundeti",
            },
          ),
        );

        if (signUpResult.nextStep.signUpStep == 'CONFIRM_SIGN_UP_STEP') {
          print('OTP sent for sign-up');
        }
      } else {
        final res = await Amplify.Auth.fetchAuthSession();
        if (res.isSignedIn) {
          // User is already signed in, navigate to home
          Navigator.pushReplacementNamed(context, '/home');
          return;
        }

        // Initiate custom auth flow
        // final signInResult = 
        await Amplify.Auth.signIn(
          username: widget.phoneNumber,
          password:
              'dummy_password', // This is required but not used in custom auth
        );

        // if (signInResult.nextStep.signInStep ==
        //     'CONFIRM_SIGN_IN_WITH_SMS_MFA_CODE') {
        //   print('OTP sent for sign-in');
        // } else {
        //   print('Unexpected next step: ${signInResult.nextStep.signInStep}');
        // }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sending OTP: ${e.toString()}')),
      );
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Enter the OTP sent to ${widget.phoneNumber}'),
              const SizedBox(height: 20),
              TextFormField(
                controller: _otpController,
                decoration: const InputDecoration(labelText: 'OTP'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the OTP';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyOtp,
                child: const Text('Verify'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _verifyOtp() async {
    if (_formKey.currentState!.validate()) {
      try {
        if (widget.isSignUp) {
          final result = await Amplify.Auth.confirmSignUp(
            username: widget.phoneNumber,
            confirmationCode: _otpController.text,
          );
          if (result.isSignUpComplete) {
            // Navigate to additional info page
            Navigator.pushReplacementNamed(context, '/info');
          }
        } else {
          final result = await Amplify.Auth.confirmSignIn(
            confirmationValue: _otpController.text,
          );
          if (result.isSignedIn) {
            // Navigate to home page
            Navigator.pushReplacementNamed(context, '/home');
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error verifying OTP: ${e.toString()}')),
        );
        print(e);
      }
    }
  }
}
