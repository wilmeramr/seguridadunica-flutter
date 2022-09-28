import 'package:advance_pdf_viewer_fork/advance_pdf_viewer_fork.dart';
import 'package:flutter/material.dart';
import 'package:Unica/models/aut_models.dart';
import 'package:Unica/widgets/widgets.dart';
import 'package:get/get.dart';

import '../controllers/controllers.dart';
import '../models/doc_model.dart';

class ViewPDFScreen extends StatefulWidget {
  final String url;
  final String title;

  const ViewPDFScreen({required this.url, required this.title});
  @override
  State<ViewPDFScreen> createState() => _ViewPDFScreenState();
}

class _ViewPDFScreenState extends State<ViewPDFScreen> {
  late PDFDocument document;
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
  }

  loadDocument() async {
    document = await PDFDocument.fromURL(widget.url);

    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          const Background(color2: Color(0xff6989F5), color1: Colors.white),
          FutureBuilder<PDFDocument>(
              future: PDFDocument.fromURL(widget.url),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Center(
                        child: Text('Error al intentar abrir el documento'));
                  case ConnectionState.waiting:
                    return const Center(child: CircularProgressIndicator());
                  default:
                    if (snapshot.hasError) {
                      return const Center(
                          child: Text('Error al intentar abrir el documento'));
                    } else {
                      return PDFViewer(
                        document: snapshot.data!,
                        tooltip: const PDFViewerTooltip(
                            pick: 'Seleccione una página'),
                        zoomSteps: 1,
                        scrollDirection: Axis.vertical,
                      );
                    }
                }
              }),
        ],
      ),
    );
  }
}
