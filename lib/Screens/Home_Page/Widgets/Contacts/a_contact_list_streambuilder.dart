import 'dart:async';
import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app_1gochat/Models/ModelProvider.dart';
import 'package:app_1gochat/Screens/Home_Page/Widgets/Contacts/d_empty_contacts.dart';
import 'package:app_1gochat/Screens/Home_Page/Widgets/Contacts/b_room_members_futurebuilder.dart';
import 'package:app_1gochat/Screens/Home_Page/Widgets/chat_shimmer_load.dart';
import 'package:app_1gochat/Screens/Home_Page/Widgets/retry_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactListBuilder extends ConsumerStatefulWidget {
  const ContactListBuilder({super.key, required this.currentUserId, required this.username});
  
  final String currentUserId;
  final String username;

  @override
  ConsumerState<ContactListBuilder> createState() => _ContactListBuilderState();
}

class _ContactListBuilderState extends ConsumerState<ContactListBuilder> {
  Widget? contactListBuilder;
  final ScrollController scrollController = ScrollController();
  StreamController<List<User>> userController = StreamController<List<User>>.broadcast();  //Stream Controller for User record updates
  StreamController<List<Room>> roomController = StreamController<List<Room>>.broadcast();  //Stream Controller for Room record updates

  @override
  Widget build(BuildContext context){
    if(contactListBuilder != null) {
      return contactListBuilder!;
    }

    else{
      return const SizedBox.expand();
    }
  }

  @override
  void initState() {
    super.initState();
    contactListBuilder = contactListBuilderWidget();
  }

  @override
  void dispose() {
    userController.close();
    roomController.close();
    scrollController.dispose();
    super.dispose();
  }

  Widget contactListBuilderWidget() {
    return StreamBuilder(
      stream: Amplify.DataStore.observeQuery<RoomUser>(
        RoomUser.classType,
        where: RoomUser.USER.eq(widget.currentUserId)
      ),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
          final result = snapshot.requireData;

          if(result.isSynced && result.items.isNotEmpty) {
            List<Room> results = List.generate(result.items.length, (index) => result.items[index].room);
            final filteredResults = results.where((element) => element.isGroup != true).toList();
  
            log('Passed on Contact List Builder...');
  
            return OtherRoomMembersFutureBuilder(
              currentUserId: widget.currentUserId,
              username: widget.username,
              filteredRooms: filteredResults,
              scrollController: scrollController,
              userController: userController,
              roomController: roomController,
            );
          }
  
          else if(result.isSynced && result.items.isEmpty) {
            return AddContactFutureBuilder(
              currentUserId: widget.currentUserId,
            );
          }
  
          else {
            return ShimmerLoadingDisplay(
              retry: () {
                setState(() {
                  contactListBuilder = contactListBuilderWidget();
                });
              }
            );
          }
        }

        else if(snapshot.hasError) {
          return Center(
            child: RetryDisplay(
              retry: () {
                setState(() {
                  contactListBuilder = contactListBuilderWidget();
                });
              }
            )
          );
        }

        else {
          return const SizedBox.expand();
        }
      }
    );
  }
}