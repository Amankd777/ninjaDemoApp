import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class UserInfo extends StatefulWidget {
  const UserInfo({super.key});

  @override
  State<UserInfo> createState() => _UserInfoState();
}

class _UserInfoState extends State<UserInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(

        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter your name',
                  ),
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: (){
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: const Text('Continue'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}