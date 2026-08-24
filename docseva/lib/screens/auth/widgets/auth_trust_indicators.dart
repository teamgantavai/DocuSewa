import 'package:flutter/material.dart';
import 'package:docusewa/theme/app_colors.dart';

/// Three subtle trust indicators shown on the auth hero panel.
class AuthTrustIndicators extends StatelessWidget {
  final bool light; // true = white text (hero panel), false = dark text (card)

  const AuthTrustIndicators({super.key, this.light = true});

  @override
  Widget build(BuildContext context) {
    final textColor = light ? Colors.white : AppColors.deepNavy;
    final subColor =
        light ? AppColors.withAlpha(Colors.white, 0.7) : AppColors.textGrey;
    final iconColor =
        light ? AppColors.withAlpha(Colors.white, 0.9) : AppColors.secureGreen;

    return Column(
      crossAxisAlignment:
          light ? CrossAxisAlignment.start : CrossAxisAlignment.center,
      children: [
        _TrustItem(
          icon: Icons.lock_outline_rounded,
          title: 'Secure & Private',
          subtitle: 'Your data is encrypted end-to-end',
          textColor: textColor,
          subColor: subColor,
          iconColor: iconColor,
          light: light,
        ),
        const SizedBox(height: 16),
        _TrustItem(
          icon: Icons.verified_user_outlined,
          title: 'Verified Service Providers',
          subtitle: 'Only government-approved providers',
          textColor: textColor,
          subColor: subColor,
          iconColor: iconColor,
          light: light,
        ),
        const SizedBox(height: 16),
        _TrustItem(
          icon: Icons.track_changes_rounded,
          title: 'Transparent Tracking',
          subtitle: 'Monitor every service request',
          textColor: textColor,
          subColor: subColor,
          iconColor: iconColor,
          light: light,
        ),
      ],
    );
  }
}

class _TrustItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color textColor;
  final Color subColor;
  final Color iconColor;
  final bool light;

  const _TrustItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.textColor,
    required this.subColor,
    required this.iconColor,
    required this.light,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: light
                ? AppColors.withAlpha(Colors.white, 0.12)
                : AppColors.withAlpha(AppColors.secureGreen, 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, size: 18, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: subColor,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
