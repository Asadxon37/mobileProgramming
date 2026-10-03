// Problem 8.3

class Vehicle {
  final String brand;
  final int year;

  Vehicle(this.brand, this.year);

  void info() => print('$brand ($year)');
}

class OldStyleCar extends Vehicle {
  final int batteryCapacity;

  OldStyleCar(String brand, int year, this.batteryCapacity)
      : super(brand, year);
}

class ElectricCar extends Vehicle {
  final int batteryCapacity;

  // Forwarded to Vehicle
  ElectricCar(super.brand, super.year, this.batteryCapacity);

  @override
  void info() {
    super.info();
    print('Battery: $batteryCapacity kWh');
  }
}

class Truck extends Vehicle {
  final double loadTons;

  Truck({required String brand, required int year, required this.loadTons})
      : super(brand, year);
}

void main() {
  OldStyleCar('Chevrolet', 2020, 60).info();
  ElectricCar('Tesla', 2024, 75).info();
  final truck = Truck(brand: 'Isuzu', year: 2022, loadTons: 5.5);
  truck.info();
  print('Load: ${truck.loadTons} tons');
}
