import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app_1gochat/Functions/chat_page_functions.dart';
import 'package:app_1gochat/Providers/homepagesettings.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AttachmentDisplay extends ConsumerWidget {
  const AttachmentDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final attachment = ref.watch(attachmentFile);
    return AnimatedSwitcher(
      //visible: (attachment != null && attachment.files.isNotEmpty) ? true : false,
      duration: const Duration(milliseconds: 300),
      child: (attachment != null && attachment.files.isNotEmpty) ? Container(
        key: const Key('Normal Display'),
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: Colors.black45, width: 1),
            bottom: BorderSide(color: Colors.black45, width: 1)
          )
        ),
        child: ListTile(
          dense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
          leading: (attachment.files.isNotEmpty) ? Icon(fileTypeforIcon(attachment.files.first)) : null,
          title: Text(
            (attachment.files.isNotEmpty) ? attachment.files.first.name : '',
            style: const TextStyle(fontSize: 14),
          ),
          subtitle: (attachment.files.isNotEmpty) ? checkMaxFileSize(attachment.files.first) : null,
          trailing: Material(
            color: Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            child: IconButton(
              onPressed: () {
                try {
                  ref.watch(attachmentFile.notifier).state = null;
                } on Exception catch(error) {
                  safePrint(error);
                }
              },
              tooltip: 'Cancel',
              icon: const Icon(Icons.close)
            )
          )
        )
      ) : const SizedBox.shrink(
        key: Key('Hidden')
      )
    );
  }

  //Icon Display for Attachment File Type

  IconData fileTypeforIcon(PlatformFile? file) {
    final result = checkFileType(file);

    switch (result) {
      case 'IMAGE':
        return Icons.image;
      case 'AUDIO':
        return Icons.audio_file;
      case 'VIDEO':
        return Icons.videocam;
      default:
        return Icons.insert_drive_file;
    }
  }

  //Widget Display for Attachment File Size

  Widget? checkMaxFileSize(PlatformFile? attachment) {
    if(attachment != null && attachment.path != null && attachment.path!.isNotEmpty) {
      final checkFile = File(attachment.path!);
      int sizeInBytes = checkFile.lengthSync();
      double sizeInKb = sizeInBytes.ceilToDouble() / 1000;
      double sizeInMb = sizeInBytes.ceilToDouble() / (1000  * 1000);
      double roundedKBValue = double.parse(sizeInKb.toStringAsFixed(2));
      double roundedMBValue = double.parse(sizeInMb.toStringAsFixed(2));

      if(roundedMBValue >= 1) {
        return Text("${roundedMBValue.toString()} MB", overflow: TextOverflow.ellipsis);
      }

      else {
        return Text("${roundedKBValue.toString()} KB", overflow: TextOverflow.ellipsis);
      }

    }
    return null;
  }
}