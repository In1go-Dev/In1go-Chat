import 'package:flutter/material.dart';

class ChatPageAppBar extends AppBar {

  final String user;
  final VoidCallback voicecall;
  final VoidCallback videocall;

  ChatPageAppBar({super.key, required this.user, required this.voicecall, required this.videocall}):super(
    backgroundColor: Colors.transparent,
    foregroundColor: Colors.white,
    elevation: 0,
    leadingWidth: 60,
    toolbarHeight: 60,
    title: ListTile(
      textColor: Colors.white,
      //leading: CircleAvatar(
      //  backgroundColor: Colors.black,
      //  child: (user.isNotEmpty) ? CircleAvatar(
      //    radius: 17,
      //    foregroundColor: Colors.black,
      //    backgroundColor: Colors.white,
      //    child: AutoSizeText((user.isNotEmpty) ? user[0] : '?', overflow: TextOverflow.ellipsis)
      //  ) : null
      //),
      contentPadding: const EdgeInsets.all(0),
      title: Text(user, style: const TextStyle(fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
      //subtitle: const Text('Online')
    ),
    //actions: [
    //  IconButton(
    //    icon: const Icon(Icons.call),
    //    tooltip: 'Voice Call',
    //    onPressed:  () {} //voicecall
    //  ),
    //  IconButton(
    //    icon: const Icon(Icons.video_call),
    //    tooltip: 'Video Call',
    //    onPressed: () {} //videocall
    //  ),
    //  IconButton(
    //    icon: const Icon(Icons.info_outline),
    //    tooltip: 'Account Information',
    //    onPressed: accountInfo
    //  )
    //]
  );
}