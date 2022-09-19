import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:Unica/models/aut_models.dart';
import 'package:Unica/widgets/widgets.dart';
import 'package:get/get.dart';

import '../controllers/controllers.dart';
import '../models/doc_model.dart';

class ViewPDFScreen extends StatelessWidget {
  final docCtrl = Get.find<DocumentController>();

  @override
  Widget build(BuildContext context) {
    final Doc data = ModalRoute.of(context)!.settings.arguments as Doc;
    return Scaffold(
      appBar: AppBar(
        title: Text(data.docName),
      ),
      body: Stack(
        children: [
          Background(color2: Color(0xff6989F5), color1: Colors.white),
          PDFViewer(document: docCtrl.document.value)
        ],
      ),
    );
  }
}
