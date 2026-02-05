import 'package:diamate/core/extensions/context_extension.dart';
import 'dart:io';
import 'package:diamate/core/widgets/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class PdfViewerView extends StatelessWidget {
  final String title;
  final String pdfPath;

  const PdfViewerView({super.key, required this.title, required this.pdfPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: CustomAppBar(
                title: title,
                back: true,
                onTap: () => context.pop(),
                notification: false,
              ),
            ),
            Expanded(child: SfPdfViewer.file(File(pdfPath))),
          ],
        ),
      ),
    );
  }
}
