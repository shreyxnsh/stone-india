
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:photo_view/photo_view.dart';
class DetailPhotoViewScreen extends StatefulWidget {
  final String tag;
  final String url;

  const DetailPhotoViewScreen({super.key, required this.tag, required this.url});

  @override
  _DetailPhotoViewScreenState createState() => _DetailPhotoViewScreenState();
}

class _DetailPhotoViewScreenState extends State<DetailPhotoViewScreen> {
  @override
  initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: widget.tag,
            child: Container(
                child: widget.url.validate().startsWith('http') || widget.url.validate().startsWith('https')
              ? CachedNetworkImage(
                  imageUrl: widget.url,
                  imageBuilder: (context, imageProvider) => PhotoView(
                    imageProvider: imageProvider,
                    minScale: PhotoViewComputedScale.contained * 0.8,
                    maxScale: PhotoViewComputedScale.covered * 1.2,
                  ),
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
                )
                    : Container()

            ),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}