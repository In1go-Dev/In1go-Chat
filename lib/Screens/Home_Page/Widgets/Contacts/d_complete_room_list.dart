import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app_1gochat/Models/ModelProvider.dart';
import 'package:app_1gochat/Providers/homepagesettings.dart';
import 'package:app_1gochat/Providers/message_list_provider.dart';
import 'package:app_1gochat/Screens/AccountMenu_Page/other_account_page.dart';
import 'package:app_1gochat/Screens/Chat_Page/chat_page.dart';
import 'package:app_1gochat/Screens/Home_Page/Widgets/Contacts/Contacts/a_contact_user_list.dart';
import 'package:app_1gochat/Screens/Home_Page/Widgets/Contacts/Chat%20History/a_localtime_streambuilder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CompleteRoomList extends ConsumerWidget {
  const CompleteRoomList({super.key, required this.currentUserId, required this.username, required this.roomMembers, required this.roomList, required this.scrollController});

  final String currentUserId;
  final String username;
  final List<User> roomMembers;
  final List<Room> roomList;
  final ScrollController scrollController;
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: displayRoomLists(),
      initialData: null,
      builder: (context, result) {
        if(result.connectionState == ConnectionState.done && result.hasData && result.data!.isNotEmpty) {
          final items = result.data!;

          return contactListWidgetSet(context, ref, items, ref.watch(pageindex));
        }

        else if(result.connectionState == ConnectionState.done && result.hasData && result.data!.isEmpty) {
          return const Center(
            child: Text('You have no contacts')
          );
        }

        return const SizedBox.expand();
      },
    );
  }

  //Future functionality for creating a list of maps containing the User with the corresponding Chat Room assigned to it (Two Person Chat Rooms)

  Future<List<MapEntry<User, Room>>> displayRoomLists() async {
    Map<User, Room> roomMap = {};
    Map<User, Room> extras;

    for(var index = 0; index < roomList.length; index++) {
      User contactMember = roomMembers[index];
      Room contactItem = roomList[index];

      extras = <User, Room>{contactMember: contactItem};
      roomMap.addEntries(extras.entries);
    }
    
    return roomMap.entries.toList();
  }
  
  //Page Navigation towards Chat Page
  
  void navigateToChatPage(BuildContext context, WidgetRef ref, Room? contacts, String chatname) {
    try {

      final sendMessage = ref.read(messageProvider).addMessage;
      
      if(context.mounted) {
        Navigator.push(context, MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return ChatPage (
              currentUserId: currentUserId,
              chatname: chatname,
              username: username,
              recipient: contacts!,
              sendMessage: sendMessage,
            );
          }
        ));
      }
    } on Exception catch(e) {
      safePrint('Error in navigation - $e');
    }
  }

  //Page Navigation towards Account Display Page containing the selected contact's account information
  
  void navigateToAccountPage(BuildContext context, User userData, Room roomData) {
    try {
      if(context.mounted) {
        Navigator.push(context, MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return OtherAccountPage(
              currentUserId: currentUserId,
              username: username,
              userItem: userData,
              recipient: roomData,
            );
          }
        ));
      }
    } on Exception catch(e) {
      safePrint('Error in navigation - $e');
    }
  }

  Widget contactListWidgetSet (BuildContext context, WidgetRef ref, List<MapEntry<User, Room>> data, int index) {
    switch (index) {
      case 0:
        return LocalTimeStreamBuilder(
          currentUserId: currentUserId,
          scrollController: scrollController,
          data: data,
          clickChatEvent: (value, key) => navigateToChatPage(context, ref, value, key),
          clickAccountEvent: (value, key) => navigateToAccountPage(context, key, value),
        );
      case 1:
        return ContactListUsers(
          scrollController: scrollController,
          data: data,
          clickChatEvent: (value, key) => navigateToChatPage(context, ref, value, key),
          clickAccountEvent: (value, key) => navigateToAccountPage(context, key, value),
        );
      default:
        return const SizedBox();
    }
  }
}