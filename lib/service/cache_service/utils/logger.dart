class Logger {
  static info(String message) {
    DateTime now = DateTime.now();
    print(
      '${now.year}/${now.month}/${now.day} ${now.hour}:${now.minute}:${now.second} $message',
    );
  }

  static error(String message) {
    DateTime now = DateTime.now();
    print(
      'ERROR ${now.year}/${now.month}/${now.day} ${now.hour}:${now.minute}:${now.second} $message',
    );
  }
}
