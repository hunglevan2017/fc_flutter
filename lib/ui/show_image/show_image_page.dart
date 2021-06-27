
import 'dart:io';

import 'package:fc_collection/util/Constant.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ShowImagePage extends StatelessWidget{
  final String path;

  const ShowImagePage({Key key, this.path}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: COLOR_PRIMARY,
        title: Text(path.split('/').last),
      ),
      body: Container(
        child: PhotoView(
            imageProvider: FileImage(File(path)),
        ),
      ),
    );
  }

}