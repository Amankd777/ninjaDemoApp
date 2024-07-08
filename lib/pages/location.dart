import 'package:flutter/material.dart';
import 'package:ninja_demo/pages/worldTime.dart';

class Location extends StatefulWidget {
  const Location({super.key});

  @override
  State<Location> createState() => _LocationState();
}

class _LocationState extends State<Location> {

  List<Worldtime> locations = [
	    Worldtime('Europe/London', 'London', 'uk.png'),
	    Worldtime('Europe/Athens', 'Athens', 'greece.png'),
	    Worldtime('Africa/Cairo', 'Cairo', 'zenitsu.jpeg'),
	    Worldtime('Africa/Nairobi', 'Nairobi', 'kenya.png'),
	    Worldtime('America/Chicago', 'Chicago', 'usa.png'),
	    Worldtime('America/New_York', 'New York', 'usa.png'),
	    Worldtime('Asia/Seoul', 'Seoul', 'south_korea.png'),
	    Worldtime('Asia/Jakarta', 'Jakarta', 'indonesia.png'),
      Worldtime('Asia/Kolkata', 'Kolkata', 'india.png')
	  ];

  void updateTime(index) async{
    Worldtime time2 = locations[index];
    await time2.getData();
    Navigator.pop(context,{
      'location': time2.location,
      'flag': time2.flag,
      'time': time2.time.substring(11,16),
      'isDayTime': time2.isDayTime,
      'isMeridian': time2.isMeridian
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Location', style: TextStyle(fontFamily: 'BebasNeue', color: Colors.blue)),
        centerTitle: true,
        elevation: 2,
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          child: ListView.builder(
            itemCount: locations.length,
            itemBuilder: (context, index){
              return Card(
                child: ListTile(
                  onTap: (){
                    updateTime(index);
                  },
                  title: Text(locations[index].location),
                  leading: CircleAvatar(backgroundImage: AssetImage('assets/${locations[index].flag}'),),
                ),
              );
            }),
        )),
      bottomNavigationBar: BottomNavigationBar(
        fixedColor: const Color.fromARGB(255, 27, 94, 32),
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.amber,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        useLegacyColorScheme: false,
        currentIndex: 0, 
        onTap: (value){},
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