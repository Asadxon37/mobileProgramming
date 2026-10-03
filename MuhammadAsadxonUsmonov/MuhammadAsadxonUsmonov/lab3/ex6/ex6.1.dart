// Problem 6.2

class Person {
  String name;
  int age;

  Person(this.name, this.age);

  void introduce() => print('Hi, I am $name and I am $age years old.');

  @override
  String toString() => 'Person(name: $name, age: $age)';
}

void main() {
  final Person p1 = Person('Asad', 20);
  final Person p2 = Person('Dilnoza', 22);

  p1.introduce();
  p2.introduce();
  print(p1);

  p1.age = 21;
  print('After birthday: $p1');
}
