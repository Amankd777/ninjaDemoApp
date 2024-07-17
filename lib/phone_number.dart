import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/services.dart';
import 'package:ninja_demo/otp_ver.dart';
import 'package:ninja_demo/pages/home.dart';

class PhoneNumberPage extends StatefulWidget {
  @override
  _PhoneNumberPageState createState() => _PhoneNumberPageState();
}

class _PhoneNumberPageState extends State<PhoneNumberPage> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _signOutCurrentUser();
  }

  Future<void> _signOutCurrentUser() async {
    try {
      await Amplify.Auth.signOut();
    } catch (e) {
      print('Error signing out: $e');
      // Optionally, you can show a snackbar or dialog here to inform the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Enter Phone Number')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: 'Enter your phone number',
                  prefixText: '+91 ', // Adjust this based on your country code
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (value.length != 10) {
                    return 'Phone number must be 10 digits';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitPhoneNumber,
                child: Text('Continue'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitPhoneNumber() async {
    if (_formKey.currentState!.validate()) {
      String phoneNumber =
          '+91${_phoneController.text}'; // Adjust prefix based on your country code
      try {
        final signInResult = await Amplify.Auth.signIn(
          username: phoneNumber,
          password: 'Temp$phoneNumber', // Use a temporary password
        );

        if (signInResult.isSignedIn) {
          // This should not happen; user should go through OTP verification
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Home()),
          );
        } else if (signInResult.nextStep.signInStep ==
            'CONFIRM_SIGN_IN_WITH_SMS_MFA_CODE') {
          // Existing user, needs OTP verification
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationPage(
                phoneNumber: phoneNumber,
                isSignUp: false,
              ),
            ),
          );
        }
      } on UserNotFoundException {
        // New user, initiate sign-up
        try {
          final signUpResult = await Amplify.Auth.signUp(
            username: phoneNumber,
            password: 'Temp$phoneNumber',
            options: SignUpOptions(
              userAttributes: {
                CognitoUserAttributeKey.phoneNumber: phoneNumber,
                CognitoUserAttributeKey.name: "Aman Vignesh Kundeti",
              },
            ),
          );
          if (signUpResult.nextStep.signUpStep == 'CONFIRM_SIGN_UP_STEP') {
            // New user, needs OTP verification
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpVerificationPage(
                  phoneNumber: phoneNumber,
                  isSignUp: true,
                ),
              ),
            );
          } else {
            print('Unexpected next step: ${signUpResult.nextStep.signUpStep}');
          }
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error during sign-up: ${e.toString()}')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }
}
