import 'dart:async';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app_1gochat/Models/ModelProvider.dart';
import 'package:app_1gochat/Screens/Home_Page/Widgets/Contacts/c_complete_contact_streambuilder.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';

class OtherRoomMembersFutureBuilder extends StatefulWidget {
  const OtherRoomMembersFutureBuilder({super.key, required this.currentUserId, required this.username, required this.filteredRooms, required this.scrollController,
  required this.userController, required this.roomController});

  final String currentUserId;
  final String username;
  final List<Room> filteredRooms;
  final ScrollController scrollController;
  final StreamController<List<User>> userController;
  final StreamController<List<Room>> roomController;

  @override
  State<OtherRoomMembersFutureBuilder> createState() => _OtherRoomMembersFutureBuilderState();
}

class _OtherRoomMembersFutureBuilderState extends State<OtherRoomMembersFutureBuilder> {
  Widget? otherRoomMembersFutureBuilder;

  @override
  Widget build(BuildContext context) {
    if(otherRoomMembersFutureBuilder != null) {
      return otherRoomMembersFutureBuilder!;
    }
    else{
      return const SizedBox.expand();
    }
  }

  @override
  void initState() {
    super.initState();
    otherRoomMembersFutureBuilder = otherRoomMembersBuilderWidget();
  }

  Widget otherRoomMembersBuilderWidget() {
    return FutureBuilder(
      future: getOtherRoomMembers(widget.filteredRooms),
      initialData: null,
      builder:(context, result) {
        if(result.connectionState == ConnectionState.done && result.hasData && result.data!.isNotEmpty && widget.filteredRooms.length == result.data!.length) {
          final items = result.data!;
          final combinedUserStreams = combineUserQueries(items);
          final combinedRoomStreams = combineRoomQueries(widget.filteredRooms);

          return RoomStreamBuilder(
            currentUserId: widget.currentUserId,
            username: widget.username,
            otherMembers: items,
            roomLists: widget.filteredRooms,
            scrollController: widget.scrollController,
            userController: widget.userController,
            roomController: widget.roomController,
            combinedUserStreams: combinedUserStreams,
            combinedRoomStreams: combinedRoomStreams,
          );
        }

        else if(result.connectionState == ConnectionState.done && result.hasData && result.data!.isEmpty) {
          return const Center(
            child: Text('You have no contacts')
          );
        }

        else if(result.hasError) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('There was an error during the loading of data'),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: FilledButton(
                    style: FilledButton.styleFrom(shape: const StadiumBorder()),
                    onPressed: () {
                      setState(() {
                        otherRoomMembersFutureBuilder = otherRoomMembersBuilderWidget();
                      });
                    },
                    child: const Text("Retry")
                  )
                )
              ]
            )
          );
        }

        else {
          return const SizedBox.expand();
        }
      }
    );
  }

  Future<List<User>?> getOtherRoomMembers(List<Room> roomLists) async {
    List<User> roomsMembers = [];
    for(int index = 0; index < roomLists.length; index++) {
      
      Room contactItem = roomLists[index];

      //Using the Room records from the previous RoomUser query, requests a new RoomUser query that retrieves all records with the same Room id
      List<RoomUser>? resultingMembers = await Amplify.DataStore.query<RoomUser>(
        RoomUser.classType,
        where: RoomUser.ROOM.eq(contactItem.id),
      ).timeout(const Duration(minutes: 3));


      //Filters out RoomUsers that references the current user
      if(resultingMembers.isNotEmpty && (resultingMembers.length == 2)) {
        User roomName = resultingMembers.where((element) => element.user.id != widget.currentUserId).first.user;
        roomsMembers.add(roomName);
      }
      
    }
    
    return roomsMembers;
  }

  //Creates a list of Streams, containing Amplify User query operations using the User record Ids of the RoomUser results
  Stream<QuerySnapshot<User>> combineUserQueries(List<User> roomMembers) {
    final streamGroup = StreamGroup<QuerySnapshot<User>>();

    safePrint('----- Second Item Set -----');
    for (int x = 0; x < roomMembers.length; x++) {
      final roomStream = Amplify.DataStore.observeQuery<User>(User.classType,
        where: User.ID.eq(roomMembers[x].id),
      );

      safePrint('User Item $x ----- ${roomMembers[x].id}');

      streamGroup.add(roomStream);
    }

    return streamGroup.stream;
  }

  //Creates a list of Streams, containing Amplify Room query operations using the Room record Ids of the RoomUser results
  Stream<QuerySnapshot<Room>> combineRoomQueries(List<Room> items) {
    final streamGroup = StreamGroup<QuerySnapshot<Room>>();

    for (int x = 0; x < items.length; x++) {
      final roomStream = Amplify.DataStore.observeQuery<Room>(Room.classType, where: Room.ID.eq(items[x].id));

      streamGroup.add(roomStream);
    }
  
    return streamGroup.stream;
  }
}