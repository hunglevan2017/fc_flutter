
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter_archive/flutter_archive.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

class FileCustomerManager{
  final rootFolder = "fc_collect";
  final pdfFolder = "pdf";
  final zipFolder = "zip";

  Future<String>createFolderByName(String name) async{
    final dirDocument = await getApplicationDocumentsDirectory();
    final dirPathCreated = Directory("${dirDocument.path}/$rootFolder/$name");

    if(await dirPathCreated.exists()){
      return dirPathCreated.path;
    }else{
      Directory newFolder = await dirPathCreated.create(recursive: true);
      return newFolder.path;
    }
  }

  Future<List<String>> getChildFile(String path) async{
    final dirPathCreated = Directory(path);

    var listChildFile = await dirPathCreated.list(recursive: false).toList();

    return listChildFile.map((e) => e.path).toList();
  }

  Future<void> deleteFile(String path) async{

    File file = File(path);
    Directory folder = Directory(path);
    if(await file.exists()){
      file.deleteSync(recursive: false);
    }

    if(await folder.exists()){
      folder.deleteSync(recursive: true);
    }
  }

  Future<void> copyFile(String path,String newPath) async {
    File file = File(path);
    await file.copy(newPath);
  }

  convertImagesToPDF(String pathFolder,String nameFile, String customerFolder) async {
    final dirDocument = await getApplicationDocumentsDirectory();
    final dirPathCreated = File("${dirDocument.path}/$rootFolder/$pdfFolder/$customerFolder/$nameFile.pdf");
    dirPathCreated.create(recursive: true);

    List<String> listChildFile = await getChildFile(pathFolder);
    PdfDocument document = PdfDocument();
    document.pageSettings.margins.all = 0;

    for(String element in listChildFile){
      PdfPage page = document.pages.add();
      PdfImage image = PdfBitmap( await _readImageFromPath(element));
      page.graphics.drawImage(image, Rect.fromLTWH(0, 0, page.size.width, page.size.height));
    }

    List<int> bytes = document.save();
    await dirPathCreated.writeAsBytes(bytes);

    document.dispose();
  }

  Future<Uint8List> _readImageFromPath(String path) async{
     var result = await FlutterImageCompress.compressWithFile(path,quality: 30);
     return result;
  }

  Future<String> zipFolderByPath(String customerFolder,String zipName) async{
    final dirDocument = await getApplicationDocumentsDirectory();
    final folderZip = Directory("${dirDocument.path}/$rootFolder/$pdfFolder/$customerFolder");
    final zipFile = File("${dirDocument.path}/$rootFolder/$zipFolder/$zipName.zip");
    if(await zipFile.exists() == false){
      zipFile.createSync(recursive: true);
    }
    try{
      await ZipFile.createFromDirectory(sourceDir: folderZip, zipFile: zipFile, recurseSubDirs: true);
      await folderZip.delete(recursive: true);
    }catch(e){

    }

    return zipFile.path;

  }

}