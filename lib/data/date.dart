import 'dart:math';

class CurrentDate {
  static String getTime() {
    final random = Random();
    int hour = random.nextInt(24);
    int minute = random.nextInt(60);
    int second = random.nextInt(60);
    return '$hour:$minute:$second';
  }

  static String getDate() {
    final random = Random();
    int day = random.nextInt(30) + 1;
    int month = random.nextInt(12) + 1;
    int year = random.nextInt(5) + 2020;
    final months = [
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    return '$day ${months[month - 1]} $year';
  }

  static int getIntRandom(int min, int max) {
    final random = Random();
    return random.nextInt(max - min + 1) + min;
  }
}
