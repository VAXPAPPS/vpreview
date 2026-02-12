import 'package:equatable/equatable.dart';

/// Represents a bookmark within a document.
class BookmarkEntity extends Equatable {
  final String id;
  final String documentPath;
  final int pageNumber;
  final String label;
  final DateTime createdAt;

  const BookmarkEntity({
    required this.id,
    required this.documentPath,
    required this.pageNumber,
    required this.label,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'documentPath': documentPath,
    'pageNumber': pageNumber,
    'label': label,
    'createdAt': createdAt.toIso8601String(),
  };

  factory BookmarkEntity.fromJson(Map<String, dynamic> json) => BookmarkEntity(
    id: json['id'] as String,
    documentPath: json['documentPath'] as String,
    pageNumber: json['pageNumber'] as int,
    label: json['label'] as String,
    createdAt: DateTime.parse(json['createdAt'] as String),
  );

  @override
  List<Object?> get props => [id, documentPath, pageNumber, label, createdAt];
}
