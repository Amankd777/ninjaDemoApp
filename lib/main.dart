import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

import 'package:ninja_demo/otp_ver.dart';
import 'package:ninja_demo/pages/home.dart';
import 'package:ninja_demo/phone_number.dart';
import 'amplifyconfiguration.dart';
import 'auth_wrapper.dart';
import 'info.dart';  // Create this file if it doesn't exist

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _amplifyConfigured = false;

  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() async {
    try {
      await Amplify.addPlugin(AmplifyAuthCognito());
      await Amplify.configure(amplifyconfig);
      setState(() {
        _amplifyConfigured = true;
      });
    } catch (e) {
      print('Error configuring Amplify: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Name',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        if (settings.name == '/') {
          return MaterialPageRoute(
            builder: (context) => _amplifyConfigured ? AuthWrapper() : LoadingScreen(),
          );
        } else if (settings.name == '/phone') {
          return MaterialPageRoute(builder: (context) => PhoneNumberPage());
        } else if (settings.name == '/otp') {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute(
            builder: (context) => OtpVerificationPage(
              phoneNumber: args['phoneNumber'],
              isSignUp: args['isSignUp'],
            ),
          );
        } else if (settings.name == '/home') {
          return MaterialPageRoute(builder: (context) => Home());
        } else if (settings.name == '/info') {
          return MaterialPageRoute(builder: (context) => UserInfo());
        }
        // If you reach here, no route was found
        return MaterialPageRoute(builder: (context) => UnknownRoutePage());
      },
    );
  }
}

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class UnknownRoutePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Page Not Found')),
      body: Center(
        child: Text('The requested page was not found.'),
      ),
    );
  }
}