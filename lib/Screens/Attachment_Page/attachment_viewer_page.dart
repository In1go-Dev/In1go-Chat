import 'package:app_1gochat/Screens/Attachment_Page/Widgets/attachment_image_viewer.dart';
import 'package:app_1gochat/Screens/Attachment_Page/Widgets/attachment_video_player.dart';
import 'package:app_1gochat/Screens/Chat_Page/Widgets/Message_Widget/d_exception_file_display.dart';
import 'package:flutter/material.dart';

class AttachmentViewerPage extends StatelessWidget {
  const AttachmentViewerPage({super.key, required this.roomId, required this.messageId, required this.attachmentName, 
  required this.attachmentType});

  final String roomId;
  final String messageId;
  final String attachmentName;
  final String attachmentType;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.grey[100],
        title: Text(attachmentName, style: const TextStyle(fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis),
      ),
      body: Container(
        color: Colors.black12,
        width: double.infinity,
        height: double.infinity,
        child: attachmentViewerWidget(),
      )
    );
  }

  Widget attachmentViewerWidget() {
    switch (attachmentType) {
      case "IMAGE":                            //If the attachment is an image
        return AttachmentImageViewer(
          roomId: roomId,
          messageId: messageId,
          attachment: attachmentName,
        );
      case "VIDEO":                            //If the attachment is a video
        return AttachmentVideoPlayer(
          roomId: roomId,
          messageId: messageId,
          attachment: attachmentName,
        );
      default:
        return EmptyFileDisplay(              //Attachment type for other files (music, documents, regular files, etc.)
          width: double.infinity,
          file: attachmentName,
          icon: Icons.insert_drive_file,
          isError: false,
        );
    }
  }
}