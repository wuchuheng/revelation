class Logger {
  static info(String message) {
    DateTime now = DateTime.now();
    print(
      '${now.year}/${now.month}/${now.day} ${now.hour}:${now.minute}:${now.second} $message',
    );
  }
}
