// Problem 9.3

mixin Flyable {
  void fly() => print('$runtimeType is flying high!');
}

class Animal {
  final String name;
  Animal(this.name);
}

class Bird extends Animal with Flyable {
  Bird(super.name);
}

class Airplane with Flyable {}

void main() {
  final Bird eagle = Bird('Eagle');
  eagle.fly();

  Airplane().fly();

  print(eagle is Flyable);
}
