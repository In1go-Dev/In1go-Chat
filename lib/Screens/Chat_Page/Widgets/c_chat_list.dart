import 'dart:async';
import 'dart:math';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app_1gochat/Models/ModelProvider.dart';
import 'package:app_1gochat/Screens/Chat_Page/Widgets/d_chat_divider.dart';
import 'package:app_1gochat/Screens/Chat_Page/Widgets/d_chat_message.dart';
import 'package:app_1gochat/Screens/Home_Page/Widgets/retry_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:timezone/timezone.dart' as tz;

class ChatList extends StatefulWidget {
  const ChatList({super.key, required this.username, required this.currentUserId, required this.recipient, required this.currentTimeZone, required this.scrollController});

  final String username;
  final String recipient;
  final String currentUserId;
  final String currentTimeZone;
  final ScrollController scrollController;

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  StreamSubscription<QuerySnapshot<Message>>? observationSubscription;
  int messageLimit = 20;
  bool isPaginating = false;
  List<Message> listofChatMessages = List.empty();
  List<ChatMessage> chatWidgets = List.empty();
  bool isError = false;
  
  @override
  Widget build(BuildContext context) {
    if(isError == false) {
      return Scrollbar(
        child: ListView.custom(
          reverse: true,
          padding: const EdgeInsets.all(15),
          cacheExtent: MediaQuery.of(context).size.height * 2,
          controller: widget.scrollController,
          childrenDelegate: displaySliverChat()
        )
      );
    }
    else {
      return Center(
        child: RetryDisplay(
          retry: () {
            displayChatMessages();
          }
        )
      );
    }
  }

  @override
  void initState() {
    super.initState();
    displayChatMessages();
    widget.scrollController.addListener(() {
      paginateChatMessages();
    });
  }

  @override
  void dispose() {
    observationSubscription?.cancel();
    widget.scrollController.removeListener(() {
      paginateChatMessages();
    });
    super.dispose();
  }
  
  //Functionality for increasing max count for local pagination display

  void paginateChatMessages() async {
    if (widget.scrollController.position.pixels == widget.scrollController.position.maxScrollExtent) {
      if(messageLimit < chatWidgets.length && !isPaginating) {
        isPaginating = true;
        await Future.delayed(const Duration(seconds: 1));
        if(mounted) {
          setState(() {
            if(messageLimit < 100) {
              messageLimit += 20;
            }

            else {
              messageLimit += 50;
            }
            isPaginating = false;
          });
        }
      }
    }
  }

  //Retrieves Record List from Amplify Datastore

  void displayChatMessages() async {
    observationSubscription = Amplify.DataStore.observeQuery(
      Message.classType,
      where: Message.ROOM_ID.eq(widget.recipient),
      sortBy: [Message.TIMESTAMP.descending()]).listen((event) {
        if(event.isSynced) {
          final results = event.items;

          safePrint("Message Length - ${results.length}");
          safePrint("Message Latest Date - ${results.first.timestamp}");

          if(chatWidgets.isEmpty) {
            if(mounted) {
              setState(() {
                if(isError == true) isError = false;
                listofChatMessages = results;
                chatWidgets = generateChatWidgets(listofChatMessages);
              });
            }
          }

          else {
            if(chatWidgets.length +1 == results.length) {
              if(mounted) {
                setState(() {
                  if(isError == true) isError = false;
                  listofChatMessages.insert(0, results.first);
                  ChatMessage newMessage = addLatestMessage(listofChatMessages, listofChatMessages.first);
                  chatWidgets.insert(0, newMessage);
                });
              }
            }
          }
        }
      },
      onError: (error) {
        setState(() {
          isError = true;
        });
      }
    );
  }

  //SliverChildBuilderDelegate is used to preserve the widgets (specially those containing attachments) on the list when a new message is sent/received
  //rather than using regular itemBuilder which rebuilds the entire list from scratch

