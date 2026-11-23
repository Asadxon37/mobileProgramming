
List<String> parseLabels(String raw) => [
      for (final line in raw.replaceAll('\uFEFF', '').split(RegExp(r'\r?\n')))
        if (line.trim().isNotEmpty)
          line.trim().replaceFirst(RegExp(r'^\d+\s+'), ''),
    ];
