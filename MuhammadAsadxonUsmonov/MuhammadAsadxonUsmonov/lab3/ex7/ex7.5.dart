// Problem 7.7

enum TrafficLight {
  red(Duration(seconds: 30)),
  green(Duration(seconds: 25)),
  yellow(Duration(seconds: 5));

  final Duration duration;
  const TrafficLight(this.duration);

  // Transition rule
  TrafficLight get next => switch (this) {
        TrafficLight.red => TrafficLight.green,
        TrafficLight.green => TrafficLight.yellow,
        TrafficLight.yellow => TrafficLight.red,
      };

  bool canTransitionTo(TrafficLight target) => next == target;
}

class TrafficLightMachine {
  TrafficLight _state = TrafficLight.red;

  TrafficLight get state => _state;

  void goTo(TrafficLight target) {
    if (!_state.canTransitionTo(target)) {
      throw StateError('Illegal transition: ${_state.name} -> ${target.name}');
    }
    print('${_state.name} -> ${target.name} '
        '(stays ${target.duration.inSeconds}s)');
    _state = target;
  }

  void advance() => goTo(_state.next);
}

void main() {
  final machine = TrafficLightMachine();

  for (int i = 0; i < 4; i++) {
    machine.advance();
  }

  try {
    machine.goTo(TrafficLight.red);
  } on StateError catch (e) {
    print(e.message);
  }
}
