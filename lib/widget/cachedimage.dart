
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CachedImageWidget extends StatefulWidget {
  final String url;
  final double height;
  final double? width;
  final BoxFit? fit;
  final Color? color;
  final String? placeHolderImage;
  final AlignmentGeometry? alignment;
  final bool usePlaceholderIfUrlEmpty;
  final double? radius;


  const CachedImageWidget({super.key, 
    required this.url,
    required this.height,
    this.width,
    this.fit,
    this.color,
    this.placeHolderImage,
    this.alignment,
    this.radius,
    this.usePlaceholderIfUrlEmpty = true,
  });

  @override
  _CachedImageWidgetState createState() => _CachedImageWidgetState();
}

class _CachedImageWidgetState extends State<CachedImageWidget> {
  bool circle = false;

  @override
  Widget build(BuildContext context) {
    if (widget.url.validate().isEmpty) {
      return Container(
        height: widget.height,
        width: widget.width ?? widget.height,
        color: widget.color ?? grey.withOpacity(0.1),
        alignment: widget.alignment,
        padding: const EdgeInsets.all(10),
        child: Image.asset("assets/icons/user.png", color: Colors.black),
      ).cornerRadiusWithClipRRect(widget.radius ?? (circle ? (widget.height / 2) : 0));
    } else if (widget.url.validate().startsWith('http') || widget.url.validate().startsWith('https')) {
      return CachedNetworkImage(
        key: ValueKey(widget.url),
          placeholder: (_, __) {
            return PlaceHolderWidget(
              height: widget.height,
              width: widget.width,
              alignment: widget.alignment ?? Alignment.center,
            ).cornerRadiusWithClipRRect(widget.radius ?? (circle ? (widget.height / 2) : 0));
          },
          imageUrl: widget.url,
          height: widget.height,
          width: widget.width ?? widget.height,
          fit: widget.fit,
          color: widget.color,
          alignment: widget.alignment as Alignment? ?? Alignment.center,
          errorWidget: (_, s, d) {
            return PlaceHolderWidget(
              height: widget.height,
              width: widget.width,
              alignment: widget.alignment ?? Alignment.center,
            ).cornerRadiusWithClipRRect(widget.radius ?? (circle ? (widget.height / 2) : 0));
          },
        ).cornerRadiusWithClipRRect(widget.radius ?? (circle ? (widget.height / 2) : 0));
    } else {
      return  Image.file(
          File(widget.url),
        height: widget.height,
        width: widget.width ?? widget.height,
        fit: widget.fit,
        color: widget.color,
        alignment: widget.alignment ?? Alignment.center,
        errorBuilder: (_, s, d) {
          return PlaceHolderWidget(
            height: widget.height,
            width: widget.width,
            alignment:widget. alignment ?? Alignment.center,
          ).cornerRadiusWithClipRRect(widget.radius ?? (circle ? (widget.height / 2) : 0));
        },
      ).cornerRadiusWithClipRRect(widget.radius ?? (circle ? (widget.height / 2) : 0));
    }
  }
}
