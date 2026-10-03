// Problem 9.4

mixin Walker {
  void walk() => print('$runtimeType is walking.');
}

mixin Swimmer {
  void swim() => print('$runtimeType is swimming.');
}

mixin Flyable {
  void fly() => print('$runtimeType is flying.');
}

class Animal {
  final String name;
  Animal(this.name);
}

class Duck extends Animal with Walker, Swimmer, Flyable {
  Duck(super.name);

  void quack() => print('$name says: Quack!');
}

class Dog extends Animal with Walker, Swimmer {
  Dog(super.name);
}

void main() {
  final Duck duck = Duck('Donald');
  duck.walk();
  duck.swim();
  duck.fly();
  duck.quack();

  final Dog dog = Dog('Rex');
  dog.walk();
  dog.swim();
}
