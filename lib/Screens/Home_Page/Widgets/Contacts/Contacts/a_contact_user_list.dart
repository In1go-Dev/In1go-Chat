import 'package:app_1gochat/Models/ModelProvider.dart';
import 'package:app_1gochat/Screens/Home_Page/Widgets/Contacts/Contacts/b_filtering_contact_list.dart';
import 'package:flutter/material.dart';

class ContactListUsers extends StatelessWidget {
  const ContactListUsers({super.key, required this.scrollController, required this.data, required this.clickChatEvent, required this.clickAccountEvent});

  final ScrollController scrollController;
  final List<MapEntry<User, Room>> data;
  final void Function(Room, String) clickChatEvent;
  final void Function(Room, User) clickAccountEvent;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: filterUserContacts(),
      builder:(context, result) {
        if(result.connectionState == ConnectionState.done && result.hasData && result.data!.isNotEmpty) {
          final items = result.data!;

          return FilterContactList(
            scrollController: scrollController,
            sortedContacts: items,
            clickChatEvent: clickChatEvent,
            clickAccountEvent: clickAccountEvent,
          );
        }

        else if(result.connectionState == ConnectionState.done && result.hasData && result.data!.isEmpty) {
          return const Center(
            child: Text('You have no contacts')
          );
        }
        
        return const SizedBox.expand();
      }
    );
  }

  Future<List<MapEntry<User, Room>>> filterUserContacts() async {
    //Sort Contacts by Username
    final sortedContacts = data..sort((e1, e2) => e1.key.username.compareTo(e2.key.username));
    return sortedContacts;
  }
}