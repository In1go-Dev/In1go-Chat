import 'package:app_1gochat/Models/ModelProvider.dart';
import 'package:app_1gochat/Screens/Home_Page/Widgets/Contacts/Chat%20History/b_single_room_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';

class LocalTimeStreamBuilder extends StatelessWidget {
  const LocalTimeStreamBuilder({super.key, required this.currentUserId, required this.scrollController, required this.data, required this.clickChatEvent, required this.clickAccountEvent});

  final String currentUserId;
  final ScrollController scrollController;
  final List<MapEntry<User, Room>> data;
  final void Function(Room, String) clickChatEvent;
  final void Function(Room, User) clickAccountEvent;
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<String>(
      stream: getLocalTimeZone(),
      builder:(context, result) {
        if(result.hasData && result.data!.isNotEmpty) {
          final currentTimeZone = result.data!;

          return ContactListSingleRooms(
            currentUserId: currentUserId,
            currentTimeZone: currentTimeZone,
            scrollController: scrollController,
            data: data,
            navigateToChatScreen: clickChatEvent,
            navigateToAccountScreen: clickAccountEvent,
          );
        }
        
        return const SizedBox.expand();
      }
    );
  }

  Stream<String> getLocalTimeZone() async* {
    String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    yield currentTimeZone;
  }
}