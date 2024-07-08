import 'package:flutter/material.dart';

class Checkout extends StatefulWidget {
  const Checkout({super.key});

  @override
  State<Checkout> createState() => _CheckoutState();
}

class _CheckoutState extends State<Checkout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Text(
        "Checkout and Pay"
      ),
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
                Icons.edit_location,
                color: Colors.black,
              ),
              label: 'Location'),
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