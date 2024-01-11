import 'package:app_1gochat/Functions/chat_page_functions.dart';
import 'package:flutter/material.dart';

class SimpleFileDisplay extends StatelessWidget {
  const SimpleFileDisplay({super.key, required this.roomId, required this.messageId, required this.attachment, required this.attachmentType, required this.width});

  final String roomId;
  final String messageId;
  final String attachment;
  final String attachmentType;
  final double width;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: () => messageEvent(context),
      splashColor: Colors.grey,
      child: Container(
        //constraints: BoxConstraints(maxWidth: width * 0.65, minWidth: 100),
        padding: const EdgeInsets.fromLTRB(10, 10, 18, 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Icon((attachmentType == "AUDIO") ? Icons.audio_file : Icons.insert_drive_file),
              )
            ),
  
            Flexible(
              child: Text(attachment, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),  overflow: TextOverflow.ellipsis, maxLines: 1)
            )
          ]
        )
      ),
    );
  }

  void messageEvent(BuildContext context) {   //06-21-2023: GEU - Display dialog for message options.
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
              Container(
                margin: const EdgeInsets.only(top: 10, bottom: 15),
                child: Center(
                  child: Text(attachment, style: const TextStyle(fontWeight: FontWeight.bold)),
                )
              ),
              
              ListTile(
                leading: const Icon(Icons.file_download),
                title: const Text('Download File'),
                onTap: () {
                  Navigator.pop(context);
                  downloadAttachment(context, "$roomId/${messageId}_$attachment", attachment);
                  //downloadAttachment(context);
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
}