import 'package:intl/intl.dart';

/// Shared formatter for article dates coming from both the public API (Z suffix)
/// and Firebase (with milliseconds). Falls back to the raw value if parsing fails.
String formatArticleDate(String raw) {
  if (raw.isEmpty) return raw;
  final parsed = DateTime.tryParse(raw);
  if (parsed == null) return raw;
  return DateFormat('yyyy-MM-dd HH:mm').format(parsed);
}

