import 'package:app_1gochat/Models/ModelProvider.dart';
import 'package:app_1gochat/Screens/Home_Page/Widgets/Contacts/Chat%20History/c_filtering_room_list.dart';
import 'package:flutter/material.dart';

class ContactListSingleRooms extends StatelessWidget {
  const ContactListSingleRooms({super.key, required this.currentUserId, required this.currentTimeZone, required this.scrollController,
  required this.data, required this.navigateToChatScreen, required this.navigateToAccountScreen});

  final String currentUserId;
  final String currentTimeZone;
  final ScrollController scrollController;
  final List<MapEntry<User, Room>> data;
  final void Function(Room, String) navigateToChatScreen;
  final void Function(Room, User) navigateToAccountScreen;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<MapEntry<User, Room>>>(
      future: filterChatRooms(),
      builder:(context, result) {
        if(result.connectionState == ConnectionState.done && result.hasData && result.data!.isNotEmpty) {
          final items = result.data!;

          return FilterSingleRoomList(
            currentUserId: currentUserId,
            currentTimeZone: currentTimeZone,
            scrollController: scrollController,
            chatItems: items,
            navigateToChatScreen: navigateToChatScreen,
            navigateToAccountScreen: navigateToAccountScreen,
          );
        }

        else if(result.connectionState == ConnectionState.done && result.hasData && result.data!.isEmpty) {
          return const Center(
            child: Text('Your chat history is empty')
          );
        }

        return const SizedBox.expand();
      },
    );
  }

  //Future functionality to filter out Chat Rooms without Latest Messages, before sorting them by date

  Future<List<MapEntry<User, Room>>> filterChatRooms() async {
    final filterChatItems = data.where((element) {
      if((element.value.latest_message != null && element.value.latest_message!.isNotEmpty) || (element.value.message_type != null && element.value.message_type!.isNotEmpty)) {
        if(element.value.message_timestamp != null && element.value.message_timestamp!.isNotEmpty) {
          return true;
        }
        return false;
      }
      return false;
    }).toList();

    final sortedChatItems = filterChatItems..sort((e1, e2) {
      DateTime date1 = DateTime.parse(e1.value.message_timestamp!);
      DateTime date2 = DateTime.parse(e2.value.message_timestamp!);
      return date2.compareTo(date1);
    });

    return sortedChatItems;
  }
}