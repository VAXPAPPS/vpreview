import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownViewerWidget extends StatelessWidget {
  final String content;
  final double zoomLevel;

  const MarkdownViewerWidget({
    super.key,
    required this.content,
    required this.zoomLevel,
  });

  @override
  Widget build(BuildContext context) {
    final baseFontSize = 14.0 * zoomLevel;

    return Container(
      color: const Color(0xFF1E1E2E),
      child: Markdown(
        data: content,
        selectable: true,
        padding: const EdgeInsets.all(24),
        styleSheet: MarkdownStyleSheet(
          // Headings
          h1: TextStyle(fontSize: baseFontSize * 2.0, fontWeight: FontWeight.bold, color: Colors.white),
          h2: TextStyle(fontSize: baseFontSize * 1.6, fontWeight: FontWeight.w700, color: Colors.white),
          h3: TextStyle(fontSize: baseFontSize * 1.3, fontWeight: FontWeight.w600, color: Colors.white),
          h4: TextStyle(fontSize: baseFontSize * 1.1, fontWeight: FontWeight.w600, color: Colors.white70),
          h5: TextStyle(fontSize: baseFontSize, fontWeight: FontWeight.w600, color: Colors.white70),
          h6: TextStyle(fontSize: baseFontSize * 0.9, fontWeight: FontWeight.w500, color: Colors.white60),

          // Body
          p: TextStyle(fontSize: baseFontSize, color: Colors.white70, height: 1.7),
          a: TextStyle(fontSize: baseFontSize, color: const Color(0xFF89B4FA), decoration: TextDecoration.underline),

          // Code
          code: TextStyle(
            fontSize: baseFontSize * 0.9,
            backgroundColor: const Color(0xFF313244),
            color: const Color(0xFFA6E3A1),
            fontFamily: 'monospace',
          ),
          codeblockDecoration: BoxDecoration(
            color: const Color(0xFF313244),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.white10),
          ),
          codeblockPadding: const EdgeInsets.all(16),

          // Blockquote
          blockquote: TextStyle(fontSize: baseFontSize, color: Colors.white38, fontStyle: FontStyle.italic),
          blockquoteDecoration: const BoxDecoration(
            border: Border(left: BorderSide(color: Color(0xFF89B4FA), width: 3)),
          ),
          blockquotePadding: const EdgeInsets.only(left: 16, top: 4, bottom: 4),

          // Lists
          listBullet: TextStyle(fontSize: baseFontSize, color: const Color(0xFF89B4FA)),

          // Table
          tableHead: TextStyle(fontSize: baseFontSize, fontWeight: FontWeight.bold, color: Colors.white),
          tableBody: TextStyle(fontSize: baseFontSize, color: Colors.white70),
          tableBorder: TableBorder.all(color: Colors.white12, width: 1),
          tableHeadAlign: TextAlign.left,
          tableCellsPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),

          // Divider
          horizontalRuleDecoration: const BoxDecoration(
            border: Border(top: BorderSide(color: Colors.white12, width: 1)),
          ),
        ),
      ),
    );
  }
}
