import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:foe_archive/resources/values_manager.dart';
import 'package:pdfx/pdfx.dart';

class PdfViewer extends StatefulWidget {
  final PlatformFile file;

  const PdfViewer({Key? key, required this.file}) : super(key: key);

  @override
  State<PdfViewer> createState() => _PdfViewerState();
}

class _PdfViewerState extends State<PdfViewer> {
  late PdfController controller;
  @override
  void initState() {
    controller = PdfController(document: PdfDocument.openFile(widget.file.path!),);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(AppSize.s6),
        child: PdfView(
          controller: controller,
          scrollDirection: Axis.vertical,
        )
    );
  }
}