  SliverChildBuilderDelegate displaySliverChat() {
    List<Message> trimmedChatMessages = List.generate(min(messageLimit, listofChatMessages.length), (index) => listofChatMessages[index]);

    return SliverChildBuilderDelegate(
      (context, index) {
        int maxIndex = min(messageLimit-1, index);

        Message message = trimmedChatMessages[maxIndex];
        DateTime? postTime = getLocalTime(DateTime.parse(message.timestamp));
        bool isCurrentUser = message.sender_id == widget.currentUserId;
        return Column(
          mainAxisAlignment: (isCurrentUser == true) ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: (isCurrentUser == true) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            getPaginationLoading(trimmedChatMessages, index),
            displayChatSeperator(trimmedChatMessages, postTime, maxIndex),
            chatWidgets[maxIndex]
          ]
        );
      },
      childCount: min(messageLimit, chatWidgets.length),
      findChildIndexCallback: (key) {
        for (int index = 0; index < chatWidgets.length; index++) {
          if (chatWidgets[index].key == key) {
            return index; // Return the index if the key is found.
          }
        }
        return null; // Return null if the key is not found.
      }
    );
  }

  //Display a Pagination Loading Circle if the entire contents of the list is not fully loaded in the pagination

  Widget getPaginationLoading(List<Message> trimmedChatMessages, int index) {
    bool limitTest = messageLimit < chatWidgets.length && trimmedChatMessages.length < chatWidgets.length;
    bool minimumTest = trimmedChatMessages.length >= 20;
    bool indexTest = index == min(trimmedChatMessages.length-1, messageLimit);
    bool state = limitTest && minimumTest && indexTest;
    
    return Visibility(
      visible: state,
      child: Center(
        child: Container(
          margin: const EdgeInsets.only(top: 5),
          child: const CircularProgressIndicator(),
        )
      )
    );
  }

  //Retrieves the entire Chat Message List when the Chat Page is newly opened

  List<ChatMessage> generateChatWidgets(List<Message> messages) {
    return List.generate(messages.length, (index) {
      Message message = messages[index];
      DateTime? postTime = getLocalTime(DateTime.parse(message.timestamp));
      bool isCurrentUser = message.sender_id == widget.currentUserId;

      return chatMessage(
        messages: messages,
        messageItem: message,
        isCurrentUser: isCurrentUser,
        postTime: postTime,
        index: index
      );
    });
  }

  //Adds the Latest Chat Message into the existing list when it is sent/received

  ChatMessage addLatestMessage(List<Message> messages, Message latestMessage) {
    DateTime? postTime = getLocalTime(DateTime.parse(latestMessage.timestamp));
    bool isCurrentUser = latestMessage.sender_id == widget.currentUserId;

    return chatMessage(
      messages: messages,
      messageItem: latestMessage,
      isCurrentUser: isCurrentUser,
      postTime: postTime,
      index: 0
    );
  }

  //Widget Display for Individual Chat Messages

  ChatMessage chatMessage({required List<Message> messages, required Message messageItem, required bool isCurrentUser, required DateTime postTime, required int index}) {
    return ChatMessage(
      key: Key(messageItem.id),
      text: (messageItem.content != null) ? messageItem.content! : '',
      attachment: (messageItem.attachment != null && messageItem.attachment!.isNotEmpty) ? messageItem.attachment! : '',
      messageType: messageItem.message_type,
      account: widget.username,
      roomId: widget.recipient,
      messageId: messageItem.id,
      postTime: postTime.toString(),
      isCurrentUser: isCurrentUser,
      messageEvent: () => messageEvent(context, messageItem)
    );
  }

  //Retrives the local DateTime based on the Message record's timestamp

  DateTime getLocalTime(DateTime time) {
    if(widget.currentTimeZone == "Asia/Singapore") return time;
    
    tz.Location defaultZone = tz.getLocation(widget.currentTimeZone);
    tz.TZDateTime phTime = tz.TZDateTime.from(time, defaultZone);
    final result = DateTime(
      phTime.year, phTime.month, phTime.day,
      phTime.hour, phTime.minute, phTime.second, phTime.millisecond, phTime.microsecond
    ).toLocal();

    return result;
  }
  
  //06-21-2023: GEU - Display dialog for message options.

  void messageEvent(BuildContext context, Message message) {   
    if(context.mounted) {
      FocusScope.of(context).unfocus();
      showModalBottomSheet(
        showDragHandle: true,
        //barrierColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(25.0),
          ),
        ),
        context: context,
        builder: (BuildContext context) {
          return Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.copy),
                title: const Text('Copy Text'),
                onTap: () async {
                  Navigator.pop(context);
                  await Clipboard.setData(ClipboardData(text: message.content!));
                }
              ),
  
              ListTile(
                leading: const Icon(Icons.cancel),
                title: const Text('Cancel'),
                onTap: () => Navigator.pop(context)
              )
            ]
          );
        }
      );
    }
  }
  
  //05-19-2023: GEU - Checking if current message timestamp is the same date as the previous one

  bool checkDate(List<Message> messages, DateTime currdate, int index){     
    DateTime? prevdate = DateTime.parse(messages[index+1].timestamp);
    if(currdate.month == prevdate.month && currdate.day == prevdate.day && currdate.year == prevdate.year) return false;
    return true;
  }
  
  //05-19-2023: GEU - Checking if a date divider should be implemented in the messages

  Widget displayChatSeperator(List<Message> messages, DateTime postTime, int index){
    int length = messages.length-1;
    if(messages.indexOf(messages[index]) == length) {
      return ChatDivider(date: postTime, top: 10);
    }
    
    else if(messages.indexOf(messages[index]) != length && checkDate(messages, postTime, index)) {
      return ChatDivider(date: postTime, top: 40);
    }

    return const SizedBox();
  }
}