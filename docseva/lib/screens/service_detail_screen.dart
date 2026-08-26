import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:docusewa/config/translations.dart';
import 'package:docusewa/config/vault_state.dart';
import 'package:docusewa/models/service_dealer.dart';
import 'package:docusewa/models/vault_doc.dart';
import 'package:docusewa/screens/home_screen.dart' show ServiceData;
import 'package:docusewa/screens/widgets/assisted_booking_sheet.dart';
import 'package:docusewa/screens/widgets/dealer_directory_modal.dart';
import 'package:docusewa/screens/widgets/location_picker_sheet.dart';
import 'package:docusewa/services/dealer_recommendation_service.dart';
import 'package:docusewa/services/user_location_service.dart';
import 'package:docusewa/theme/app_colors.dart';

/// Ultra-Premium, Modern & Trustworthy Service Hub
class ServiceDetailScreen extends StatefulWidget {
  final ServiceData service;
  final VoidCallback? onOpenVault;

  const ServiceDetailScreen({
    super.key,
    required this.service,
    this.onOpenVault,
  });

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  int _selectedTab = 0; // 0: Verified Centers, 1: Requirements, 2: Application Flow
  ServiceDealer? _selectedDealer;
  bool _isImporting = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final langCode = appLanguageNotifier.value;
    final service = widget.service;
    final serviceName = ServiceTranslator.getServiceName(service.id, langCode);
    final serviceDoc = ServiceTranslator.getServiceDoc(service.id, langCode);

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF070B14) : const Color(0xFFF6F8FA),
      appBar: AppBar(
        backgroundColor: isDark ? const Color(0xFF0E1626) : Colors.white,
        elevation: 0,
        scrolledUnderElevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.05),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: AppColors.textPrimary(isDark),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              serviceName,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary(isDark),
                letterSpacing: -0.2,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              'Official Citizen Service • ${service.state}',
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                color: AppColors.textMuted(isDark),
              ),
            ),
          ],
        ),
        actions: [
          // Location Picker Floating Chip
          ValueListenableBuilder<UserLocation>(
            valueListenable: UserLocationService.currentLocation,
            builder: (context, loc, _) {
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: InkWell(
                  onTap: () => LocationPickerSheet.show(context),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF192438) : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? const Color(0xFF283853) : const Color(0xFFE2E8F0),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.near_me_rounded, size: 12, color: AppColors.tealPrimary),
                        const SizedBox(width: 4),
                        Text(
                          loc.locality,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary(isDark),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(width: 2),
                        Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: AppColors.textMuted(isDark)),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // ── 1. LUXURY GLASS EMBLEM HEADER ─────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF0E1626), const Color(0xFF0B1322)]
                    : [Colors.white, const Color(0xFFFAFCFD)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border(
                bottom: BorderSide(
                  color: isDark ? const Color(0xFF192438) : const Color(0xFFE8ECEF),
                ),
              ),
            ),
            child: Row(
              children: [
                // Floating Emblem Avatar with Ambient Glow
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0D9488).withValues(alpha: 0.28),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Text(service.iconEmoji, style: const TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        serviceDoc,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary(isDark),
                          letterSpacing: -0.3,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: const [
                                Icon(Icons.verified_rounded, size: 11, color: Color(0xFF16A34A)),
                                SizedBox(width: 3),
                                Text(
                                  'GOVT CERTIFIED',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF16A34A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: Text(
                              service.price.contains('Free') || service.price.contains('₹0')
                                  ? '₹0 Official Fee'
                                  : 'Nominal Fee',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: isDark ? const Color(0xFF5EEAD4) : const Color(0xFF0F766E),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── 2. VIBRANT MODERN TAB CHIPS ───────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            color: isDark ? const Color(0xFF070B14) : const Color(0xFFF6F8FA),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildModernTabChip(
                    index: 0,
                    title: 'Verified Centers',
                    icon: Icons.storefront_rounded,
                    badgeText: '⭐ Best Match',
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _buildModernTabChip(
                    index: 1,
                    title: 'Required Docs',
                    icon: Icons.folder_shared_rounded,
                    badgeText: '${service.requiredDocs.length} Docs',
                    isDark: isDark,
                  ),
                  const SizedBox(width: 8),
                  _buildModernTabChip(
                    index: 2,
                    title: 'Application Flow',
                    icon: Icons.alt_route_rounded,
                    badgeText: '${service.procedure.length} Steps',
                    isDark: isDark,
                  ),
                ],
              ),
            ),
          ),

          // ── 3. TAB VIEW BODY ───────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 95),
              child: _selectedTab == 0
                  ? _buildCentersTab(service, isDark)
                  : _selectedTab == 1
                      ? _buildDocsTab(service, langCode, isDark)
                      : _buildStepsTab(service, isDark),
            ),
          ),
        ],
      ),

      // ── 4. FLOATING ACTION DOCK ───────────────────────────────────────────
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0E1626) : Colors.white,
          border: Border(
            top: BorderSide(
              color: isDark ? const Color(0xFF192438) : const Color(0xFFE8ECEF),
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.06),
              blurRadius: 12,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Direct Portal Outlined Button
              OutlinedButton(
                onPressed: () async {
                  final uri = Uri.parse(service.portalUrl);
                  try {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } catch (_) {}
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary(isDark),
                  side: BorderSide(color: isDark ? const Color(0xFF283853) : const Color(0xFFD1D9E0)),
                  minimumSize: const Size(44, 44),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.language_rounded, size: 15),
                    SizedBox(width: 5),
                    Text('Portal ↗', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5)),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // Primary Apply via Verified Center Button
              Expanded(
                child: Container(
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF0D9488).withValues(alpha: 0.35),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final currentLoc = UserLocationService.currentLocation.value;
                      final recs = DealerRecommendationService.instance.getRecommendationsForService(
                        service: service,
                        location: currentLoc,
                      );
                      final dealerToBook = _selectedDealer ?? (recs.isNotEmpty ? recs.first.dealer : null);
                      if (dealerToBook != null) {
                        AssistedBookingSheet.show(
                          context,
                          dealer: dealerToBook,
                          service: service,
                        );
                      }
                    },
                    icon: const Icon(Icons.verified_user_rounded, size: 16, color: Colors.white),
                    label: Text(
                      'Apply with Verified Center',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── TAB 1: VERIFIED SERVICE PROVIDERS ──────────────────────────────────────
  Widget _buildCentersTab(ServiceData service, bool isDark) {
    return ValueListenableBuilder<UserLocation>(
      valueListenable: UserLocationService.currentLocation,
      builder: (context, userLoc, _) {
        final recs = DealerRecommendationService.instance.getRecommendationsForService(
          service: service,
          location: userLoc,
        );

        if (recs.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                'No verified centers found near ${userLoc.locality}.',
                style: GoogleFonts.plusJakartaSans(color: AppColors.textMuted(isDark)),
              ),
            ),
          );
        }

        final heroRec = _selectedDealer != null
            ? recs.firstWhere((r) => r.dealer.id == _selectedDealer!.id, orElse: () => recs.first)
            : recs.first;

        final heroDealer = heroRec.dealer;
        final alternatives = recs.where((r) => r.dealer.id != heroDealer.id).take(3).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Section Tag
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AppColors.tealPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.star_rounded, size: 11, color: Colors.white),
                ),
                const SizedBox(width: 6),
                Text(
                  'TOP VERIFIED MATCH NEAR YOU',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.7,
                    color: isDark ? const Color(0xFF2DD4BF) : const Color(0xFF0F766E),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '${heroRec.smartScore.toStringAsFixed(0)}% MATCH',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w800,
                      color: const Color(0xFF16A34A),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Hero Provider Luxury Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0E1626) : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? const Color(0xFF0D9488).withValues(alpha: 0.4) : const Color(0xFF99F6E4),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF0D9488).withValues(alpha: isDark ? 0.2 : 0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Center Title & Status
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.tealPrimary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.verified_user_rounded, color: AppColors.tealPrimary, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    heroDealer.name,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary(isDark),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFDCFCE7),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Text(
                                    'ACTIVE NOW',
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF16A34A),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              '${heroDealer.operatorName} • ${heroDealer.authCertNumber}',
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
                  const SizedBox(height: 14),

                  // 4 Floating Metric Pods
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 9, horizontal: 8),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF141E30) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: isDark ? const Color(0xFF223049) : const Color(0xFFE8ECEF)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildMetricTile(
                          label: 'Distance',
                          value: heroRec.distanceKm < 1.0
                              ? '${(heroRec.distanceKm * 1000).toInt()}m'
                              : '${heroRec.distanceKm.toStringAsFixed(1)} km',
                          isDark: isDark,
                        ),
                        _buildMetricDivider(isDark),
                        _buildMetricTile(
                          label: 'Rating',
                          value: '${heroDealer.rating.toStringAsFixed(1)}★',
                          isDark: isDark,
                        ),
                        _buildMetricDivider(isDark),
                        _buildMetricTile(
                          label: 'Response',
                          value: '~${heroDealer.avgResponseMinutes}m',
                          isDark: isDark,
                        ),
                        _buildMetricDivider(isDark),
                        _buildMetricTile(
                          label: 'Regulated Fee',
                          value: '₹${heroDealer.getFeeForService(service.id)}',
                          isDark: isDark,
                          isTeal: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Reason Ribbon
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF042F2E).withValues(alpha: 0.5) : const Color(0xFFF0FDFA),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: isDark ? const Color(0xFF0D9488).withValues(alpha: 0.3) : const Color(0xFFCCFBF1),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.shield_rounded, size: 14, color: AppColors.tealPrimary),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            heroRec.primaryReason,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFFCCFBF1) : const Color(0xFF0F766E),
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Action Buttons Row
                  Row(
                    children: [
                      OutlinedButton(
                        onPressed: () async {
                          final uri = Uri.parse('tel:${heroDealer.phone.replaceAll(' ', '')}');
                          try {
                            await launchUrl(uri);
                          } catch (_) {}
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.tealPrimary,
                          side: BorderSide(color: isDark ? const Color(0xFF283853) : const Color(0xFFD1D9E0)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          minimumSize: const Size(0, 38),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.call_rounded, size: 15),
                            SizedBox(width: 4),
                            Text('Call Center', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            AssistedBookingSheet.show(
                              context,
                              dealer: heroDealer,
                              service: service,
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.tealPrimary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            minimumSize: const Size(0, 38),
                            elevation: 0,
                          ),
                          child: Text(
                            'Book Assistance (₹${heroDealer.getFeeForService(service.id)})',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Alternative Providers Section
            if (alternatives.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'OTHER NEARBY VERIFIED CENTERS',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.6,
                      color: AppColors.textMuted(isDark),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      DealerDirectoryModal.show(
                        context,
                        service: service,
                        onSelectDealer: (d) => setState(() => _selectedDealer = d),
                      );
                    },
                    child: Text(
                      'View All (${recs.length}) ↗',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.tealPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              ...alternatives.map((alt) {
                final altDealer = alt.dealer;
                final altDist = alt.distanceKm < 1.0
                    ? '${(alt.distanceKm * 1000).toInt()}m'
                    : '${alt.distanceKm.toStringAsFixed(1)} km';

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0E1626) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? const Color(0xFF192438) : const Color(0xFFE8ECEF),
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              altDealer.name,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary(isDark),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '$altDist • ${altDealer.rating.toStringAsFixed(1)}★ • ₹${altDealer.getFeeForService(service.id)} fee',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                color: AppColors.textMuted(isDark),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      InkWell(
                        onTap: () => setState(() => _selectedDealer = altDealer),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.tealPrimary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'Choose',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: AppColors.tealPrimary,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          ],
        );
      },
    );
  }

  // ── TAB 2: REQUIRED DOCUMENTS & VAULT SYNC ─────────────────────────────────
  Widget _buildDocsTab(ServiceData service, String langCode, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Vault Sync Action Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0E1626) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: isDark ? const Color(0xFF192438) : const Color(0xFFE8ECEF)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.tealPrimary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.folder_special_rounded, color: AppColors.tealPrimary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Store in DigiLocker Vault',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary(isDark),
                      ),
                    ),
                    Text(
                      'Instant one-tap digital pass import',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        color: AppColors.textMuted(isDark),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: _isImporting
                    ? null
                    : () {
                        final messenger = ScaffoldMessenger.of(context);
                        setState(() => _isImporting = true);
                        Future.delayed(const Duration(milliseconds: 600), () {
                          if (mounted) {
                            final newVaultDoc = VaultDoc(
                              id: 'v-${DateTime.now().millisecondsSinceEpoch}',
                              title: ServiceTranslator.getServiceDoc(service.id, langCode),
                              category: service.category == 'finance' ? 'finance' : 'identity',
                              issuer: ServiceTranslator.getServiceName(service.id, langCode),
                              docNumber: 'DOC-${100000 + (DateTime.now().millisecond * 800) % 900000}',
                              issueDate: 'Issued Just Now',
                              isVerified: true,
                              logoType: service.logoType,
                              storageSource: 'gov_import',
                              fileName: '${service.id}_pass.pdf',
                              fileSize: '1.1 MB',
                              createdAt: DateTime.now(),
                            );
                            VaultState.addDocument(newVaultDoc);
                            setState(() => _isImporting = false);
                            messenger.showSnackBar(
                              SnackBar(
                                content: const Text('Document added to Vault!'),
                                backgroundColor: const Color(0xFF10B981),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            );
                          }
                        });
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tealPrimary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 32),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: _isImporting
                    ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Import', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Text(
          'CHECKLIST OF REQUIRED DOCUMENTS',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
            color: AppColors.textMuted(isDark),
          ),
        ),
        const SizedBox(height: 8),

        ...service.requiredDocs.map(
          (doc) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0E1626) : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? const Color(0xFF192438) : const Color(0xFFE8ECEF)),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle_rounded, size: 18, color: Color(0xFF10B981)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    ServiceTranslator.getRequiredDoc(doc, langCode),
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary(isDark),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ── TAB 3: STEP-BY-STEP PROCEDURE & OFFICIAL PORTAL ────────────────────────
  Widget _buildStepsTab(ServiceData service, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Official Portal Link
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0E1626) : Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? const Color(0xFF192438) : const Color(0xFFE8ECEF)),
          ),
          child: Row(
            children: [
              const Icon(Icons.language_rounded, size: 20, color: AppColors.tealPrimary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Official Government Portal',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary(isDark),
                      ),
                    ),
                    Text(
                      service.portalDomain,
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.textMuted(isDark)),
                    ),
                  ],
                ),
              ),
              OutlinedButton(
                onPressed: () async {
                  final uri = Uri.parse(service.portalUrl);
                  try {
                    await launchUrl(uri, mode: LaunchMode.externalApplication);
                  } catch (_) {}
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.tealPrimary,
                  side: const BorderSide(color: AppColors.tealPrimary),
                  minimumSize: const Size(0, 32),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                ),
                child: const Text('Open ↗', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 11.5)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        Text(
          'STEP-BY-STEP APPLICATION FLOW',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.6,
            color: AppColors.textMuted(isDark),
          ),
        ),
        const SizedBox(height: 10),

        ...List.generate(service.procedure.length, (idx) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF0E1626) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: isDark ? const Color(0xFF192438) : const Color(0xFFE8ECEF)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 22,
                  height: 22,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.tealPrimary,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${idx + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    service.procedure[idx],
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      color: AppColors.textPrimary(isDark),
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildModernTabChip({
    required int index,
    required String title,
    required IconData icon,
    required String badgeText,
    required bool isDark,
  }) {
    final isSelected = _selectedTab == index;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [Color(0xFF0D9488), Color(0xFF0F766E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          color: isSelected
              ? null
              : (isDark ? const Color(0xFF0E1626) : Colors.white),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF14B8A6)
                : (isDark ? const Color(0xFF192438) : const Color(0xFFE8ECEF)),
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: const Color(0xFF0D9488).withValues(alpha: 0.35),
                blurRadius: 10,
                offset: const Offset(0, 3),
              )
            else
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.2)
                    : (isDark ? const Color(0xFF192438) : const Color(0xFFF1F5F9)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 14,
                color: isSelected ? Colors.white : AppColors.tealPrimary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textPrimary(isDark),
                letterSpacing: -0.2,
              ),
            ),
            const SizedBox(width: 7),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.white.withValues(alpha: 0.22)
                    : (isDark ? const Color(0xFF192438) : const Color(0xFFF1F5F9)),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                badgeText,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? const Color(0xFFCCFBF1) : AppColors.textMuted(isDark),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required bool isDark,
    bool isTeal = false,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: isTeal ? AppColors.tealPrimary : AppColors.textPrimary(isDark),
          ),
        ),
        const SizedBox(height: 1),
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 9.5,
            color: AppColors.textMuted(isDark),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricDivider(bool isDark) {
    return Container(
      width: 1,
      height: 20,
      color: isDark ? const Color(0xFF223049) : const Color(0xFFE8ECEF),
    );
  }
}
