import 'package:app_1gochat/Models/ModelProvider.dart';
import 'package:app_1gochat/Providers/homepagesettings.dart';
import 'package:app_1gochat/Screens/Home_Page/Widgets/Contacts/Contacts/c_contact_user_listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterContactList extends ConsumerWidget {
  const FilterContactList({super.key, required this.scrollController, required this.sortedContacts, required this.clickChatEvent, required this.clickAccountEvent});

  final ScrollController scrollController;
  final List<MapEntry<User, Room>> sortedContacts;
  final void Function(Room, String) clickChatEvent;
  final void Function(Room, User) clickAccountEvent;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: filterUserContacts(ref.watch(searchInput).toLowerCase()),
      builder:(context, result) {
        final search = ref.watch(searchInput);

        if(result.connectionState == ConnectionState.done && result.hasData && result.data!.isNotEmpty) {
          final chatRoom = result.data!;
          
          return ContactUserListView(
            chatRoom: chatRoom,
            scrollController: scrollController,
            clickChatEvent: clickChatEvent,
            clickAccountEvent: clickAccountEvent,
          );
        }

        else if (result.connectionState == ConnectionState.done && result.hasData && result.data!.isEmpty && search.isNotEmpty) {
          return const Center(
            child: Text('This contact doesn\'t exist')
          );
        }

        return const SizedBox.expand();
      }
    );
  }

  //Future Functionality to filter out list content depending on the search input

  Future<List<MapEntry<User, Room>>> filterUserContacts(String searchInput) async {
    final filteredContacts = sortedContacts.where((element) => element.key.username.toLowerCase().contains(searchInput)).toList();
    return filteredContacts;
  }
}