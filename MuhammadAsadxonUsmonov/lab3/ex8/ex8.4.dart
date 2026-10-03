// Problem 8.5

abstract class Employee {
  final String name;
  final double baseSalary;

  Employee(this.name, this.baseSalary);

  // Abstract: subclasses must implement
  double calculateSalary();

  // Concrete: shared
  void printPayslip() {
    print('--- Payslip ---');
    print('Employee: $name');
    print('Role: $role');
    print('Salary: \$${calculateSalary().toStringAsFixed(2)}');
  }

  String get role;
}

class Manager extends Employee {
  final double bonus;

  Manager(super.name, super.baseSalary, this.bonus);

  @override
  String get role => 'Manager';

  @override
  double calculateSalary() => baseSalary + bonus;
}

class Developer extends Employee {
  final int overtimeHours;

  Developer(super.name, super.baseSalary, this.overtimeHours);

  @override
  String get role => 'Developer';

  @override
  double calculateSalary() => baseSalary + overtimeHours * 20;
}

void main() {
  final List<Employee> staff = [
    Manager('Aziza', 3000, 800),
    Developer('Asad', 2000, 10),
  ];

  for (final Employee e in staff) {
    e.printPayslip();
  }
}
