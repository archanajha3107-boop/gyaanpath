import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';
import '../../constants/app_colors.dart';

class TextbookScreen extends StatefulWidget {
  final String pdfPath;

  const TextbookScreen({
    super.key,
    required this.pdfPath,
  });

  @override
  State<TextbookScreen> createState() => _TextbookScreenState();
}

class _TextbookScreenState extends State<TextbookScreen> {
  late PdfController _pdfController;
  int  _currentPage  = 1;
  int  _totalPages   = 0;
  bool _isLoading    = true;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfController(
      document: PdfDocument.openAsset(widget.pdfPath),
    );
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Handle missing PDF
    if (widget.pdfPath.isEmpty) {
      return _NoPdfScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Textbook'),
        actions: [
          // Page indicator
          if (_totalPages > 0)
            Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  '$_currentPage / $_totalPages',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.muted,
                  ),
                ),
              ),
            ),
          // Jump to page
          IconButton(
            icon: const Icon(Icons.input),
            onPressed: () => _showJumpToPage(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // PDF Viewer
          Expanded(
            child: PdfView(
              controller: _pdfController,
              scrollDirection: Axis.vertical,
              onDocumentLoaded: (doc) {
                setState(() {
                  _totalPages = doc.pagesCount;
                  
                });
              },
              onPageChanged: (page) {
                setState(() => _currentPage = page);
              },
              builders: PdfViewBuilders<DefaultBuilderOptions>(
                options: const DefaultBuilderOptions(),
                documentLoaderBuilder: (_) => const Center(
                  child: CircularProgressIndicator(),
                ),
                pageLoaderBuilder: (_) => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),

          // Bottom Page Controls
          _PageControls(
            controller:  _pdfController,
            currentPage: _currentPage,
            totalPages:  _totalPages,
          ),
        ],
      ),
    );
  }

  void _showJumpToPage(BuildContext context) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Go to Page'),
        content: TextField(
          controller:  controller,
          keyboardType:TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Page (1 - $_totalPages)',
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final page = int.tryParse(controller.text);
              if (page != null && page >= 1 && page <= _totalPages) {
                _pdfController.jumpToPage(page);
              }
              Navigator.pop(ctx);
            },
            child: const Text('Go'),
          ),
        ],
      ),
    );
  }
}

// ── PAGE CONTROLS ─────────────────────────────

class _PageControls extends StatelessWidget {
  final PdfController controller;
  final int currentPage;
  final int totalPages;

  const _PageControls({
    required this.controller,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 24, vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(color: Theme.of(context).dividerColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.first_page),
            onPressed: currentPage > 1
              ? () => controller.jumpToPage(1)
              : null,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: currentPage > 1
              ? () => controller.previousPage(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                )
              : null,
          ),
          Text(
            '$currentPage',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.saffron,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: currentPage < totalPages
              ? () => controller.nextPage(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.easeInOut,
                )
              : null,
          ),
          IconButton(
            icon: const Icon(Icons.last_page),
            onPressed: currentPage < totalPages
              ? () => controller.jumpToPage(totalPages)
              : null,
          ),
        ],
      ),
    );
  }
}

// ── NO PDF PLACEHOLDER ────────────────────────

class _NoPdfScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Textbook')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('📄', style: TextStyle(fontSize: 64)),
              const SizedBox(height: 20),
              const Text(
                'PDF Coming Soon',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Download the Balbharati PDF from\nebalbharati.in and place it in\nassets/pdfs/ssc/class_10/',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.muted,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
