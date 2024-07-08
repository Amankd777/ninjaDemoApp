import 'package:flutter/material.dart';
import 'quotes.dart';

class QuoteCard extends StatelessWidget {

  final Quotes quote;
  final VoidCallback delete;
  const QuoteCard(this.quote, this.delete, {super.key});


  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.amber,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Text(quote.text,
              style: const TextStyle(
                fontFamily: "BebasNeue",
              ),),
              const SizedBox(
                height: 8,
              ),
              Text(quote.author,
              style: const TextStyle(
                fontFamily: "BebasNeue",
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),),
              const SizedBox(height: 10,),
              ElevatedButton.icon(onPressed: delete, 
              label: const Text("Delete"),
              icon: const Icon(
                Icons.delete
              ),)
            ],
          ),
        ),
    );
  }
}
