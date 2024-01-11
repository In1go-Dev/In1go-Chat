import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app_1gochat/Functions/chat_page_functions.dart';
import 'package:app_1gochat/Screens/Attachment_Page/attachment_viewer_page.dart';
import 'package:app_1gochat/Screens/Chat_Page/Widgets/Message_Widget/d_exception_file_display.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class AttachmentVideoDisplay extends StatefulWidget {
  const AttachmentVideoDisplay({super.key, required this.roomId, required this.messageId, required this.attachment, required this.width});

  final String roomId;
  final String messageId;
  final String attachment;
  final double width;

  @override
  State<AttachmentVideoDisplay> createState() => _AttachmentVideoDisplayState();
}

class _AttachmentVideoDisplayState extends State<AttachmentVideoDisplay> {
  VideoPlayerController? videoController;
  VoidCallback? reloadVideo;

  @override
  void initState() {
    super.initState();
    assignVideoThumbnail();
  }

  @override
  void dispose() {
    super.dispose();
    videoController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (videoController != null && videoController!.value.isInitialized)
    ? AspectRatio(
        aspectRatio: videoController!.value.aspectRatio,
        child: InkWell(
          onTap: () => openViewerPage(context),
          onLongPress: () => messageEvent(context),
          child: Stack(
            children: [

              VideoPlayer(videoController!),

              Align(
                alignment: Alignment.center,
                child: Icon(
                  Icons.play_circle_outline,
                  size: 55,
                  color: Colors.grey[300],
                )
              )
            ]
          )
        )
      )
    
    : EmptyFileDisplay(
        width: double.infinity,
        file: widget.attachment,
        icon: Icons.videocam,
        isError: false,
        clickFunction: reloadVideo,
      );
  }

  //Initialization of the Video Url's thumbnail as an image preview

  void assignVideoThumbnail() async {
    //Amplify Functionality for loading Amplify S3 contents as a Url
    final videoLink = await Amplify.Storage.getUrl(key: "${widget.roomId}/${widget.messageId}_${widget.attachment}").result;

    videoController = VideoPlayerController.networkUrl(videoLink.url)
    ..initialize().then((_) {
      if(videoController != null) {
        videoController!.setVolume(1.0);
        setState(() {
          reloadVideo = null;
        });
      }
    }, onError: (error) {
      setState(() {
        reloadVideo = () {
          if(mounted) {
            assignVideoThumbnail();
          }
        };
      });
    });
  }

  //Open a Viewer Page to load the attachment into a video player

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
              attachmentType: "VIDEO",
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
                  downloadAttachment(context, "${widget.roomId}/${widget.messageId}_${widget.attachment}", widget.attachment);
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