// Problem 5.5

/// Base document.
class Document {
  /// Text shown when printed.
  String describe() => 'Generic document';

  /// Use [describe] instead.
  @deprecated
  String oldDescribe() => describe();
}

/// A PDF document.
class PdfDocument extends Document {
  /// File name.
  final String fileName;

  /// Creates a PDF named [fileName].
  PdfDocument(this.fileName);

  /// Adds the file name.
  @override
  String describe() => 'PDF document: $fileName';
}

void main() {
  final Document doc = PdfDocument('lab2.pdf');
  print(doc.describe());
  print(doc.oldDescribe());
}
