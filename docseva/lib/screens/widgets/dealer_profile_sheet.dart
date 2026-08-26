import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:docusewa/models/service_dealer.dart';
import 'package:docusewa/screens/home_screen.dart' show ServiceData;
import 'package:docusewa/screens/widgets/assisted_booking_sheet.dart';
import 'package:docusewa/services/user_location_service.dart';
import 'package:docusewa/theme/app_colors.dart';

/// Full detail modal sheet for a verified service dealer
class DealerProfileSheet extends StatelessWidget {
  final ServiceDealer dealer;
  final ServiceData? currentService;

  const DealerProfileSheet({
    super.key,
    required this.dealer,
    this.currentService,
  });

  static Future<void> show(
    BuildContext context, {
    required ServiceDealer dealer,
    ServiceData? currentService,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DealerProfileSheet(
        dealer: dealer,
        currentService: currentService,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentLoc = UserLocationService.currentLocation.value;
    final distanceKm = UserLocationService.calculateDistanceKm(
      currentLoc.latitude,
      currentLoc.longitude,
      dealer.latitude,
      dealer.longitude,
    );

    final distFormatted = distanceKm < 1.0
        ? '${(distanceKm * 1000).toInt()} m away'
        : '${distanceKm.toStringAsFixed(1)} km away';

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface(isDark),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.tealSubtle),
      ),
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 36,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.border(isDark),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Verified Provider Banner
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF042F2E), const Color(0xFF0F766E).withValues(alpha: 0.3)]
                      : [const Color(0xFFF0FDFA), const Color(0xFFCCFBF1).withValues(alpha: 0.5)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? const Color(0xFF115E59) : const Color(0xFF99F6E4),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: AppColors.tealPrimary,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.tealPrimary.withValues(alpha: 0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.verified_user_rounded, color: Colors.white, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDCFCE7),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: const [
                                      Icon(Icons.check_circle_rounded, size: 11, color: Color(0xFF16A34A)),
                                      SizedBox(width: 3),
                                      Text(
                                        'GOVT AUTHORIZED',
                                        style: TextStyle(
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w800,
                                          color: Color(0xFF16A34A),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: dealer.isCurrentlyActive
                                        ? const Color(0xFFDCFCE7)
                                        : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: dealer.isCurrentlyActive
                                              ? const Color(0xFF16A34A)
                                              : Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        dealer.isCurrentlyActive ? 'OPEN NOW' : 'CLOSED NOW',
                                        style: TextStyle(
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w700,
                                          color: dealer.isCurrentlyActive
                                              ? const Color(0xFF16A34A)
                                              : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              dealer.name,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary(isDark),
                                height: 1.25,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${dealer.operatorName} • ${dealer.authCertNumber}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                color: AppColors.tealPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Performance Specs Grid
            Row(
              children: [
                _buildStatBox(
                  context,
                  isDark: isDark,
                  icon: Icons.star_rounded,
                  iconColor: const Color(0xFFF59E0B),
                  title: '${dealer.rating.toStringAsFixed(1)} ★',
                  subtitle: '${dealer.reviewCount} Reviews',
                ),
                const SizedBox(width: 8),
                _buildStatBox(
                  context,
                  isDark: isDark,
                  icon: Icons.near_me_rounded,
                  iconColor: AppColors.tealPrimary,
                  title: distFormatted,
                  subtitle: 'From your location',
                ),
                const SizedBox(width: 8),
                _buildStatBox(
                  context,
                  isDark: isDark,
                  icon: Icons.flash_on_rounded,
                  iconColor: const Color(0xFF10B981),
                  title: '~${dealer.avgResponseMinutes} Mins',
                  subtitle: 'Avg Response',
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildStatBox(
                  context,
                  isDark: isDark,
                  icon: Icons.task_alt_rounded,
                  iconColor: AppColors.tealPrimary,
                  title: '${dealer.totalServicesCompleted}+',
                  subtitle: 'Completed Requests',
                ),
                const SizedBox(width: 8),
                _buildStatBox(
                  context,
                  isDark: isDark,
                  icon: Icons.shield_rounded,
                  iconColor: const Color(0xFF16A34A),
                  title: '${dealer.reliabilityScore}%',
                  subtitle: 'Reliability Score',
                ),
                const SizedBox(width: 8),
                _buildStatBox(
                  context,
                  isDark: isDark,
                  icon: Icons.cancel_outlined,
                  iconColor: const Color(0xFF0F766E),
                  title: '${dealer.cancellationRate}%',
                  subtitle: 'Cancellation Rate',
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Address and Contact
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border(isDark)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.location_on_outlined, size: 18, color: AppColors.tealPrimary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Center Address',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textMuted(isDark),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              dealer.address,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary(isDark),
                              ),
                            ),
                            Text(
                              '${dealer.locality}, ${dealer.city}, ${dealer.state} - ${dealer.pincode}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                color: AppColors.textSecondary(isDark),
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.copy_rounded, size: 16, color: AppColors.tealPrimary),
                        onPressed: () {
                          Clipboard.setData(ClipboardData(text: '${dealer.name}, ${dealer.address}'));
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text('Address copied to clipboard'),
                              backgroundColor: AppColors.tealPrimary,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  const Divider(height: 18),
                  Row(
                    children: [
                      const Icon(Icons.schedule_rounded, size: 16, color: AppColors.tealPrimary),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          dealer.workingHours,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary(isDark),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),

            // Document Safety & Compliance Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF064E3B).withValues(alpha: 0.3) : const Color(0xFFECFDF5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDark ? const Color(0xFF059669) : const Color(0xFFA7F3D0),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.lock_person_rounded, size: 22, color: Color(0xFF10B981)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Zero Document Retention Policy',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: isDark ? const Color(0xFF34D399) : const Color(0xFF065F46),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Citizen documents are processed with 256-bit encryption. Center is strictly audited under MeitY e-Governance standards.',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5,
                            color: isDark ? Colors.white70 : const Color(0xFF047857),
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final uri = Uri.parse('tel:${dealer.phone.replaceAll(' ', '')}');
                      try {
                        await launchUrl(uri);
                      } catch (_) {}
                    },
                    icon: const Icon(Icons.call_rounded, size: 16),
                    label: Text(
                      'Direct Call',
                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13),
                    ),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.tealPrimary,
                      side: const BorderSide(color: AppColors.tealPrimary),
                      minimumSize: const Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (currentService != null) {
                        AssistedBookingSheet.show(
                          context,
                          dealer: dealer,
                          service: currentService!,
                        );
                      }
                    },
                    icon: const Icon(Icons.send_rounded, size: 16, color: Colors.white),
                    label: Text(
                      'Book Assisted Service',
                      style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 13, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.tealPrimary,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBox(
    BuildContext context, {
    required bool isDark,
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border(isDark)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, size: 14, color: iconColor),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    title,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary(isDark),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              subtitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 9.5,
                color: AppColors.textMuted(isDark),
                fontWeight: FontWeight.w600,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
