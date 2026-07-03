import 'package:intl/intl.dart';

class DateTimeHelper {
  /// Formats a date string to "DD Month YYYY"
  /// Handles "DD/MM/YYYY" and "D Month YYYY" formats
  static String formatToLongDate(String dateStr) {
    if (dateStr.isEmpty) return "";
    
    try {
      DateTime? parsedDate;
      
      if (dateStr.contains('/')) {
        // Handle 05/04/2026
        parsedDate = DateFormat('dd/MM/yyyy').parse(dateStr);
      } else {
        // Handle 5 May 2026 or 05 May 2026
        // Try multiple formats for string dates
        List<String> formats = ['d MMM yyyy', 'dd MMM yyyy', 'd MMMM yyyy', 'dd MMMM yyyy'];
        for (String format in formats) {
          try {
            parsedDate = DateFormat(format).parse(dateStr);
            break;
          } catch (_) {}
        }
      }
      
      if (parsedDate != null) {
        return DateFormat('dd MMMM yyyy').format(parsedDate);
      }
    } catch (e) {
      print("Error parsing date: $dateStr -> $e");
    }
    
    return dateStr; // Return original if parsing fails
  }
}
