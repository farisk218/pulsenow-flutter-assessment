import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/theme/constant/pulse_now_colors.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({
    super.key,
    this.width,
    this.height,
    this.radius = 8,
  });

  final double? width;
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Blue-tinted shimmer colors based on theme
    final baseColor = isDark
        ? PulseNowColors.primary.withOpacity(0.15) // Dark theme: subtle blue base
        : PulseNowColors.primary.withOpacity(0.08); // Light theme: very subtle blue base

    final highlightColor = isDark
        ? PulseNowColors.primary.withOpacity(0.3) // Dark theme: brighter blue highlight
        : PulseNowColors.primary.withOpacity(0.2); // Light theme: subtle blue highlight

    final containerColor = isDark
        ? PulseNowColors.darkSurface // Dark theme: use dark surface color
        : PulseNowColors.lightSurface; // Light theme: use light surface color

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Shimmer.fromColors(
        baseColor: baseColor,
        highlightColor: highlightColor,
        child: Container(
          width: width ?? double.infinity,
          height: height ?? double.infinity,
          decoration: BoxDecoration(
            color: containerColor,
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
      ),
    );
  }
}
