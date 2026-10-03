// Problem 7.2

enum Day { monday, tuesday, wednesday, thursday, friday, saturday, sunday }

void main() {
  for (final Day day in Day.values) {
    print('${day.index + 1}. ${day.name}');
  }

  print('Total days: ${Day.values.length}');
  print('First: ${Day.values.first}, last: ${Day.values.last}');
}
