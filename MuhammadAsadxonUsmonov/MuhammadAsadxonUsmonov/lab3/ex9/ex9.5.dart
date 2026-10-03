// Problem 9.6

class Logger {
  void log(String message) => print('[LOG] $message');
}

// implements: contract only
class ConsoleService implements Logger {
  @override
  void log(String message) => print('[ConsoleService] $message');
}

mixin LoggerMixin {
  void log(String message) => print('[MIXIN] $message');
}

// with: reuses implementation
class FileService with LoggerMixin {}

class NetworkService with LoggerMixin {
  void send() {
    log('Sending data...');
  }
}

void main() {
  print('--- implements ---');
  ConsoleService().log('Hello');

  print('--- with ---');
  FileService().log('Hello');
  NetworkService().send();

  print(ConsoleService() is Logger);
  print(FileService() is LoggerMixin);
}
