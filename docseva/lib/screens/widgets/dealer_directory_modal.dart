import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docusewa/models/service_dealer.dart';
import 'package:docusewa/screens/home_screen.dart' show ServiceData;
import 'package:docusewa/screens/widgets/dealer_profile_sheet.dart';
import 'package:docusewa/screens/widgets/location_picker_sheet.dart';
import 'package:docusewa/services/dealer_recommendation_service.dart';
import 'package:docusewa/services/user_location_service.dart';
import 'package:docusewa/theme/app_colors.dart';

/// Full directory modal to browse and filter all verified providers for a service
class DealerDirectoryModal extends StatefulWidget {
  final ServiceData service;
  final Function(ServiceDealer dealer)? onSelectDealer;

  const DealerDirectoryModal({
    super.key,
    required this.service,
    this.onSelectDealer,
  });

  static Future<void> show(
    BuildContext context, {
    required ServiceData service,
    Function(ServiceDealer dealer)? onSelectDealer,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DealerDirectoryModal(
        service: service,
        onSelectDealer: onSelectDealer,
      ),
    );
  }

  @override
  State<DealerDirectoryModal> createState() => _DealerDirectoryModalState();
}

class _DealerDirectoryModalState extends State<DealerDirectoryModal> {
  String _sortBy = 'smart'; // 'smart', 'distance', 'rating', 'price', 'speed'
  final TextEditingController _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<UserLocation>(
      valueListenable: UserLocationService.currentLocation,
      builder: (context, userLocation, _) {
        final allRecs = DealerRecommendationService.instance.getRecommendationsForService(
          service: widget.service,
          location: userLocation,
          sortBy: _sortBy,
        );

        final filteredRecs = allRecs.where((rec) {
          if (_query.isEmpty) return true;
          final q = _query.toLowerCase();
          final d = rec.dealer;
          return d.name.toLowerCase().contains(q) ||
              d.operatorName.toLowerCase().contains(q) ||
              d.locality.toLowerCase().contains(q) ||
              d.city.toLowerCase().contains(q) ||
              d.pincode.contains(q) ||
              d.authCertNumber.toLowerCase().contains(q);
        }).toList();

        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.92,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface(isDark),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.tealSubtle),
          ),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Drag handle
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: AppColors.border(isDark),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              // Header Row
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.tealPrimary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.store_rounded, color: AppColors.tealPrimary, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Verified Providers Directory',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary(isDark),
                          ),
                        ),
                        Text(
                          'For ${widget.service.documentType} • ${filteredRecs.length} Available',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            color: AppColors.textSecondary(isDark),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                    color: AppColors.textMuted(isDark),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Location chip bar
              InkWell(
                onTap: () => LocationPickerSheet.show(context),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.border(isDark)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on_rounded, size: 14, color: AppColors.tealPrimary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          'Searching near: ${userLocation.fullLabel}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary(isDark),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        'Change',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.tealPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Search Box
              TextField(
                controller: _searchCtrl,
                onChanged: (val) => setState(() => _query = val.trim()),
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppColors.textPrimary(isDark),
                ),
                decoration: InputDecoration(
                  hintText: 'Search by center name, PIN code, or VLE name...',
                  hintStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    color: AppColors.textMuted(isDark),
                  ),
                  prefixIcon: const Icon(Icons.search_rounded, size: 18, color: AppColors.tealPrimary),
                  suffixIcon: _query.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 16),
                          onPressed: () {
                            _searchCtrl.clear();
                            setState(() => _query = '');
                          },
                        )
                      : null,
                  filled: true,
                  fillColor: AppColors.inputFill(isDark),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.border(isDark)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.border(isDark)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.tealPrimary, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // Filter Sort Chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('smart', '⭐ Smart Match', isDark),
                    const SizedBox(width: 6),
                    _buildFilterChip('distance', '📍 Nearest', isDark),
                    const SizedBox(width: 6),
                    _buildFilterChip('rating', '🏆 Top Rated', isDark),
                    const SizedBox(width: 6),
                    _buildFilterChip('price', '₹ Lowest Fee', isDark),
                    const SizedBox(width: 6),
                    _buildFilterChip('speed', '⚡ Fastest Response', isDark),
                  ],
                ),
              ),
              const SizedBox(height: 12),

              // Dealer List
              Expanded(
                child: filteredRecs.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.storefront_outlined, size: 40, color: Colors.grey),
                            const SizedBox(height: 8),
                            Text(
                              'No verified providers found matching "$_query"',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13,
                                color: AppColors.textMuted(isDark),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        itemCount: filteredRecs.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                        itemBuilder: (ctx, idx) {
                          final rec = filteredRecs[idx];
                          final dealer = rec.dealer;
                          final isTop = idx == 0 && _sortBy == 'smart';

                          final distFormatted = rec.distanceKm < 1.0
                              ? '${(rec.distanceKm * 1000).toInt()}m'
                              : '${rec.distanceKm.toStringAsFixed(1)} km';

                          return Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isTop
                                    ? AppColors.tealPrimary
                                    : (isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
                                width: isTop ? 1.5 : 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Rank index
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: isTop ? AppColors.tealPrimary : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '#${idx + 1}',
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: isTop ? Colors.white : AppColors.textPrimary(isDark),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  dealer.name,
                                                  style: GoogleFonts.plusJakartaSans(
                                                    fontSize: 13.5,
                                                    fontWeight: FontWeight.w800,
                                                    color: AppColors.textPrimary(isDark),
                                                  ),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                                decoration: BoxDecoration(
                                                  color: isTop ? const Color(0xFFDCFCE7) : (isDark ? const Color(0xFF0F766E).withValues(alpha: 0.3) : const Color(0xFFF0FDFA)),
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: Text(
                                                  isTop ? '${rec.smartScore.toStringAsFixed(0)}% MATCH' : '${rec.smartScore.toStringAsFixed(0)} SCORE',
                                                  style: GoogleFonts.plusJakartaSans(
                                                    fontSize: 9.5,
                                                    fontWeight: FontWeight.w800,
                                                    color: isTop ? const Color(0xFF16A34A) : AppColors.tealPrimary,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${dealer.operatorName} • ${dealer.authCertNumber}',
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
                                const SizedBox(height: 8),

                                // Highlights strip
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 4,
                                  children: [
                                    _buildSmallTag('📍 $distFormatted', isDark),
                                    _buildSmallTag('⭐ ${dealer.rating.toStringAsFixed(1)} (${dealer.reviewCount})', isDark),
                                    _buildSmallTag('⚡ ~${dealer.avgResponseMinutes}m', isDark),
                                    _buildSmallTag('📁 ${dealer.totalServicesCompleted}+ done', isDark),
                                    _buildSmallTag('₹${dealer.getFeeForService(widget.service.id)} fee', isDark, isHighlighted: true),
                                  ],
                                ),
                                const SizedBox(height: 10),

                                // Actions row
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {
                                          DealerProfileSheet.show(
                                            context,
                                            dealer: dealer,
                                            currentService: widget.service,
                                          );
                                        },
                                        style: OutlinedButton.styleFrom(
                                          minimumSize: const Size(double.infinity, 32),
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          side: BorderSide(color: AppColors.border(isDark)),
                                        ),
                                        child: Text(
                                          'View Profile',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary(isDark),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                          if (widget.onSelectDealer != null) {
                                            widget.onSelectDealer!(dealer);
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.tealPrimary,
                                          foregroundColor: Colors.white,
                                          minimumSize: const Size(double.infinity, 32),
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                          elevation: 0,
                                        ),
                                        child: Text(
                                          'Select Provider',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(String key, String label, bool isDark) {
    final isSelected = _sortBy == key;
    return InkWell(
      onTap: () => setState(() => _sortBy = key),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.tealPrimary
              : (isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF1F5F9)),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.tealPrimary : AppColors.border(isDark),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? Colors.white : AppColors.textPrimary(isDark),
          ),
        ),
      ),
    );
  }

  Widget _buildSmallTag(String text, bool isDark, {bool isHighlighted = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isHighlighted
            ? (isDark ? const Color(0xFF064E3B).withValues(alpha: 0.5) : const Color(0xFFECFDF5))
            : (isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0)),
        borderRadius: BorderRadius.circular(6),
        border: isHighlighted
            ? Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.5))
            : null,
      ),
      child: Text(
        text,
        style: GoogleFonts.plusJakartaSans(
          fontSize: 10.5,
          fontWeight: isHighlighted ? FontWeight.w700 : FontWeight.w500,
          color: isHighlighted
              ? const Color(0xFF10B981)
              : AppColors.textPrimary(isDark),
        ),
      ),
    );
  }
}
