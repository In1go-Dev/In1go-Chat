import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CurrentTimeStreamBuilder extends StatelessWidget {
  const CurrentTimeStreamBuilder({super.key, required this.chatTime});

  final DateTime chatTime;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: displayCurrTime(),
      builder:(context, result) {
        if(result.connectionState == ConnectionState.active && result.hasData) {
          return Text(result.data!);
        }
        return const Text('');
      },
    );
  }

  Stream<String> displayCurrTime() async* {            //09-18-2023: GEU - Checks the timestamp's duration to return different displays
    while (true) {
      DateTime now = DateTime.now();
      Duration difference = now.difference(chatTime);
  
      if (chatTime.year == now.year) {                       //Check if the timestamp is the same year
        if (chatTime.day == now.day) {                       //Check if the timestamp is the same day
          int differenceInMinutes = difference.inMinutes;

          if (differenceInMinutes < 1) {                     //Check if the timestamp is less than a minute ago
            yield 'Now';
          }

          else if (differenceInMinutes >= 1 && difference.inMinutes < 60) {        //Checks if the timestamp is more than a minute or less than an hour.
            yield '${difference.inMinutes} min';
          }

          else if(difference.inMinutes == 60) {
            yield '1h';
          }

          else {
            yield DateFormat("h:mm a").format(DateTime.parse(chatTime.toString()));
          }
        }

        else {
          yield DateFormat('MM/dd').format(DateTime.parse(chatTime.toString()));
        }
      } 
      else {
        yield chatTime.year.toString();
      }
  
      // Wait for 1 minute before emitting the next value
      await Future.delayed(const Duration(minutes: 1));
    }
  }
}