import 'quote_card.dart';
import 'package:flutter/material.dart';
import 'quotes.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int ninjaLevel = 0;
  int max = 13;

  void levelInc() {
    if (ninjaLevel < max) {
      ninjaLevel += 1;
    } else {
      ninjaLevel = max;
    }
  }

  void levelDec() {
    if (ninjaLevel > 0) {
      ninjaLevel -= 1;
    } else {
      ninjaLevel = 0;
    }
  }

  List<String> names = ["Aman", "Vignesh", "Kundeti"];

  List<Quotes> quotes = [
    Quotes("BAZINGAA", "SHELDON"),
    Quotes("F**KING DIABOLICAL", "BUTCHER"),
    Quotes("Please don't judge me based on this", "BHANU")
  ];

  Razorpay razorpay = Razorpay();
  @override
  Widget build(BuildContext context) {
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Ninja ID Card',
          style: TextStyle(
            color: Colors.white,
            fontFamily: "BebasNeue",
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.grey[850],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                padding: const EdgeInsets.all(2.0), // Border width
                decoration: const BoxDecoration(
                  color: Colors.blue, // Border color
                  shape: BoxShape.circle,
                ),
                child: const CircleAvatar(
                  backgroundImage: AssetImage("assets/zenitsu.jpeg"),
                  radius: 69,
                ),
              ),
            ),
            const Divider(
              height: 90,
              color: Color.fromARGB(255, 48, 48, 48),
            ),
            const Text(
              "NAME",
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "AMAN VIGNESH KUNDETI",
              style: TextStyle(
                  color: Colors.amberAccent[100],
                  letterSpacing: 2,
                  fontSize: 25,
                  // fontWeight: FontWeight.bold,
                  fontFamily: "BebasNeue"),
            ),
            const SizedBox(height: 30),
            const Text(
              "CURRENT NINJA LEVEL",
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(levelDec);
                  },
                  icon: const Icon(
                    Icons.remove,
                    color: Colors.redAccent,
                  ),
                ),
                Text(
                  "$ninjaLevel",
                  style: TextStyle(
                      color: Colors.amberAccent[100],
                      letterSpacing: 2,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () {
                    setState(levelInc);
                  },
                  icon: const Icon(
                    Icons.add,
                    color: Colors.lightGreen,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    var options = {
                      'key': 'rzp_test_GcZZFDPP0jHtC4',
                      'amount': 100,
                      'name': 'Acme Corp.',
                      'description': 'Fine T-Shirt',
                      'prefill': {
                        'contact': '8888888888',
                        'email': 'test@razorpay.com'
                      }
                    };
                    razorpay.open(options);
                  },
                  icon: const Icon(
                    Icons.payment,
                    color: Colors.yellow,
                  ),
                )
              ],
            ),
            const SizedBox(height: 13),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: names
                  .map((name) => Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              color: Colors.white),
                          child: Text(
                            name,
                            style: const TextStyle(color: Colors.black),
                          ),
                        ),
                      ))
                  .toList(),
            ),
            const SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: quotes
                    .map((quote) => QuoteCard(quote, () {
                          setState(() {
                            quotes.remove(quote);
                          });
                        }))
                    .toList(),
              ),
            )
          ],
        ),
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

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "Payment Successful");
    setState(() {
      ninjaLevel=50;
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "Payment Failed");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    try {
      razorpay.clear();
    } on Exception catch (e) {
      // TODO
      print(e);
    }
  }
}
