// Problem 10.3

class Animal {
  void eat() => print('Animal eats.');
}

class Dog extends Animal {
  void bark() => print('Woof!');
}

class Cat extends Animal {
  void purr() => print('Purr...');
}

void main() {
  final List<Animal> animals = [Dog(), Cat(), Animal()];

  for (final Animal a in animals) {
    a.eat();

    // 'is' promotes a to Dog
    if (a is Dog) {
      a.bark();
    } else if (a is Cat) {
      a.purr();
    } else {
      print('Just a plain animal.');
    }
  }

  Animal pet = Dog();
  print('Is not a Cat? ${pet is! Cat}');

  (pet as Dog).bark();

  try {
    // 'as' throws on wrong type
    (pet as Cat).purr();
  } on TypeError catch (e) {
    print('Bad cast: $e');
  }

  Object value = 'Hello';
  if (value is String) {
    print('Length: ${value.length}');
  }
}
