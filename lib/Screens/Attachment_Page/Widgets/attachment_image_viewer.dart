import 'dart:developer';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app_1gochat/Screens/Chat_Page/Widgets/Message_Widget/d_exception_file_display.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class AttachmentImageViewer extends StatefulWidget {
  const AttachmentImageViewer({super.key, required this.roomId, required this.messageId, required this.attachment});

  final String roomId;
  final String messageId;
  final String attachment;

  @override
  State<AttachmentImageViewer> createState() => _AttachmentImageViewerState();
}

class _AttachmentImageViewerState extends State<AttachmentImageViewer> {
  Widget? imageDisplay;

  @override
  Widget build(BuildContext context) {
    if(imageDisplay != null) {   
      return imageDisplay!;
    }

    else {
      return EmptyFileDisplay(    //Display while the image is blank or currently loading
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
              useOldImageOnUrlChange: true,
              imageBuilder: (context, imageProvider) {
                return InteractiveViewer(     //Allows user interaction with the image like zoom in/zoom out
                  panEnabled: true,
                  child: Container(
                    color: Colors.black,
                    child: Image(
                      fit: BoxFit.contain,
                      image: imageProvider
                    )
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
                color: Colors.black45,
              ),

              errorWidget: (context, url, error) {
                log('CACHE NETWORK IMAGE ERROR: $error');
                return EmptyFileDisplay(       //Implements an Error Display with a click-based reload functionality
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

        else if(result.hasError) {          //Implements an Error Display with a click-based reload functionality
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

  //Amplify Operation for retrieving Image URL in Amplify S3

  Stream<Uri> getImageUri() async* {
    final imageUrl = await Amplify.Storage.getUrl(
      key: "${widget.roomId}/${widget.messageId}_${widget.attachment}"
    ).result;
    yield imageUrl.url;
  }
}