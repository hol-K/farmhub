import 'package:flutter/material.dart';

import '../../../core/constants/app_texts.dart';
import '../../../core/theme/app_theme.dart';

class SyncBadge extends StatelessWidget {
  const SyncBadge({super.key, required this.pending});

  final bool pending;

  @override
  Widget build(BuildContext context) {
    final color = pending ? AppTheme.pending : AppTheme.published;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        pending ? AppTexts.syncPending : AppTexts.syncPublished,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppTheme.offline,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: const Row(
        children: [
          Icon(Icons.cloud_off, color: Colors.white, size: 20),
          SizedBox(width: 8),
          Text(
            AppTexts.offline,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
