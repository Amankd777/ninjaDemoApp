import 'package:flutter/material.dart';

class Clock extends StatefulWidget {
  const Clock({super.key});

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  Map clock = {};

  @override
  Widget build(BuildContext context) {
    clock = clock.isEmpty
        ? clock
        : ModalRoute.of(context)!.settings.arguments as Map;

    print(clock);

    String bgImage = (clock['isDayTime'] ?? true) ? 'day.jpg' : 'night.jpg';
    String m = (clock['isMeridian'] ?? true) ? 'A.M' : 'P.M';

    return Scaffold(
      appBar: AppBar(
        title: const Text('WORLD CLOCK',
            style: TextStyle(fontFamily: 'BebasNeue', color: Colors.blue)),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/$bgImage"), fit: BoxFit.cover)),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'The Time in ${clock['location']} is:',
              style: const TextStyle(
                  fontFamily: 'BebasNeue',
                  fontSize: 24,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Text(
                "${clock['time']} $m",
                style: const TextStyle(
                    fontFamily: 'BebasNeue',
                    fontSize: 70,
                    color: Colors.amber,
                    fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton.icon(
              onPressed: () async {
                dynamic result =
                    await Navigator.pushNamed(context, '/location');
                clock = {
                  'location': result["location"],
                  'time': result["time"],
                  'isDayTime': result["isDayTime"],
                  'isMeridian': result["isMeridian"]
                };
              },
              label: const Text('Change Location'),
            ),
          ],
        )),
      ),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: const Color.fromARGB(255, 27, 94, 32),
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.amber,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        useLegacyColorScheme: false,
        currentIndex: 0,
        onTap: (value) {},
        items: const [
          BottomNavigationBarItem(
            // activeIcon: Icon(Icons.home),
            icon: Icon(
              Icons.home,
              color: Color.fromARGB(255, 27, 94, 32),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
              activeIcon: Icon(Icons.timelapse_sharp),
              icon: Icon(
                Icons.lock_clock,
                color: Colors.black,
              ),
              label: 'Clock'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.black,
              ),
              label: 'Checkout'),
        ],
      ),
    );
  }
}
