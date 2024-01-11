import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mime/mime.dart';


//Displays a Toast Message

void displayToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    fontSize: 14.0
  );
}

//Checks if the file size is higher than 20MB

bool checkMaxFileSize(PlatformFile? attachment) {
  if(attachment != null && attachment.path != null && attachment.path!.isNotEmpty) {
    final checkFile = File(attachment.path!);
    int sizeInBytes = checkFile.lengthSync();
    double sizeInMb = sizeInBytes.ceilToDouble() / (1000  * 1000);
    double roundedValue = double.parse(sizeInMb.toStringAsFixed(2));
    if (roundedValue > 20){
      return false;
    }
    
    else{
      return true;
    }
  }
  return false;
}

//Check File Type of Attachments

String? checkFileType(PlatformFile? file) {
  if(file != null && file.path != null && file.path!.isNotEmpty) {
    final mimeType = lookupMimeType(file.path!);

    if(mimeType != null && mimeType.isNotEmpty) {
     if(mimeType.startsWith('image/')) return 'IMAGE';
     if(mimeType.startsWith('audio/')) return 'AUDIO';
     if(mimeType.startsWith('video/')) return 'VIDEO';
     return 'FILE';
    }

    return null;
  }
  return null;
}

//Download Selected Attachment to Android Download Folder

void downloadAttachment(BuildContext context, String fileKey, String fileName) async {
  final downloadDirectory = Directory("/storage/emulated/0/Download/");
  try {
    displayToast("Downloading...");
    final result = await Amplify.Storage.downloadFile(
      key: fileKey,
      localFile: AWSFile.fromPath(
        "${downloadDirectory.path}/$fileName",
        name: fileName
      ),
      onProgress: (progress) {
        safePrint('Fraction completed: ${progress.fractionCompleted}');
      }
    ).result;

    safePrint('Amplify S3 File Downloaded: ${result.downloadedItem}');
    displayToast("File successfully downloaded");
  } on StorageException {
    displayToast("Failed to download file");
  } on UnsupportedError {
    displayToast("Can/'t find download directory");
  }
}