// Small helpers shared by the screens. Kept plain on purpose.

/// Parses dates written like '10 October 2026' (the format the app uses).
DateTime? parseDisplayDate(String text) {
  const months = {
    'January': 1,
    'February': 2,
    'March': 3,
    'April': 4,
    'May': 5,
    'June': 6,
    'July': 7,
    'August': 8,
    'September': 9,
    'October': 10,
    'November': 11,
    'December': 12,
  };
  final parts = text.trim().split(' ');
  if (parts.length != 3) return null;
  final day = int.tryParse(parts[0]);
  final month = months[parts[1]];
  final year = int.tryParse(parts[2]);
  if (day == null || month == null || year == null) return null;
  return DateTime(year, month, day);
}

/// 178000 -> 'Rs. 178,000'
String formatRs(double amount) {
  final whole = amount.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    if (i > 0 && (whole.length - i) % 3 == 0) buffer.write(',');
    buffer.write(whole[i]);
  }
  return 'Rs. ${buffer.toString()}';
}
