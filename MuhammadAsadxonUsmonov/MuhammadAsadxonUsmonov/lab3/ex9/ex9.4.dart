// Problem 9.5

abstract class Musician {
  void perform() => print('Musician performs.');
}

class Guitarist extends Musician {}

class Pianist extends Musician {}

// Only for Musician subclasses
mixin Singer on Musician {
  void sing() {
    print('Singing a song...');
    perform();
  }
}

class SingingGuitarist extends Guitarist with Singer {}

class SingingPianist extends Pianist with Singer {}

void main() {
  SingingGuitarist().sing();
  SingingPianist().sing();
}
