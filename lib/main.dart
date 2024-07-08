import 'package:flutter/material.dart';

import 'package:ninja_demo/pages/home.dart';
import 'package:ninja_demo/pages/clock.dart';
import 'package:ninja_demo/pages/loading.dart';
import 'package:ninja_demo/pages/location.dart';
import 'package:ninja_demo/pages/checkout.dart';
import 'package:ninja_demo/signin.dart';
import 'package:ninja_demo/signup.dart';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'amplifyconfiguration.dart';

void configureAmplify() async {
  try {
    Amplify.addPlugin(AmplifyAuthCognito());
    await Amplify.configure(amplifyconfig);
  } catch (e) {
    print('An error occurred configuring Amplify: $e');
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureAmplify();
  runApp(MaterialApp(
    initialRoute: '/signin',
    routes: {
      '/loading': (context) => const Loading(),
      '/home': (context) => const Home(),
      '/checkout': (context) => const Checkout(),
      '/location': (context) => const Location(),
      '/clock': (context) => const Clock(),
      '/signup': (context)=> SignUpScreen(),
      '/signin': (context)=> SignInScreen(),
    },
  ));
}