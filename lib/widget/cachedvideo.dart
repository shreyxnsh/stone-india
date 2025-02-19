import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:video_player/video_player.dart';

class CachedVideoWidget extends StatefulWidget {
  final String url;
  final double height;
  final double? width;
  final BoxFit? fit;
  final Color? color;
  final String? placeHolderImage;
  final AlignmentGeometry? alignment;
  final bool usePlaceholderIfUrlEmpty;
  final double? radius;
  String? thumbnail;

  CachedVideoWidget({super.key, 
    required this.url,
    required this.height,
    this.width,
    this.fit,
    this.color,
    this.placeHolderImage,
    this.alignment,
    this.radius,
    this.usePlaceholderIfUrlEmpty = true,
    this.thumbnail,
  });

  @override
  _CachedVideoWidgetState createState() => _CachedVideoWidgetState();
}

class _CachedVideoWidgetState extends State<CachedVideoWidget> {
  late ChewieController _chewieController;
  // late VideoPlayerController _videoPlayerController;

  VideoPlayerController get videoPlayerController {
    return VideoPlayerController.network(widget.url.validate());
  }

  VideoPlayerController get videoPlayerFileController {
    return VideoPlayerController.file(File(widget.url.validate()));
  }

  ChewieController get chewieController {
    return ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: false,
      autoInitialize: true,
      showControls: true,
      allowFullScreen: true,
      errorBuilder: (context, errorMessage) {
        return PlaceHolderWidget(
          height: widget.height,
          width: widget.width,
          alignment: widget.alignment ?? Alignment.center,
        ).cornerRadiusWithClipRRect(widget.radius ?? (circle ? (widget.height / 2) : 0));
      },
      // errorBuilder: (context, errorMessage) {
      //   return Padding(
      //     padding: const EdgeInsets.all(10.0),
      //     child: Center(
      //       child: Text(
      //         errorMessage,
      //         style: TextStyle(color: Colors.white),
      //       ),
      //     ),
      //   );
      // },
    );
  }

  ChewieController get chewieFileController {
    return ChewieController(
      videoPlayerController: videoPlayerFileController,
      aspectRatio: 3 / 2,
      autoPlay: false,
      autoInitialize: true,
      allowFullScreen: false,
      errorBuilder: (context, errorMessage) {
        return PlaceHolderWidget(
          height: widget.height,
          width: widget.width,
          alignment: widget.alignment ?? Alignment.center,
        ).cornerRadiusWithClipRRect(widget.radius ?? (circle ? (widget.height / 2) : 0));
      },
      // errorBuilder: (context, errorMessage) {
      //   return Padding(
      //     padding: const EdgeInsets.all(10.0),
      //     child: Center(
      //       child: Text(
      //         errorMessage,
      //         style: TextStyle(color: Colors.white),
      //       ),
      //     ),
      //   );
      // },
    );
  }

  bool circle = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  init() async {
    if(widget.url.contains('http') || widget.url.contains('https')){
      // _videoPlayerController = videoPlayerController;
      _chewieController = chewieController;
    }else{
      // _videoPlayerController = videoPlayerFileController;
      _chewieController = chewieFileController;
    }

    // widget.thumbnail = await VideoThumbnail.thumbnailFile(
    //   video: widget.url.validate(),
    //   thumbnailPath: (await getTemporaryDirectory()).path,
    //   imageFormat: ImageFormat.JPEG,
    //   maxHeight: 80, // specify the height of the thumbnail, let the width auto-scaled to keep the source aspect ratio
    //   quality: 80,
    // );
  }

  @override
  void dispose() {
    videoPlayerController.pause();
    _chewieController.pause();
    videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if (widget.url.validate().isEmpty) {
      return Container(
        height: widget.height,
        width: widget.width ?? widget.height,
        color: widget.color ?? grey.withOpacity(0.1),
        alignment: widget.alignment,
        padding: const EdgeInsets.all(10),
        child: Image.asset("assets/icons/user.png", color: Colors.white),
      ).cornerRadiusWithClipRRect(widget.radius ?? (circle ? (widget.height / 2) : 0));
    } else if (widget.url.validate().startsWith('http') || widget.url.validate().startsWith('https')) {
      return Chewie(
        key: ValueKey(widget.url),
        controller: _chewieController,
        // ChewieController(
        //   videoPlayerController: _videoPlayerController,
        //   aspectRatio: 3 / 2,
        //   autoInitialize: true,
        //   looping: false,
        //   autoPlay: false,
        //   showControls: true,
        //   errorBuilder: (context, errorMessage) {
        //     return PlaceHolderWidget(
        //       height: widget.height,
        //       width: widget.width,
        //       alignment: widget.alignment ?? Alignment.center,
        //     ).cornerRadiusWithClipRRect(widget.radius ?? (circle ? (widget.height / 2) : 0));
        //   },
        // ),
      ).cornerRadiusWithClipRRect(widget.radius ?? (circle ? (widget.height / 2) : 0)).onTap((){
        print(widget.url);
      });
    } else {
      return Chewie(
        controller: _chewieController,
        // ChewieController(
        // videoPlayerController: _videoPlayerController,
        // aspectRatio: 3 / 2,
        // autoInitialize: true,
        // looping: false,
        // autoPlay: false,
        // showControls: true,
        // errorBuilder: (context, errorMessage) {
        //   return PlaceHolderWidget(
        //     height: widget.height,
        //     width: widget.width,
        //     alignment: widget.alignment ?? Alignment.center,
        //   ).cornerRadiusWithClipRRect(widget.radius ?? (circle ? (widget.height / 2) : 0));
        // },
        // ),
      ).cornerRadiusWithClipRRect(widget.radius ?? (circle ? (widget.height / 2) : 0)).onTap((){
        print(widget.url);
      });
    }
  }
}

