enum DocStatus { empty, uploaded, verified }

class DocItem {
  DocItem({
    required this.title,
    required this.subtitle,
    required this.required,
    this.filePath,
    this.fileName,
    this.status = DocStatus.empty,
    this.date,
  });

  final String title;
  final String subtitle;
  final bool required;

  String? filePath;
  String? fileName;
  DocStatus status;
  DateTime? date;

  bool get hasFile => filePath != null && fileName != null;
}
