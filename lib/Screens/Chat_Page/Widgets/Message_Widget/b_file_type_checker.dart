
import 'package:app_1gochat/Screens/Chat_Page/Widgets/Message_Widget/c_image_display.dart';
import 'package:app_1gochat/Screens/Chat_Page/Widgets/Message_Widget/c_simple_file_display.dart';
import 'package:app_1gochat/Screens/Chat_Page/Widgets/Message_Widget/c_video_display.dart';
import 'package:flutter/material.dart';

class FileTypeChecker extends StatelessWidget {
  const FileTypeChecker({super.key, required this.roomId, required this.messageId, required this.attachment, 
  required this.attachmentType, required this.width});

  final String roomId;
  final String messageId;
  final String attachment;
  final String attachmentType;
  final double width;

  @override
  Widget build(BuildContext context) {
    return displayAttachmentByFileType();
  }

  Widget displayAttachmentByFileType() {
    if(attachmentType == 'IMAGE') {
      return Material(
        color: Colors.black,
        child: AttachmentImageDisplay(
          key: Key("${messageId}_$attachment"),
          roomId: roomId,
          messageId: messageId,
          attachment: attachment,
          height: width * 0.55,
        )
      );
    }

    else if(attachmentType == 'AUDIO') {
      return Material(
        color: Colors.grey[400],
        child: SimpleFileDisplay(
          roomId: roomId,
          messageId: messageId,
          attachment: attachment,
          attachmentType: attachmentType,
          width: width,
        )
      );
    }

    else if(attachmentType == 'VIDEO') {
      return Material(
        color: Colors.black,
        child: AttachmentVideoDisplay(
          width: width * 0.5,
          roomId: roomId,
          messageId: messageId,
          attachment: attachment,
        )
      );
    }

    return Material(
      color: Colors.grey[400],
      child: SimpleFileDisplay(
        roomId: roomId,
        messageId: messageId,
        attachment: attachment,
        attachmentType: attachmentType,
        width: width,
      )
    );
  }
}