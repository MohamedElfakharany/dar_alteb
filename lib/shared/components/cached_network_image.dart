// ignore_for_file: file_names
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:dar_elteb/shared/constants/colors.dart';

class CachedNetworkImageCircular extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double minRadius;
  final double maxRadius;

  const CachedNetworkImageCircular({
    Key? key,
    required this.imageUrl,
    this.height = 50,
    this.minRadius = 12,
    this.maxRadius = 28,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      imageBuilder: (context, imageProvider) => CircleAvatar(
        minRadius: minRadius,
        maxRadius: maxRadius,
        backgroundImage: imageProvider,
        backgroundColor: whiteColor,
      ),
      placeholder: (context, url) => CircleAvatar(
        minRadius: minRadius,
        maxRadius: maxRadius,
        backgroundColor: whiteColor,
        backgroundImage: const AssetImage('assets/loading.gif'),
      ),
      errorWidget: (context, url, error) => Container(
        width: media.width * 0.3,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: const BoxDecoration(
            shape: BoxShape.circle, color: Color(0xffDEDEDE)),
        child: Image.asset(
          'assets/images/placeholder.png',
        ),
      ),
    );
  }
}

class CachedNetworkImageNormal extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final double minRadius;
  final double maxRadius;
  final double imageRadius;
  final BoxFit imageBoxFit;

  const CachedNetworkImageNormal({
    Key? key,
    required this.imageUrl,
    this.imageBoxFit = BoxFit.cover,
    this.imageRadius = 15,
    this.height = 50,
    this.width = double.infinity,
    this.minRadius = 12,
    this.maxRadius = 28,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;
    return CachedNetworkImage(
      imageUrl: imageUrl,
      height: height,
      width: width,
      imageBuilder: (context, imageProvider) => Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(imageRadius),
          image: DecorationImage(
            image: imageProvider,
            fit: imageBoxFit,
          ),
        ),
      ),
      placeholder: (context, url) => Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/loading.gif'))),
      ),
      errorWidget: (context, url, error) => Container(
        width: media.width * 0.3,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        decoration: const BoxDecoration(
            shape: BoxShape.circle, color: Color(0xffDEDEDE)),
        child: Image.asset(
          'assets/images/placeholder.png',
        ),
      ),
    );
  }
}
