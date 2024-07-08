import 'package:flutter/material.dart';
import 'package:ninja_demo/pages/worldTime.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  const Loading({super.key});

  @override
  State<Loading> createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  String now = 'loading';
  String m = "";

  void getTime() async {
    Worldtime time1 = Worldtime('Asia/Kolkata', 'Kolkata', '');
    await time1.getData();
    await Navigator.pushReplacementNamed(context, '/clock', arguments: {
      'location': time1.location,
      'flag': time1.flag,
      'time': time1.time.substring(11,16),
      'isDayTime': time1.isDayTime,
      'isMeridian': time1.isMeridian
    });
  }

  @override
  void initState() {
    super.initState();
    getTime();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: SpinKitThreeInOut(
          color: Colors.black,
          size: 50.0,
        ),
      ),
      backgroundColor: Colors.amber,
    );
  }
}
