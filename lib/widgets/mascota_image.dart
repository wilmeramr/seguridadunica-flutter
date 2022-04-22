import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/controllers.dart';

class MascotaImage extends StatelessWidget {
  final String? url;

  const MascotaImage({Key? key, required this.url}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Container(
        decoration: _buildDecoration(),
        width: double.infinity,
        height: 450,
        child: Opacity(
          opacity: 0.8,
          child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45), topRight: Radius.circular(45)),
              child: getImage(url)),
        ),
      ),
    );
  }

  BoxDecoration _buildDecoration() => BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(45), topRight: Radius.circular(45)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 5)),
        ],
      );

  Widget getImage(String? url) {
    if (url == null)
      return Image(image: AssetImage('assets/no-image.png'), fit: BoxFit.cover);

    if (url.contains('http'))
      return FadeInImage(
          placeholder: AssetImage('assets/jar-loading.gif'),
          image: NetworkImage(this.url!),
          fit: BoxFit.cover,
          imageErrorBuilder: (_, url, error) => new Icon(Icons.error));

    return Image.file(File(url),
        fit: BoxFit.cover,
        errorBuilder: (_, url, error) => new Icon(Icons.error));
  }
}
