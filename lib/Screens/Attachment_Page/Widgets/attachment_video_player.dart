import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:app_1gochat/Screens/Chat_Page/Widgets/Message_Widget/d_exception_file_display.dart';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class AttachmentVideoPlayer extends StatefulWidget {
  const AttachmentVideoPlayer({super.key, required this.roomId, required this.messageId, required this.attachment});

  final String roomId;
  final String messageId;
  final String attachment;

  @override
  State<AttachmentVideoPlayer> createState() => _AttachmentVideoPlayerState();
}

class _AttachmentVideoPlayerState extends State<AttachmentVideoPlayer> {
  VideoPlayerController? videoController;
  ChewieController? _chewieController;
  bool isReplayButton = false;
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
    _chewieController?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (videoController != null && videoController!.value.isInitialized && _chewieController != null)
    ? Stack(
      fit: StackFit.expand,
      children: [

        Container(
          color: Colors.black,
          child: Chewie(
            controller: _chewieController!,
          )
        )
      ]
    )
    
    : InkWell(                                      //Returns an empty display if the video is null or currently loading
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: reloadVideo,                         //"reloadVideo" is null if there is no error in the video loading
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: Colors.black,
          child: EmptyFileDisplay(
            width: double.infinity,
            file: widget.attachment,
            icon: Icons.videocam,
            isError: false,
            color: Colors.black45
          )
        )
      );
  }

  void assignVideoThumbnail() async {
    final videoLink = await Amplify.Storage.getUrl(key: "${widget.roomId}/${widget.messageId}_${widget.attachment}").result;

    videoController = VideoPlayerController.networkUrl(videoLink.url)
    ..initialize().then((_) {
      if(videoController != null) {
        videoController!.addListener(videoListener);

        _chewieController = ChewieController(
          videoPlayerController: videoController!,
          aspectRatio: 5/7,
          autoInitialize: true,
          showOptions: false,
          allowFullScreen: false,
          materialProgressColors: ChewieProgressColors(
            playedColor: const Color.fromRGBO(255, 0, 0, 0.7),
            bufferedColor: const Color.fromRGBO(30, 30, 200, 0.2),
            handleColor: const Color.fromARGB(255, 204, 146, 146),
            backgroundColor: const Color.fromRGBO(200, 200, 200, 0.5),
          ),
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Text(
                errorMessage,
                style: const TextStyle(color: Colors.white),
              ),
            );
          },
        );
        setState(() {
          reloadVideo = null;
        });
      }
    }, onError: (error) {  //Implements a click-based reload functionality when an error is discovered
      setState(() {
        reloadVideo = () {
          if(mounted) {
            assignVideoThumbnail();
          }
        };
      });
    });
  }

  void videoListener() {   //Sets a Replay functionality
    if(videoController != null) {
      if (videoController!.value.isCompleted) {
        setState(() => isReplayButton = true);
      }
      else {
        setState(() => isReplayButton = false);
      }
    }
  }
}