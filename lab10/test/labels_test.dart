import 'package:flutter_test/flutter_test.dart';
import 'package:tm_classifier/services/labels.dart';

void main() {
  group('parseLabels', () {
    test('normal case', () {
      expect(parseLabels('0 Mug\n1 Bottle\n'), ['Mug', 'Bottle']);
    });

    test('Windows line endings, trailing blank line and a label with a space', () {
      expect(
        parseLabels('0 Mug\r\n1 Bottle\r\n2 Car keys\r\n\r\n'),
        ['Mug', 'Bottle', 'Car keys'],
      );
    });

    test('a label that itself starts with digits keeps them', () {
      expect(parseLabels('0 3D printer\n'), ['3D printer']);
    });

    test('empty file gives no labels', () {
      expect(parseLabels(''), isEmpty);
    });
  });
}
