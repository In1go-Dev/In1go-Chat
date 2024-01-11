import 'package:app_1gochat/Models/ModelProvider.dart';
import 'package:app_1gochat/Providers/homepagesettings.dart';
import 'package:app_1gochat/Providers/message_list_provider.dart';
import 'package:app_1gochat/Screens/Chat_Page/Widgets/a_chat_page_layout.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key, required this.recipient, required this.chatname, required this.currentUserId, required this.username, required this.sendMessage});

  final Room recipient;
  final String chatname;
  final String currentUserId;
  final String username;
  final Function({required String content, required String sender, required String senderName, required String receiver, required FilePickerResult? pickedFiles}) sendMessage;

  @override
  ConsumerState<ChatPage> createState() => ChatPageState();
}

class ChatPageState extends ConsumerState<ChatPage> {
  final ScrollController _scrollController = ScrollController();
  MessageListViewModel messageQuery = MessageListViewModel();
  final TextEditingController textController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return ChatPageLayout(
      recipient: widget.recipient,
      chatname: widget.chatname,
      currentUserId: widget.currentUserId,
      username: widget.username,
      textController: textController,
      scrollController: _scrollController,
      messageSubmit: messageSubmit
    );
  }

  @override
  void dispose() {
    textController.dispose();
    _scrollController.dispose();
    DefaultCacheManager().emptyCache();
    super.dispose();
  }

  //04-18-2023: GEU - Sending the Message

  void messageSubmit(String text) {    
    //scrollToBottom();
    final attachments = ref.read(attachmentFile);
    text = text.trim();

    if(text.isNotEmpty || (attachments != null && attachments.files.isNotEmpty)) {

      widget.sendMessage(
        content: text,
        sender: widget.currentUserId,
        senderName: widget.username,
        receiver: widget.recipient.id,
        pickedFiles: attachments
      );

      if(attachments != null && attachments.files.isNotEmpty) ref.read(attachmentFile.notifier).state = null;

      textController.clear();
    }
  }

  //Trim Multi-Line is not in use, preserved in case multi-line text field may become necessary to implement so this can be used for
  //message sending text validation

  String trimMultiLine(String input) {
    List<String> splitInput = input.split('\n');
    String completeInput = '';
    for(int line = 0; line < splitInput.length; line++) {
      if(splitInput[line].isEmpty) splitInput.removeAt(line);
    }

    for(int line = 0; line < splitInput.length; line++) {
      completeInput = '$completeInput${splitInput[line]}';
    }
    
    return completeInput;
  }
}