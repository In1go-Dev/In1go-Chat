import 'dart:math';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app_1gochat/Models/ModelProvider.dart';
import 'package:app_1gochat/Screens/Home_Page/Widgets/Contacts/Contacts/d_contact_user_item.dart';
import 'package:app_1gochat/Screens/Home_Page/Widgets/Contacts/Contacts/c_name_divider.dart';
import 'package:flutter/material.dart';

class ContactUserListView extends StatefulWidget {
  const ContactUserListView({super.key, required this.scrollController, required this.chatRoom, required this.clickChatEvent, required this.clickAccountEvent});

  final ScrollController scrollController;
  final List<MapEntry<User, Room>> chatRoom;
  final void Function(Room, String) clickChatEvent;
  final void Function(Room, User) clickAccountEvent;

  @override
  State<ContactUserListView> createState() => _ContactUserListViewState();
}

class _ContactUserListViewState extends State<ContactUserListView> {
  int contactLimit = 10;
  bool isPaginating = false;
  
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.separated(
        controller: widget.scrollController,
        padding: const EdgeInsets.all(0),
        itemCount: min(contactLimit, widget.chatRoom.length),
        itemBuilder: itemBuild(),
        separatorBuilder: (context, index) {
          if(widget.chatRoom[index].key.username[0] == widget.chatRoom[index+1].key.username[0]) {
            return Divider(height: 2, thickness: 1, color: Colors.grey[600]);
          }
          return const SizedBox();
        }
      )
    );
  }

  Widget? Function(BuildContext, int) itemBuild() {
    List<MapEntry<User, Room>> trimmedItems = List.generate(min(contactLimit, widget.chatRoom.length), (index) => widget.chatRoom[index]);
    return (build, index) {
      final item = trimmedItems[index];
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          nameSeperator(trimmedItems, item.key.username[0], index),
          Container(
            margin: EdgeInsets.only(bottom: (index == trimmedItems.length-1) ? 5 : 0),
            child: ContactUserItems(
              accountName: item.key.username,
              navigateToChatScreen: () => widget.clickChatEvent(item.value, item.key.username),
              navigateToAccountScreen: () => widget.clickAccountEvent(item.value, item.key),
            )
          ),
          getPaginationLoading(trimmedItems, index)
        ]
      );
    };
  }

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() {
      paginateContactUsers();
    });
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(() {
      paginateContactUsers();
    });
    super.dispose();
  }
  
  //Functionality for increasing max count for local pagination display

  void paginateContactUsers() async {
    if (widget.scrollController.position.pixels == widget.scrollController.position.maxScrollExtent) {
      if(contactLimit < widget.chatRoom.length && !isPaginating) {
        isPaginating = true;
        await Future.delayed(const Duration(seconds: 1));
        if(mounted) {
          setState(() {
            contactLimit += 10;
            isPaginating = false;
          });
        }
      }
    }
  }
  
  //Widget Display that Checks if Contact Limit is is not at max count of list
  
  Widget getPaginationLoading(List<MapEntry<User, Room>> chatRoom, int index) {
    bool minimumTest = chatRoom.length >= 10;  //Check if length is larger than the initial pagination count
    bool maximumText = chatRoom.length < widget.chatRoom.length;  //Check the maximum count of record list
    bool indexTest = index == min(chatRoom.length-1, contactLimit);  //Check if index is the last
    safePrint("Second Checking > Index Test - $indexTest");
    safePrint("Second Checking > Index Value - $index, Max Index - ${chatRoom.length-1}, Max Limit - $contactLimit");
    bool state = minimumTest && maximumText && indexTest;
    safePrint("Third Checking - $state");
    
    return Visibility(
      visible: state,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(bottom: 10),
        child: const CircularProgressIndicator(),
      )
    );
  }

  //Widget Display for Name Seperator, categorizing the contents alphabetically

  Widget nameSeperator(List<MapEntry<User, Room>> chatRoom, String firstLetter, int index) {
    if(index == 0) {
      return NameDivider(
        firstLetter: firstLetter.toUpperCase(),
        top: 10
      );
    }

    else if(index != chatRoom.length && chatRoom[index].key.username[0] != chatRoom[index-1].key.username[0]) {
      return NameDivider(
        firstLetter: firstLetter.toUpperCase(),
        top: 10
      );
    }
    
    else {
      return const SizedBox();
    }
  }
}