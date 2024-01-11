import 'package:flutter/material.dart';


//Widget Display if the Chat App discover an error during app initialization

class FailedChatApp extends StatelessWidget {
  const FailedChatApp({super.key, required this.errorMessage});

  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 25),
          child: Center(
            child: Card(
              //color: Colors.red[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15)
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 25, bottom: 40, left: 15, right: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 10, left: 0),
                      child: const Icon(
                        Icons.error,
                        fill: 0,
                        color: Colors.red,
                        size: 50
                      )
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text('Oops!', style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold))
                    ),
                    
                    Text(
                      errorMessage,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 15)
                    ),
                  ]
                )
              )
            )
          )
        )
      )
    );
  }
}