import 'dart:developer' as developer;

class AppLogger {
  static void info(String msj) {
    DateTime now = DateTime.now();
    developer.log(
      "ℹ️ $msj",
      name: "INFO",
      time: DateTime(now.hour, now.minute, now.second, now.millisecond),
    );
  }

  static void warn(String msj) {
    DateTime now = DateTime.now();
    developer.log(
      "⚠️ $msj",
      name: "WARNING",
      time: DateTime(now.hour, now.minute, now.second, now.millisecond),
    );
  }

  static void error(String msj) {
    DateTime now = DateTime.now();
    developer.log(
      "⛔ $msj",
      name: "ERROR",
      time: DateTime(now.hour, now.minute, now.second, now.millisecond),
    );
  }
}
