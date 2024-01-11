import 'dart:math';

import 'package:app_1gochat/Screens/Home_Page/Widgets/Contacts/Chat%20History/e_single_room_items.dart';
import 'package:flutter/material.dart';

class SingleRoomListView extends StatefulWidget {
  const SingleRoomListView({super.key, required this.scrollController, required this.items});

  final ScrollController scrollController;
  final List<ContactRoomItems> items;

  @override
  State<SingleRoomListView> createState() => _SingleRoomListViewState();
}

class _SingleRoomListViewState extends State<SingleRoomListView> {
  int contactLimit = 10;
  bool isPaginating = false;

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: ListView.separated(
        controller: widget.scrollController,
        padding: const EdgeInsets.all(0),
        itemCount: min(contactLimit, widget.items.length),
        itemBuilder: itemBuild(),
        separatorBuilder:(context, index) => Divider(height: 2, thickness: 1, color: Colors.grey[600])
      )
    );
  }

  Widget? Function(BuildContext, int) itemBuild() {
    List<ContactRoomItems> trimmedItems = List.generate(min(contactLimit, widget.items.length), (index) => widget.items[index]);
    return (build, index) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          trimmedItems[index],
          getPaginationLoading(trimmedItems, index)
        ]
      );
    };
  }

  @override
  void initState() {
    super.initState();
    widget.scrollController.addListener(() {
      paginateSingleRooms();
    });
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(() {
      paginateSingleRooms();
    });
    super.dispose();
  }

  //Functionality for increasing max count for local pagination display

  void paginateSingleRooms() async {
    if (widget.scrollController.position.pixels == widget.scrollController.position.maxScrollExtent) {
      if(contactLimit < min(50, widget.items.length) && !isPaginating) {
        isPaginating = true;
        await Future.delayed(const Duration(seconds: 1));
        if(mounted) {
          setState(() {
            bool result = contactLimit + 10 <= widget.items.length;
            (result) ? contactLimit += 10 : contactLimit = widget.items.length;
            isPaginating = false;
          });
        }
      }
    }
  }
  
  //Widget Display that Checks if Contact Limit is is not at max count of list
  
  Widget getPaginationLoading(List<ContactRoomItems> items, int index) {
    bool limitTest = items.length < 50 && items.length < widget.items.length;
    bool minimumTest = items.length >= 10;
    bool indexTest = index == min(items.length-1, contactLimit);
    bool state = limitTest && minimumTest && indexTest;
    
    return Visibility(
      visible: state,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.only(top: 5, bottom: 10),
        child: const CircularProgressIndicator(),
      )
    );
  }
}