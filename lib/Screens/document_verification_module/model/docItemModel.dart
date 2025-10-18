enum DocStatus { empty, uploaded, verified }

class DocItem {
  DocItem({
    required this.title,
    this.subtitle,
    this.isRequired, // renamed from “required” keyword conflict
    this.filePath,
    this.fileName,
    this.status = DocStatus.empty,
    this.date,
  });

  final String title;
  final String? subtitle; // nullable now
  final bool? isRequired; // nullable + renamed

  String? filePath;
  String? fileName;
  DocStatus status;
  DateTime? date;

  bool get hasFile => filePath != null && fileName != null;

  /// CopyWith method for updating fields
  DocItem copyWith({
    String? title,
    String? subtitle,
    bool? isRequired,
    String? filePath,
    String? fileName,
    DocStatus? status,
    DateTime? date,
  }) {
    return DocItem(
      title: title ?? this.title,
      subtitle: subtitle ?? this.subtitle,
      isRequired: isRequired ?? this.isRequired,
      filePath: filePath ?? this.filePath,
      fileName: fileName ?? this.fileName,
      status: status ?? this.status,
      date: date ?? this.date,
    );
  }
}
