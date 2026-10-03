// Problem 11.2

class UserData {
  final int id;
  final String name;
  final String email;

  UserData(this.id, this.name, this.email);

  @override
  String toString() => 'UserData(id: $id, name: $name, email: $email)';
}

Future<UserData> fetchUserFromDb(int id) async {
  print('Querying database for user $id...');
  await Future.delayed(const Duration(seconds: 2));
  return UserData(id, 'Asad', 'asad@example.com');
}

Future<void> main() async {
  print('Start');
  final UserData user = await fetchUserFromDb(1024);
  print('Result: $user');
  print('Done');
}
