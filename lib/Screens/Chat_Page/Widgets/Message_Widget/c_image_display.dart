import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app_1gochat/Functions/chat_page_functions.dart';
import 'package:app_1gochat/Screens/Attachment_Page/attachment_viewer_page.dart';
import 'package:app_1gochat/Screens/Chat_Page/Widgets/Message_Widget/d_exception_file_display.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class AttachmentImageDisplay extends StatefulWidget {
  const AttachmentImageDisplay({super.key, required this.roomId, required this.messageId, required this.attachment, required this.height});

  final String roomId;
  final String messageId;
  final String attachment;
  final double height;

  @override
  State<AttachmentImageDisplay> createState() => _AttachmentImageDisplayState();
}

class _AttachmentImageDisplayState extends State<AttachmentImageDisplay> {
  final DefaultCacheManager cacheManager = DefaultCacheManager();
  Widget? imageDisplay;

  @override
  Widget build(BuildContext context) {
    if(imageDisplay != null) {
      return imageDisplay!;
    }

    else {
      return EmptyFileDisplay(
        width: double.infinity,
        file: widget.attachment,
        icon: Icons.error,
        isError: true,
      );
    }
  }

  Widget getImageDisplay() {
    return StreamBuilder(
      key: Key("${widget.messageId}_${widget.attachment}"),
      stream: getImageUri(),
      builder:(context, result) {
        if(result.connectionState == ConnectionState.done) {
          if(result.hasData) {
            return CachedNetworkImage(
              cacheKey: "${widget.messageId}_${widget.attachment}",
              imageUrl: result.data.toString(),
              fit: BoxFit.contain,
              useOldImageOnUrlChange: true,
              imageBuilder: (context, imageProvider) {
                return InkWell(
                  highlightColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  onTap: () => openViewerPage(context),
                  onLongPress: () => messageEvent(context),
                  child: Image(
                    image: imageProvider,
                    fit: BoxFit.contain,
                  )
                );
              },
              cacheManager: CacheManager(
                Config(
                  "${widget.messageId}_${widget.attachment}",
                  stalePeriod: const Duration(days: 7)
                )
              ),
              placeholder: (context, url) => EmptyFileDisplay(
                width: double.infinity,
                file: widget.attachment,
                icon: Icons.image,
                isError: false,
              ),
              errorWidget: (context, url, error) {
                log('CACHE NETWORK IMAGE ERROR: $error');
                return EmptyFileDisplay(
                  width: double.infinity,
                  file: widget.attachment,
                  icon: Icons.error,
                  isError: true,
                  clickFunction: () {
                    if(mounted) {
                      setState(() {
                        imageDisplay = getImageDisplay();
                      });
                    }
                  }
                );
              }
            );
          }

          else {
            return EmptyFileDisplay(
              width: double.infinity,
              file: widget.attachment,
              icon: Icons.error,
              isError: true,
              clickFunction: () {
                if(mounted) {
                  setState(() {
                    imageDisplay = getImageDisplay();
                  });
                }
              }
            );
          }

        }

        else if(result.hasError) {
          return EmptyFileDisplay(
            width: double.infinity,
            file: widget.attachment,
            icon: Icons.error,
            isError: true,
            clickFunction: () {
              if(mounted) {
                setState(() {
                  imageDisplay = getImageDisplay();
                });
              }
            }
          );
        }

        else {
          return EmptyFileDisplay(
            width: double.infinity,
            file: widget.attachment,
            icon: Icons.image,
            isError: false,
          );
        }
      }
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      imageDisplay = getImageDisplay();
    });
  }

  //Stream Functionality for retrieving the Url of the attachment from the Amplify S3 for image display

  Stream<Uri> getImageUri() async* {
    //Amplify Functionality for loading Amplify S3 contents as a Url
    final imageUrl = await Amplify.Storage.getUrl(
      key: "${widget.roomId}/${widget.messageId}_${widget.attachment}"
    ).result;
    yield imageUrl.url;
  }

  //Open a Viewer Page to load the attachment into an interactive image viewer

  void openViewerPage(BuildContext context) {
    try {
      if(context.mounted) {
        FocusScope.of(context).unfocus();
        Navigator.push(context, MaterialPageRoute<void>(
          builder: (BuildContext context) {
            return AttachmentViewerPage(
              roomId: widget.roomId,
              messageId: widget.messageId,
              attachmentName: widget.attachment,
              attachmentType: "IMAGE",
            );
          }
        ));
      }
    } on Exception catch(e) {
      safePrint('Error in navigation - $e');
    }
  }
  
  //06-21-2023: GEU - Display dialog for message options.

  void messageEvent(BuildContext context) {   
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
                  child: Text(widget.attachment, style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),

              ListTile(
                leading: const Icon(Icons.file_open),
                title: const Text('Open'),
                onTap: () {
                  Navigator.pop(context);
                  openViewerPage(context);
                }
              ),

              ListTile(
                leading: const Icon(Icons.file_download),
                title: const Text('Download File'),
                onTap: () {
                  Navigator.pop(context);
                  downloadAttachment(
                    context,
                    "${widget.roomId}/${widget.messageId}_${widget.attachment}",
                    widget.attachment
                  );
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