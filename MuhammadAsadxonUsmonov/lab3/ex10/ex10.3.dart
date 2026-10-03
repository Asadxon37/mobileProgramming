// Problem 10.4

class User {
  final int id;
  final String name;
  User(this.id, this.name);

  @override
  String toString() => 'User($id, $name)';
}

class Product {
  final int id;
  final String title;
  final double price;
  Product(this.id, this.title, this.price);

  @override
  String toString() => 'Product($id, $title, \$$price)';
}

class Repository<T> {
  final Map<int, T> _storage = {};

  void save(int id, T item) => _storage[id] = item;

  T? findById(int id) => _storage[id];

  List<T> findAll() => _storage.values.toList();

  bool delete(int id) => _storage.remove(id) != null;

  int get count => _storage.length;
}

void main() {
  final Repository<User> userRepo = Repository<User>();
  userRepo.save(1, User(1, 'Asad'));
  userRepo.save(2, User(2, 'Dilnoza'));

  final Repository<Product> productRepo = Repository<Product>();
  productRepo.save(10, Product(10, 'Laptop', 899.99));

  print(userRepo.findAll());
  print(userRepo.findById(2));
  print(productRepo.findAll());
  print('Users: ${userRepo.count}, products: ${productRepo.count}');

  userRepo.delete(1);
  print('After delete: ${userRepo.findAll()}');
}
