/// Supported file extensions for the Document Viewer
class SupportedExtensions {
  static const List<String> pdf = ['.pdf'];

  static const List<String> image = [
    '.png', '.jpg', '.jpeg', '.gif', '.bmp', '.webp', '.svg',
  ];

  static const List<String> text = [
    '.txt', '.log', '.json', '.xml', '.yaml', '.yml',
    '.csv', '.ini', '.conf', '.sh', '.bash',
    '.dart', '.py', '.js', '.ts', '.html', '.css',
    '.c', '.cpp', '.h', '.java', '.kt', '.rs', '.go',
  ];

  static const List<String> markdown = ['.md', '.markdown'];

  static List<String> get all => [...pdf, ...image, ...text, ...markdown];

  static bool isSupported(String extension) {
    return all.contains(extension.toLowerCase());
  }

  static DocumentType getType(String extension) {
    final ext = extension.toLowerCase();
    if (pdf.contains(ext)) return DocumentType.pdf;
    if (image.contains(ext)) return DocumentType.image;
    if (markdown.contains(ext)) return DocumentType.markdown;
    if (text.contains(ext)) return DocumentType.text;
    return DocumentType.unknown;
  }
}

enum DocumentType { pdf, image, text, markdown, unknown }
