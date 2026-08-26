import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:docusewa/models/service_dealer.dart';
import 'package:docusewa/screens/home_screen.dart' show ServiceData;
import 'package:docusewa/screens/widgets/assisted_booking_sheet.dart';
import 'package:docusewa/screens/widgets/location_picker_sheet.dart';
import 'package:docusewa/services/dealer_recommendation_service.dart';
import 'package:docusewa/services/user_location_service.dart';
import 'package:docusewa/theme/app_colors.dart';

/// Clean, modern Recommended Dealer Widget for service screens
class RecommendedDealerCard extends StatefulWidget {
  final ServiceData service;
  final ServiceDealer? manuallySelectedDealer;
  final Function(ServiceDealer dealer)? onDealerChanged;

  const RecommendedDealerCard({
    super.key,
    required this.service,
    this.manuallySelectedDealer,
    this.onDealerChanged,
  });

  @override
  State<RecommendedDealerCard> createState() => _RecommendedDealerCardState();
}

class _RecommendedDealerCardState extends State<RecommendedDealerCard> {
  bool _showAlternatives = false;
  ServiceDealer? _selectedOverride;

  @override
  void initState() {
    super.initState();
    _selectedOverride = widget.manuallySelectedDealer;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<UserLocation>(
      valueListenable: UserLocationService.currentLocation,
      builder: (context, userLocation, _) {
        final recommendations = DealerRecommendationService.instance.getRecommendationsForService(
          service: widget.service,
          location: userLocation,
        );

        if (recommendations.isEmpty) {
          return const SizedBox.shrink();
        }

        final DealerRecommendation heroRec = _selectedOverride != null
            ? recommendations.firstWhere(
                (r) => r.dealer.id == _selectedOverride!.id,
                orElse: () => recommendations.first,
              )
            : recommendations.first;

        final isManualSelection = _selectedOverride != null && _selectedOverride!.id != recommendations.first.dealer.id;

        final alternativeRecs = recommendations
            .where((r) => r.dealer.id != heroRec.dealer.id)
            .take(3)
            .toList();

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF0F172A) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Clean Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  border: Border(
                    bottom: BorderSide(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.verified_user_rounded, size: 14, color: AppColors.tealPrimary),
                    const SizedBox(width: 6),
                    Text(
                      'VERIFIED PROVIDER ASSISTANCE',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.6,
                        color: AppColors.tealPrimary,
                      ),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () => LocationPickerSheet.show(context),
                      borderRadius: BorderRadius.circular(6),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.location_on_rounded, size: 12, color: AppColors.tealPrimary),
                          const SizedBox(width: 3),
                          Text(
                            userLocation.locality,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary(isDark),
                            ),
                          ),
                          const SizedBox(width: 2),
                          Icon(Icons.keyboard_arrow_down_rounded, size: 14, color: AppColors.textMuted(isDark)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Hero Recommended Dealer Details
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: AppColors.tealPrimary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.storefront_rounded, color: AppColors.tealPrimary, size: 22),
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
                                      heroRec.dealer.name,
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 14.5,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textPrimary(isDark),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: isManualSelection
                                          ? (isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9))
                                          : const Color(0xFFDCFCE7),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      isManualSelection ? 'SELECTED' : '${heroRec.smartScore.toStringAsFixed(0)}% MATCH',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w800,
                                        color: isManualSelection ? AppColors.tealPrimary : const Color(0xFF16A34A),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${heroRec.dealer.operatorName} • ${heroRec.dealer.authCertNumber}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11,
                                  color: AppColors.tealPrimary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // 4 Clean Quick Metrics
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildMetric(
                            label: 'Distance',
                            value: heroRec.distanceKm < 1.0
                                ? '${(heroRec.distanceKm * 1000).toInt()}m'
                                : '${heroRec.distanceKm.toStringAsFixed(1)} km',
                            isDark: isDark,
                          ),
                          _buildMetricDivider(isDark),
                          _buildMetric(
                            label: 'Rating',
                            value: '${heroRec.dealer.rating.toStringAsFixed(1)}★',
                            isDark: isDark,
                          ),
                          _buildMetricDivider(isDark),
                          _buildMetric(
                            label: 'Response',
                            value: '~${heroRec.dealer.avgResponseMinutes}m',
                            isDark: isDark,
                          ),
                          _buildMetricDivider(isDark),
                          _buildMetric(
                            label: 'Assistance Fee',
                            value: '₹${heroRec.dealer.getFeeForService(widget.service.id)}',
                            isDark: isDark,
                            isTeal: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Reason summary
                    Text(
                      heroRec.primaryReason,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        color: isDark ? const Color(0xFFCBD5E1) : const Color(0xFF64748B),
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Actions Row
                    Row(
                      children: [
                        OutlinedButton(
                          onPressed: () async {
                            final uri = Uri.parse('tel:${heroRec.dealer.phone.replaceAll(' ', '')}');
                            try {
                              await launchUrl(uri);
                            } catch (_) {}
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.tealPrimary,
                            side: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            minimumSize: const Size(0, 36),
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                          ),
                          child: const Icon(Icons.call_rounded, size: 16),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              AssistedBookingSheet.show(
                                context,
                                dealer: heroRec.dealer,
                                service: widget.service,
                              );
                            },
                            icon: const Icon(Icons.send_rounded, size: 14, color: Colors.white),
                            label: Text(
                              'Book Assisted Service (₹${heroRec.dealer.getFeeForService(widget.service.id)})',
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.tealPrimary,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              minimumSize: const Size(0, 36),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // 3. Alternative Nearby Providers
              if (alternativeRecs.isNotEmpty) ...[
                const Divider(height: 1),
                InkWell(
                  onTap: () => setState(() => _showAlternatives = !_showAlternatives),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    child: Row(
                      children: [
                        Text(
                          '${alternativeRecs.length} other verified centers nearby',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMuted(isDark),
                          ),
                        ),
                        const Spacer(),
                        Icon(
                          _showAlternatives ? Icons.expand_less_rounded : Icons.expand_more_rounded,
                          size: 16,
                          color: AppColors.tealPrimary,
                        ),
                      ],
                    ),
                  ),
                ),

                if (_showAlternatives)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
                    child: Column(
                      children: alternativeRecs.map((alt) {
                        final altDealer = alt.dealer;
                        final altDist = alt.distanceKm < 1.0
                            ? '${(alt.distanceKm * 1000).toInt()}m'
                            : '${alt.distanceKm.toStringAsFixed(1)} km';

                        return Container(
                          margin: const EdgeInsets.only(top: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  '${altDealer.name} ($altDist • ${altDealer.rating.toStringAsFixed(1)}★)',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimary(isDark),
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              InkWell(
                                onTap: () {
                                  setState(() => _selectedOverride = altDealer);
                                  if (widget.onDealerChanged != null) {
                                    widget.onDealerChanged!(altDealer);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: AppColors.tealPrimary.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'Choose',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.tealPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildMetric({
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
      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
    );
  }
}
