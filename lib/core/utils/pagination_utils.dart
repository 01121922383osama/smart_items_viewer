class PaginationUtils {
  static const int defaultLimit = 20;
  static const double loadMoreThreshold = 0.7; // Load more when 70% scrolled
  
  static bool shouldLoadMore({
    required double scrollPosition,
    required double maxScrollExtent,
  }) {
    if (maxScrollExtent <= 0) return false;
    
    final scrollPercentage = scrollPosition / maxScrollExtent;
    return scrollPercentage >= loadMoreThreshold;
  }
  
  static int calculateSkip(int page, int limit) {
    return (page - 1) * limit;
  }
  
  static int calculatePage(int skip, int limit) {
    return (skip ~/ limit) + 1;
  }
}
