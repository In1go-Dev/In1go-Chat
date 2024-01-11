import 'dart:async';
import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app_1gochat/Models/ModelProvider.dart';
import 'package:app_1gochat/Screens/Home_Page/Widgets/Contacts/d_complete_room_list.dart';
import 'package:app_1gochat/Screens/Home_Page/Widgets/retry_display.dart';
import 'package:flutter/material.dart';
import 'package:multiple_stream_builder/multiple_stream_builder.dart';

class RoomStreamBuilder extends StatefulWidget {
  const RoomStreamBuilder({super.key, required this.currentUserId, required this.username, required this.otherMembers, required this.roomLists, 
  required this.scrollController, required this.userController, required this.roomController, required this.combinedUserStreams, required this.combinedRoomStreams});

  final String currentUserId;
  final String username;
  final List<User> otherMembers;
  final List<Room> roomLists;
  final ScrollController scrollController;
  final StreamController<List<User>> userController;
  final StreamController<List<Room>> roomController;
  final Stream<QuerySnapshot<User>> combinedUserStreams;
  final Stream<QuerySnapshot<Room>> combinedRoomStreams;

  @override
  State<RoomStreamBuilder> createState() => _RoomStreamBuilderState();
}

class _RoomStreamBuilderState extends State<RoomStreamBuilder> {
  Widget? roomStreamBuilder;

  @override
  Widget build(BuildContext context) {
    if(roomStreamBuilder != null) {
      return roomStreamBuilder!;
    }
    else{
      return const SizedBox.expand();
    }
  }

  @override
  void initState() {
    super.initState();
    roomStreamBuilder = roomStreamBuilderWidget();
  }

  Widget roomStreamBuilderWidget() {
    return StreamBuilder2<List<Room>, List<User>>(
      streams: StreamTuple2(getListofRoom(), getListofUser()),
      initialData: null,
      builder: (context, result) {

        if(result.snapshot1.connectionState == ConnectionState.active && result.snapshot2.connectionState == ConnectionState.active) {

          if(result.snapshot1.hasData && result.snapshot2.hasData) {

            if(result.snapshot1.data!.isNotEmpty && result.snapshot2.data!.isNotEmpty && result.snapshot1.data!.length == result.snapshot2.data!.length) {
              final roomItems = List.generate(result.snapshot2.data!.length, (index) => result.snapshot1.data![index]);
              final userItems = List.generate(result.snapshot1.data!.length, (index) => result.snapshot2.data![index]);
    
              return CompleteRoomList(
                currentUserId: widget.currentUserId,
                username: widget.username,
                roomMembers: userItems,
                roomList: roomItems,
                scrollController: widget.scrollController,
              );
            }

            else if(result.snapshot1.data!.isEmpty && result.snapshot2.data!.isEmpty) {
              return const Center(
                child: Text('You have no contacts')
              );
            }
            
            else {
              return const SizedBox.expand();
            }
          }

          else {
            return const SizedBox.expand();
          }
        }

        else if(result.snapshot1.hasError || result.snapshot2.hasError) {
          return Center(
            child: RetryDisplay(
              retry: () {
                setState(() {
                  roomStreamBuilder = roomStreamBuilderWidget();
                });
              }
            )
          );
        }

        else{
          return const Center(
            child: CircularProgressIndicator()
          );
        }
      }
    );
  }

  Stream<List<Room>> getListofRoom() {
    //Create a List of null values
    final results = List<Room?>.filled(widget.roomLists.length, null);      
    
    //Since this was made from a Stream Group, this function will loop multiple times until all the streams are processed
    widget.combinedRoomStreams.listen((event) {
      if(event.isSynced) {
        
        //Query for the responsive Room values
        final queryResult = event.items.map((item) => item).toList();
  
        for(int x = 0; x < queryResult.length; x++) {
          
          //Search if item's room id has a match in the room list
          final checkItem = widget.roomLists.indexWhere((room) => room.id == queryResult[x].id);
  
          if(checkItem != -1) {
            
            //If index finds a match, replace the value in the list regardless if it's null or not
            results[checkItem] = queryResult[x];
          }
        }
  
        if(widget.otherMembers.length == results.length && !results.contains(null)) {
          log("Passed on Room Controller");
          
          //Add the results in the subject if all streams are processed
          if(!widget.roomController.isClosed) widget.roomController.sink.add(results.cast<Room>().toList());
        }
      }
    }, onError: (error) {
      widget.roomController.sink.addError(error);
    });

    return widget.roomController.stream;
  }

  Stream<List<User>> getListofUser() {
    List<User?> results = List<User?>.filled(widget.otherMembers.length, null);
    
    //Since this was made from a Stream Group, this function will loop multiple times until all the streams are processed
    widget.combinedUserStreams.listen((event) {
      if(event.isSynced) {

        //Query for the responsive User values 
        final queryResult = event.items.map((item) => item).toList();
  
        for(int x = 0; x < queryResult.length; x++) {
          
          //Search if item's user id has a match in the user list
          final checkItem = widget.otherMembers.indexWhere((user) => user.id == queryResult[x].id);
  
          if(checkItem != -1) {
            
            //If index finds a match, replace the value in the list regardless if it's null or not
            results[checkItem] = queryResult[x];
          }
        }
  
        if(widget.otherMembers.length == results.length && !results.contains(null)) {
          log("Passed on User Controller");

          //add the results in the subject if all streams are processed
          if(!widget.userController.isClosed) widget.userController.sink.add(results.cast<User>().toList());
        }
      }

    }, onError: (error) {
      widget.userController.sink.addError(error);
    });

    return widget.userController.stream;
  }
}