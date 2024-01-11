import 'package:app_1gochat/Functions/chat_page_functions.dart';
import 'package:app_1gochat/Providers/homepagesettings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:permission_handler/permission_handler.dart';

class ChatTextField extends ConsumerWidget{
  const ChatTextField({super.key, required this.textController, required this.messageSubmit});

  final TextEditingController textController;
  final void Function(String) messageSubmit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ScrollController textscroll = ScrollController();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Flexible(
            child: TextFormField(
              controller: textController,
              textInputAction: TextInputAction.go,
              scrollController: textscroll,
              //onTapOutside: (event) => FocusScope.of(context).unfocus(),
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey[200],
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(50.0)
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(50.0)
                ),
                hintText: "Type a message...",
                contentPadding: const EdgeInsets.all(15),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    MaterialButton(
                      hoverElevation: 0,
                      highlightElevation: 0,
                      height: 0,
                      minWidth: 0,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10),
                      onPressed: () => attachmentOptions(context, ref),
                      onLongPress: () {},
                      child: const Icon(Icons.attach_file)
                    ),

                    MaterialButton(
                      hoverElevation: 0,
                      highlightElevation: 0,
                      height: 0,
                      minWidth: 0,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(10),
                      onPressed: () => messageSubmit(textController.text),
                      child: const Icon(Icons.send)
                    )
                  ]
                )
              )
            )
          )
        ]
      )
    );
  }

  //Opens Bottom Sheet to open Attachment File Picker options

  void attachmentOptions(BuildContext context, WidgetRef ref) {
    FocusScope.of(context).unfocus();
    showModalBottomSheet(
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25.0),
        )
      ),
      //barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: <Widget>[

            ListTile(
              leading: const Icon(Icons.image),
              title: const Text('Image'),
              onTap: () async {
                Navigator.pop(context);
                final result = await showFilePicker(context, FileType.image, ref);

                //Check File Picker results
                if(result != null && result.isNotEmpty) {
                  if(result == "Device requires storage permission") {
                    final state = await openAppSettings();
                    if(state == false) displayToast("Device requires permission");
                  }

                  else {
                    displayToast(result);
                  }
                }
              }
            ),

            ListTile(
              leading: const Icon(Icons.audio_file),
              title: const Text('Audio'),
              onTap: () async {
                Navigator.pop(context);
                final result = await showFilePicker(context, FileType.audio, ref);
                if(result != null && result.isNotEmpty) {
                  if(result == "Device requires storage permission") {
                    final state = await openAppSettings();
                    if(state == false) displayToast("Device requires permission");
                  }

                  else {
                    displayToast(result);
                  }
                }
              }
            ),

            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('Video'),
              onTap: () async {
                Navigator.pop(context);
                final result = await showFilePicker(context, FileType.video, ref);
                if(result != null && result.isNotEmpty) {
                  if(result == "Device requires storage permission") {
                    final state = await openAppSettings();
                    if(state == false) displayToast("Device requires permission");
                  }

                  else {
                    displayToast(result);
                  }
                }
              }
            ),
            
            ListTile(
              leading: const Icon(Icons.insert_drive_file),
              title: const Text('File'),
              onTap: () async {
                Navigator.pop(context);
                final result = await showFilePicker(context, FileType.any, ref);
                if(result != null && result.isNotEmpty) {
                  if(result == "Device requires storage permission") {
                    final state = await openAppSettings();
                    if(state == false) displayToast("Device requires permission");
                  }

                  else {
                    displayToast(result);
                  }
                }
              }
            ),
            
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('Cancel'),
              onTap: () {
                Navigator.pop(context);
              }
            )
          ]
        );
      }
    );
  }

  //File Picker Functionality - Also checks if the attachment is higher or lower than 20MB for efficient attachment sending
  
  Future<String?> showFilePicker(BuildContext context, FileType fileType, WidgetRef ref) async {
    try {
      final attachment = await FilePicker.platform.pickFiles(
        type: fileType,
        withReadStream: true,
      );
  
      if(attachment != null && attachment.files.isNotEmpty) {
        if(checkMaxFileSize(attachment.files.first)) {
          ref.read(attachmentFile.notifier).state = attachment;
          return null;
        }
  
        else {
          return "File is larger than 20MB";
        }
      }
  
      else {
        return null;

      }

    } on PlatformException catch(e) {
      if(e.message != null && e.message!.isNotEmpty && e.message == "User did not allow reading external storage") {
        return "Device requires storage permission";
      }
      return null;
    }
  }
}