// Problem 8.2

class Animal {
  final String name;

  Animal(this.name);

  void makeSound() => print('$name makes a generic animal sound.');
}

class Dog extends Animal {
  Dog(super.name);

  @override
  void makeSound() => print('$name says: Woof! Woof!');
}

class Cat extends Animal {
  Cat(super.name);

  @override
  void makeSound() => print('$name says: Meow!');
}

void main() {
  final Animal generic = Animal('Creature');
  final Animal dog = Dog('Rex');
  final Animal cat = Cat('Luna');

  generic.makeSound();
  dog.makeSound();
  cat.makeSound();
}
