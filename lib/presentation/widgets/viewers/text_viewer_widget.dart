import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/monokai-sublime.dart';

class TextViewerWidget extends StatelessWidget {
  final String content;
  final String filePath;
  final double zoomLevel;

  const TextViewerWidget({
    super.key,
    required this.content,
    required this.filePath,
    required this.zoomLevel,
  });

  String _getLanguage() {
    final ext = p.extension(filePath).toLowerCase();
    const langMap = {
      '.dart': 'dart',
      '.py': 'python',
      '.js': 'javascript',
      '.ts': 'typescript',
      '.html': 'html',
      '.css': 'css',
      '.json': 'json',
      '.xml': 'xml',
      '.yaml': 'yaml',
      '.yml': 'yaml',
      '.sh': 'bash',
      '.bash': 'bash',
      '.c': 'c',
      '.cpp': 'cpp',
      '.h': 'c',
      '.java': 'java',
      '.kt': 'kotlin',
      '.rs': 'rust',
      '.go': 'go',
      '.csv': 'plaintext',
      '.txt': 'plaintext',
      '.log': 'plaintext',
      '.ini': 'ini',
      '.conf': 'plaintext',
    };
    return langMap[ext] ?? 'plaintext';
  }

  @override
  Widget build(BuildContext context) {
    final lines = content.split('\n');
    final language = _getLanguage();

    return Container(
      color: const Color(0xFF272822), // Monokai background
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Line numbers gutter
          Container(
            padding: const EdgeInsets.only(top: 12, left: 8, right: 8),
            color: const Color(0xFF1E1F1C),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: List.generate(
                  lines.length,
                  (i) => SizedBox(
                    height: 20 * zoomLevel,
                    child: Text(
                      '${i + 1}',
                      style: TextStyle(
                        fontSize: 13 * zoomLevel,
                        color: Colors.white24,
                        fontFamily: 'monospace',
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Code content
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(0),
                  child: Transform.scale(
                    scale: zoomLevel,
                    alignment: Alignment.topLeft,
                    child: HighlightView(
                      content,
                      language: language,
                      theme: monokaiSublimeTheme,
                      padding: const EdgeInsets.all(12),
                      textStyle: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
