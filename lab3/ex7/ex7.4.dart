// Problem 7.5

enum Role { admin, editor, viewer }

// byName() throws, so return null
Role? parseRole(String raw) {
  try {
    return Role.values.byName(raw.trim().toLowerCase());
  } on ArgumentError {
    return null;
  }
}

void main() {
  final List<String> rawInputs = ['admin', ' Editor ', 'VIEWER', 'superuser', ''];

  for (final String raw in rawInputs) {
    final Role? role = parseRole(raw);
    if (role != null) {
      print('"$raw" -> Role.${role.name}');
    } else {
      print('"$raw" -> invalid role, using default Role.viewer');
    }
  }

  final Map<String, Role> byNameMap = Role.values.asNameMap();
  print(byNameMap['admin']);
  print(byNameMap['guest']);
}
