import 'package:flutter/material.dart';

class EmptyFileDisplay extends StatelessWidget {
  const EmptyFileDisplay({super.key, required this.file, required this.width, required this.icon, required this.isError, this.color, this.clickFunction});

  final double width;
  final String file;
  final IconData icon;
  final bool isError;
  final Color? color;
  final VoidCallback? clickFunction;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: clickFunction,
      child: Container(
        constraints: BoxConstraints(maxWidth: width * 0.45),
        alignment: Alignment.center,
        color: (color != null) ? color : const Color.fromARGB(83, 158, 158, 158),
        //width: width,
        padding: const EdgeInsets.symmetric(vertical: 25),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: Icon(icon, color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                (isError == false) ? file : 'File can\'t load',
                style: const TextStyle(fontSize: 12, color: Colors.white),
                overflow: TextOverflow.ellipsis, maxLines: 1
              )
            )
          ]
        )
      )
    );
  }
}