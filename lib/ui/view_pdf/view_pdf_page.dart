import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

class ViewPdfPage extends StatefulWidget{
  final path;
  const ViewPdfPage({Key key, this.path}) : super(key: key);

  @override
  ViewPdfPageState createState() => ViewPdfPageState();
}

class ViewPdfPageState extends State<ViewPdfPage>{
  PDFDocument doc;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    PDFDocument.fromAsset(widget.path).then((value){
      setState(() {
        doc = value;
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Center(
          child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : PDFViewer(document: doc)),
    );
  }
}