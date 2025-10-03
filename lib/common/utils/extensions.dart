import 'package:flutter/material.dart';

/// Extension for BuildContext to provide easy access to theme and media query
extension BuildContextExtension on BuildContext {
  /// Get the current theme
  ThemeData get theme => Theme.of(this);
  
  /// Get the current color scheme
  ColorScheme get colorScheme => theme.colorScheme;
  
  /// Get the current text theme
  TextTheme get textTheme => theme.textTheme;
  
  /// Get the current media query
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  
  /// Get the current screen size
  Size get screenSize => mediaQuery.size;
  
  /// Get the current screen width
  double get screenWidth => screenSize.width;
  
  /// Get the current screen height
  double get screenHeight => screenSize.height;
  
  /// Check if the screen is mobile size
  bool get isMobile => screenWidth < 600;
  
  /// Check if the screen is tablet size
  bool get isTablet => screenWidth >= 600 && screenWidth < 900;
  
  /// Check if the screen is desktop size
  bool get isDesktop => screenWidth >= 900;
  
  /// Get responsive padding based on screen size
  EdgeInsets get responsivePadding {
    if (isMobile) {
      return const EdgeInsets.all(16.0);
    } else if (isTablet) {
      return const EdgeInsets.all(24.0);
    } else {
      return const EdgeInsets.all(32.0);
    }
  }
  
  /// Get responsive font size multiplier
  double get responsiveFontSize {
    if (isMobile) {
      return 1.0;
    } else if (isTablet) {
      return 1.1;
    } else {
      return 1.2;
    }
  }
}

/// Extension for String to provide utility methods
extension StringExtension on String {
  /// Capitalize the first letter of the string
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
  
  /// Capitalize the first letter of each word
  String get capitalizeWords {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }
  
  /// Check if the string is a valid email
  bool get isValidEmail {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  }
  
  /// Check if the string is a valid username (alphanumeric + underscore)
  bool get isValidUsername {
    return RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(this);
  }
  
  /// Truncate string to specified length with ellipsis
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }
}

/// Extension for int to provide utility methods
extension IntExtension on int {
  /// Format number with commas (e.g., 1000 -> "1,000")
  String get formatted {
    return toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match match) => '${match[1]},',
    );
  }
  
  /// Convert seconds to human readable duration
  String get durationString {
    if (this < 60) {
      return '${this}s';
    } else if (this < 3600) {
      final minutes = this ~/ 60;
      final seconds = this % 60;
      return seconds > 0 ? '${minutes}m ${seconds}s' : '${minutes}m';
    } else {
      final hours = this ~/ 3600;
      final minutes = (this % 3600) ~/ 60;
      return minutes > 0 ? '${hours}h ${minutes}m' : '${hours}h';
    }
  }
  
  /// Clamp the value between min and max
  int clamp(int min, int max) {
    if (this < min) return min;
    if (this > max) return max;
    return this;
  }
}

/// Extension for double to provide utility methods
extension DoubleExtension on double {
  /// Round to specified decimal places
  double roundTo(int places) {
    final factor = 10.0 * places;
    return (this * factor).round() / factor;
  }
  
  /// Convert to percentage string
  String get percentageString {
    return '${(this * 100).round()}%';
  }
  
  /// Clamp the value between min and max
  double clamp(double min, double max) {
    if (this < min) return min;
    if (this > max) return max;
    return this;
  }
}

/// Extension for List to provide utility methods
extension ListExtension<T> on List<T> {
  /// Get a random element from the list
  T? get random {
    if (isEmpty) return null;
    return this[DateTime.now().millisecondsSinceEpoch % length];
  }
  
  /// Get the first element or null if empty
  T? get firstOrNull => isEmpty ? null : first;
  
  /// Get the last element or null if empty
  T? get lastOrNull => isEmpty ? null : last;
  
  /// Check if the list is not empty
  bool get isNotEmpty => !isEmpty;
}

/// Extension for DateTime to provide utility methods
extension DateTimeExtension on DateTime {
  /// Get time ago string (e.g., "2 hours ago")
  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(this);
    
    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
  
  /// Check if the date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
  
  /// Check if the date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }
}
