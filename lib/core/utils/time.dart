class TimeUtils {
  static const Duration cacheTtl = Duration(minutes: 10);
  
  static bool isCacheExpired(DateTime? lastUpdated) {
    if (lastUpdated == null) return true;
    
    final now = DateTime.now();
    final difference = now.difference(lastUpdated);
    
    return difference > cacheTtl;
  }
  
  static DateTime now() => DateTime.now();
  
  static String toIsoString(DateTime dateTime) => dateTime.toIso8601String();
  
  static DateTime? fromIsoString(String? isoString) {
    if (isoString == null) return null;
    try {
      return DateTime.parse(isoString);
    } catch (e) {
      return null;
    }
  }
}
