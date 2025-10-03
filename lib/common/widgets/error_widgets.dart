import 'package:flutter/material.dart';
import '../theme/tokens.dart';
import '../../data/failures.dart';

/// Reusable error widget for displaying failures
class AppErrorWidget extends StatelessWidget {
  const AppErrorWidget({
    super.key,
    required this.failure,
    this.onRetry,
    this.showRetryButton = true,
  });

  final Failure failure;
  final VoidCallback? onRetry;
  final bool showRetryButton;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.all(AppTokens.spacingL),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTokens.radiusM),
        border: Border.all(
          color: theme.colorScheme.error.withOpacity(0.3),
          width: 1.0,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _getErrorIcon(failure),
            color: theme.colorScheme.error,
            size: 32.0,
          ),
          const SizedBox(height: AppTokens.spacingM),
          Text(
            _getErrorTitle(failure),
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.error,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTokens.spacingS),
          Text(
            failure.message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          if (showRetryButton && onRetry != null) ...[
            const SizedBox(height: AppTokens.spacingL),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.error,
                foregroundColor: theme.colorScheme.onError,
              ),
            ),
          ],
        ],
      ),
    );
  }

  IconData _getErrorIcon(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return Icons.wifi_off;
      case AuthFailure:
        return Icons.lock;
      case ValidationFailure:
        return Icons.warning;
      case StorageFailure:
        return Icons.storage;
      case ServerFailure:
        return Icons.error;
      case NotFoundFailure:
        return Icons.search_off;
      case PermissionFailure:
        return Icons.block;
      default:
        return Icons.error_outline;
    }
  }

  String _getErrorTitle(Failure failure) {
    switch (failure.runtimeType) {
      case NetworkFailure:
        return 'Connection Error';
      case AuthFailure:
        return 'Authentication Error';
      case ValidationFailure:
        return 'Validation Error';
      case StorageFailure:
        return 'Storage Error';
      case ServerFailure:
        return 'Server Error';
      case NotFoundFailure:
        return 'Not Found';
      case PermissionFailure:
        return 'Permission Denied';
      default:
        return 'Error';
    }
  }
}

/// Compact error widget for inline error display
class CompactErrorWidget extends StatelessWidget {
  const CompactErrorWidget({
    super.key,
    required this.failure,
    this.onRetry,
  });

  final Failure failure;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTokens.spacingM,
        vertical: AppTokens.spacingS,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.errorContainer.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppTokens.radiusS),
        border: Border.all(
          color: theme.colorScheme.error.withOpacity(0.3),
          width: 1.0,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline,
            color: theme.colorScheme.error,
            size: 16.0,
          ),
          const SizedBox(width: AppTokens.spacingS),
          Expanded(
            child: Text(
              failure.message,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: AppTokens.spacingS),
            IconButton(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              iconSize: 16.0,
              color: theme.colorScheme.error,
              constraints: const BoxConstraints(
                minWidth: 24.0,
                minHeight: 24.0,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Error snackbar helper
class ErrorSnackbar {
  static void show(
    BuildContext context,
    Failure failure, {
    Duration duration = const Duration(seconds: 4),
  }) {
    final theme = Theme.of(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: theme.colorScheme.onError,
              size: 20.0,
            ),
            const SizedBox(width: AppTokens.spacingS),
            Expanded(
              child: Text(
                failure.message,
                style: TextStyle(
                  color: theme.colorScheme.onError,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: theme.colorScheme.error,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusS),
        ),
      ),
    );
  }
}

/// Success snackbar helper
class SuccessSnackbar {
  static void show(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    final theme = Theme.of(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.check_circle_outline,
              color: theme.colorScheme.onPrimary,
              size: 20.0,
            ),
            const SizedBox(width: AppTokens.spacingS),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: theme.colorScheme.primary,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTokens.radiusS),
        ),
      ),
    );
  }
}
