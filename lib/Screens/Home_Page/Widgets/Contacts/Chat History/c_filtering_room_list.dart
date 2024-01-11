import 'package:app_1gochat/Models/ModelProvider.dart';
import 'package:app_1gochat/Providers/homepagesettings.dart';
import 'package:app_1gochat/Screens/Home_Page/Widgets/Contacts/Chat%20History/e_single_room_items.dart';
import 'package:app_1gochat/Screens/Home_Page/Widgets/Contacts/Chat%20History/d_single_room_listview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FilterSingleRoomList extends ConsumerStatefulWidget {
  const FilterSingleRoomList({super.key, required this.currentUserId, required this.currentTimeZone, required this.scrollController, required this.chatItems, 
  required this.navigateToChatScreen, required this.navigateToAccountScreen});

  final String currentUserId;
  final String currentTimeZone;
  final ScrollController scrollController;
  final List<MapEntry<User, Room>> chatItems;
  final void Function(Room, String) navigateToChatScreen;
  final void Function(Room, User) navigateToAccountScreen;

  @override
  ConsumerState<FilterSingleRoomList> createState() => _FilterSingleRoomListState();
}

class _FilterSingleRoomListState extends ConsumerState<FilterSingleRoomList> {
  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: filterSearchResults(ref.watch(searchInput).toLowerCase()),
      builder:(context, result) {
        final search = ref.watch(searchInput);
        if(result.connectionState == ConnectionState.done && result.hasData && result.data!.isNotEmpty) {
          final items = result.data!;
          
          return SingleRoomListView(
            scrollController: widget.scrollController,
            items: items
          );
        }

        else if(result.connectionState == ConnectionState.done && result.hasData && result.data!.isEmpty && search.isNotEmpty) {
          return const Center(
            child: Text('This contact doesn\'t exist')
          );
        }

        return const SizedBox.expand();
      }
    );
  }

  //Future Functionality for filtering out Chat Rooms in accordance to the search text field input

  Future<List<ContactRoomItems>> filterSearchResults(String searchInput) async {

    final filteredChatItems = widget.chatItems.where((element) => element.key.username.toLowerCase().contains(searchInput)).toList();

    final chatRooms = List.generate(filteredChatItems.length, (index) {
      final item = filteredChatItems[index];

      return ContactRoomItems(
        currentUserId: widget.currentUserId,
        currentTimeZone: widget.currentTimeZone,
        accountName: item.key.username,
        roomData: item.value,
        navigateToChatScreen: () => widget.navigateToChatScreen(item.value, item.key.username),
        navigateToAccountScreen: () => widget.navigateToAccountScreen(item.value, item.key),
      );
    });

    return chatRooms;
  }
}