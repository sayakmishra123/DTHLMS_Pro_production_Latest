import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewPage extends StatefulWidget {
  final String book;
  final String bookname;
           PdfViewPage(this.book,this.bookname);

  @override
  _PdfViewPageState createState() => _PdfViewPageState();
}

class _PdfViewPageState extends State<PdfViewPage> {
  // Create a PDF view controller
  final PdfViewerController _pdfViewerController = PdfViewerController();

  // Default zoom level
  double _currentZoomLevel = 1.0;

  @override
  void dispose() {
    _pdfViewerController.dispose(); // Dispose the controller when done
    super.dispose();
  }

  void _zoomIn() {
    setState(() {
      if (_currentZoomLevel < 3.0) { // Limit the maximum zoom level
        _currentZoomLevel += 0.25;
        _pdfViewerController.zoomLevel = _currentZoomLevel;
      }
    });
  }

  void _zoomOut() {
    setState(() {
      if (_currentZoomLevel > 1.0) { // Limit the minimum zoom level
        _currentZoomLevel -= 0.25;
        _pdfViewerController.zoomLevel = _currentZoomLevel;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.bookname}'),
        actions: [
          IconButton(
            icon: Icon(Icons.zoom_out),
            onPressed: _zoomOut, // Zoom out functionality
          ),
          IconButton(
            icon: Icon(Icons.zoom_in),
            onPressed: _zoomIn, // Zoom in functionality
          ),
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Navigate to the previous page
              _pdfViewerController.previousPage();
            },
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: () {
              // Navigate to the next page
              _pdfViewerController.nextPage();
            },
          ),
        ],
      ),
      body: SfPdfViewer.network(
        widget.book,
        controller: _pdfViewerController,
      ),
    );
  }
}
