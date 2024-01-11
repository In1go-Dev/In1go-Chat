import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key, required this.reload});

  final VoidCallback reload;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              const Padding(
                padding: EdgeInsets.fromLTRB(50, 10, 50, 25),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 5),
                      child: Text('Oops!', style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold)),
                    ),
                    Text('Something went wrong. Please try again.')
                  ]
                )
              ),

              FilledButton(
                onPressed: reload,
                style: FilledButton.styleFrom(shape: const StadiumBorder()),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.replay_outlined),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: Text('Reload')
                      )
                    ]
                  )
                )
              )
            ]
          )
        )
      )
    );
  }
}