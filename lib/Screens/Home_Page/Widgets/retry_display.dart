import 'package:flutter/material.dart';

class RetryDisplay extends StatelessWidget {
  const RetryDisplay({super.key, required this.retry});

  final VoidCallback retry;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('There was an error during the loading of data'),
        Container(
          margin: const EdgeInsets.only(top: 10),
          child: FilledButton(
            style: FilledButton.styleFrom(shape: const StadiumBorder()),
            onPressed: retry,
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
    );
  }
}