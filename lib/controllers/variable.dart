import 'dart:math';

class CurrentDate {
  static String getTime() {
    final now = DateTime.now();
    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final second = now.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }

  static String getDate() {
    final random = Random();
    int day = random.nextInt(30) + 1;
    int month = random.nextInt(12) + 1;
    int year = random.nextInt(5) + 2020;
    final months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '$day ${months[month - 1]} $year';
  }
}

class CurrentRandom {
  static int getIntRandom(int min, int max) {
    final random = Random();
    return random.nextInt(max - min + 1) + min;
  }

  static double getDoubleRandom(double min, double max) {
    final random = Random();
    return min + random.nextDouble() * (max - min);
  }
}
