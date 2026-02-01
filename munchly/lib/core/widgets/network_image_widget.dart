import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Network image widget with CORS error handling and fallback
class NetworkImageWidget extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;

  const NetworkImageWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
  });

  /// Validates and processes the image URL
  String? _processImageUrl(String url) {
    if (url.isEmpty) return null;

    // Trim whitespace
    final trimmedUrl = url.trim();

    // Check if it's a valid URL
    if (!trimmedUrl.startsWith('http://') && !trimmedUrl.startsWith('https://')) {
      return null;
    }

    return trimmedUrl;
  }

  @override
  Widget build(BuildContext context) {
    final processedUrl = _processImageUrl(imageUrl);

    // If URL is empty or invalid, show placeholder immediately
    if (processedUrl == null) {
      return _buildPlaceholder();
    }

    Widget imageWidget = Image.network(
      processedUrl,
      width: width,
      height: height,
      fit: fit,
      // Add headers for better compatibility
      headers: kIsWeb ? null : const {'Accept': 'image/*'},
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return _buildLoadingIndicator(loadingProgress);
      },
      errorBuilder: (context, error, stackTrace) {
        // CORS and other errors are handled here
        debugPrint('Image load error for $processedUrl: $error');
        return _buildPlaceholder();
      },
    );

    if (borderRadius != null) {
      return ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  Widget _buildLoadingIndicator(ImageChunkEvent loadingProgress) {
    final progress = loadingProgress.expectedTotalBytes != null
        ? loadingProgress.cumulativeBytesLoaded /
            loadingProgress.expectedTotalBytes!
        : null;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withOpacity(0.1),
            AppTheme.secondaryColor.withOpacity(0.1),
          ],
        ),
      ),
      child: Center(
        child: CircularProgressIndicator(
          value: progress,
          strokeWidth: 2,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.primaryColor.withOpacity(0.2),
            AppTheme.secondaryColor.withOpacity(0.2),
          ],
        ),
      ),
      child: Icon(
        Icons.restaurant,
        size: (height ?? 100) * 0.4,
        color: AppTheme.primaryColor.withOpacity(0.4),
      ),
    );
  }
}

/// Restaurant card image with specific styling
class RestaurantCardImage extends StatelessWidget {
  final String imageUrl;
  final double height;

  const RestaurantCardImage({
    super.key,
    required this.imageUrl,
    this.height = 200,
  });

  @override
  Widget build(BuildContext context) {
    return NetworkImageWidget(
      imageUrl: imageUrl,
      height: height,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}

/// Restaurant detail header image
class RestaurantDetailImage extends StatelessWidget {
  final String imageUrl;

  const RestaurantDetailImage({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return NetworkImageWidget(
      imageUrl: imageUrl,
      fit: BoxFit.cover,
    );
  }
}
