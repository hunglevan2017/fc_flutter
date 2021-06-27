import 'dart:io';

import 'package:camerawesome/models/orientations.dart';
import 'package:fc_collection/util/Constant.dart';
import 'package:fc_collection/util/FileCustomerManager.dart';
import 'package:flutter/material.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';

class CameraPage extends StatefulWidget{
  final pathFolder;
  final nameFolder;

  const CameraPage({Key key, this.pathFolder, this.nameFolder}) : super(key: key);

  @override
  CameraPageState createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> with TickerProviderStateMixin{
  ValueNotifier<CameraFlashes> _switchFlash = ValueNotifier(CameraFlashes.NONE);
  ValueNotifier<Sensors> _sensor = ValueNotifier(Sensors.BACK);
  ValueNotifier<CaptureModes> _captureMode = ValueNotifier(CaptureModes.PHOTO);
  ValueNotifier<Size> _photoSize = ValueNotifier(null);
  ValueNotifier<double> _zoomeValue = ValueNotifier(0.64);
  File _croppedFile;
  FileCustomerManager _fileCustomerManager = FileCustomerManager();
  bool isProcess = false;
  bool isFront = false;
  bool isFlash = false;

  // Controllers
  PictureController _pictureController = new PictureController();

  _setCameraMode(){
    setState(() {
      isFront = !isFront;
    });
  }

  _setFlash(){
    setState(() {
      isFlash = !isFlash;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: COLOR_PRIMARY,
        title: Text(widget.nameFolder),
      ),
      body: Column(
        children: [
          Expanded(
              child: CameraAwesome(
                testMode: false,
                onPermissionsResult: (bool result) { },
                selectDefaultSize: (List<Size> availableSizes) => Size(1920, 1080),
                onCameraStarted: () { },
                onOrientationChanged: (CameraOrientations newOrientation) { },
                sensor: _sensor,
                photoSize: _photoSize,
                switchFlashMode: _switchFlash,
                captureMode: _captureMode,
                zoom: _zoomeValue,
                orientation: DeviceOrientation.portraitUp,
                fitted: true,
              ),
          ),

          bottomAppBar()
        ],
      ),
    );
  }

  Widget bottomAppBar(){
    return Container(
        height: heightAppBar,
        width: double.infinity,
        decoration: BoxDecoration(
            color: COLOR_PRIMARY,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 5,
                  offset: Offset(0,3)
              )
            ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            IconButton(
                onPressed: () async {
                  _setFlash();
                  if(isFlash){
                    _switchFlash.value = CameraFlashes.ON;
                  }else{
                    _switchFlash.value = CameraFlashes.NONE;
                  }
                },
                icon: Icon(isFlash ? Icons.flash_on : Icons.flash_off,color: Colors.white)
            ),

            IconButton(
                onPressed: () async {
                  if(!isProcess){
                    final milisecondTime = DateTime.now().microsecondsSinceEpoch;
                    final nameFile = '${widget.nameFolder}_$milisecondTime.jpg';
                    final pathNewImage = '${widget.pathFolder}/$nameFile';
                    await _pictureController.takePicture(pathNewImage);
                    _croppedFile = await ImageCropper.cropImage(
                        sourcePath: pathNewImage,
                        androidUiSettings: AndroidUiSettings(
                            toolbarTitle: nameFile,
                            toolbarColor: COLOR_PRIMARY,
                            toolbarWidgetColor: Colors.white,
                            initAspectRatio: CropAspectRatioPreset.original,
                            lockAspectRatio: false),
                        iosUiSettings: IOSUiSettings(
                          title: nameFile,
                        )
                    );
                    if(_croppedFile != null){
                      await _fileCustomerManager.copyFile(_croppedFile.path, pathNewImage);
                      await _croppedFile.delete();
                    }

                    isProcess = false;
                    Navigator.of(context).pop();

                  }
                },
                icon: Icon(Icons.camera_alt,color: Colors.white)
            ),

            IconButton(
                onPressed: () async {
                  _setCameraMode();
                  if(isFront){
                    _sensor.value = Sensors.FRONT;
                  }else{
                    _sensor.value = Sensors.BACK;
                  }
                },
                icon: Icon(isFront ? Icons.camera_front : Icons.camera_rear,color: Colors.white)
            ),


          ],
        )
    );
  }

  @override
  void dispose() {
    _captureMode.dispose();
    _switchFlash.dispose();
    _sensor.dispose();
    _zoomeValue.dispose();
    _photoSize.dispose();
    super.dispose();
  }

}