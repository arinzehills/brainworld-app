import 'dart:io';

import 'package:brainworld/components/myappbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';

class FullPDFPage extends StatefulWidget {
  final File file;
  final filename;
  const FullPDFPage({Key? key, required this.file, required this.filename})
      : super(key: key);

  @override
  State<FullPDFPage> createState() => _FullPDFPageState();
}

class _FullPDFPageState extends State<FullPDFPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppMenuBar(
        showRightIcons: false,
        title: widget.filename,
        imageUrl: 'assets/svg/arrowback.svg',
      ),
      body: PDFView(filePath: widget.file.path),
    );
  }
}
