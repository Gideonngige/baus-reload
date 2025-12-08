import 'package:intl/intl.dart';

String formatDate(String? dateString) {
  if (dateString == null || dateString.isEmpty) return "";

  try {
    DateTime date = DateTime.parse(dateString).toLocal();
    return DateFormat('MMM d, yyyy • h:mm a').format(date);
  } catch (e) {
    return dateString; // fallback if parsing fails
  }
}
