import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docusewa/services/user_location_service.dart';
import 'package:docusewa/theme/app_colors.dart';

/// Modal bottom sheet to switch locality or search PIN code
class LocationPickerSheet extends StatefulWidget {
  const LocationPickerSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const LocationPickerSheet(),
    );
  }

  @override
  State<LocationPickerSheet> createState() => _LocationPickerSheetState();
}

class _LocationPickerSheetState extends State<LocationPickerSheet> {
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
    final currentLoc = UserLocationService.currentLocation.value;

    final filteredPresets = kPresetLocations.where((loc) {
      if (_query.isEmpty) return true;
      final q = _query.toLowerCase();
      return loc.locality.toLowerCase().contains(q) ||
          loc.city.toLowerCase().contains(q) ||
          loc.pincode.contains(q) ||
          loc.state.toLowerCase().contains(q);
    }).toList();

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface(isDark),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.tealSubtle),
      ),
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
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

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.tealPrimary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.location_on_rounded, color: AppColors.tealPrimary, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select Your Location',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary(isDark),
                      ),
                    ),
                    Text(
                      'Distances & recommendations update automatically',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        color: AppColors.textSecondary(isDark),
                      ),
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
          const SizedBox(height: 16),

          // Search PIN or locality
          TextField(
            controller: _searchCtrl,
            onChanged: (val) => setState(() => _query = val.trim()),
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13.5,
              color: AppColors.textPrimary(isDark),
            ),
            decoration: InputDecoration(
              hintText: 'Search city, locality or 6-digit PIN code...',
              hintStyle: GoogleFonts.plusJakartaSans(
                fontSize: 13,
                color: AppColors.textMuted(isDark),
              ),
              prefixIcon: const Icon(Icons.search_rounded, size: 20, color: AppColors.tealPrimary),
              suffixIcon: _query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 18),
                      onPressed: () {
                        _searchCtrl.clear();
                        setState(() => _query = '');
                      },
                    )
                  : null,
              filled: true,
              fillColor: AppColors.inputFill(isDark),
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.border(isDark)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.border(isDark)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.tealPrimary, width: 1.5),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Presets list
          Text(
            'POPULAR CITIZEN LOCALITIES',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.6,
              color: AppColors.textMuted(isDark),
            ),
          ),
          const SizedBox(height: 8),

          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: filteredPresets.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (ctx, idx) {
                final loc = filteredPresets[idx];
                final isSelected = loc.locality == currentLoc.locality && loc.city == currentLoc.city;

                return InkWell(
                  onTap: () {
                    UserLocationService.setLocation(loc);
                    Navigator.of(context).pop();
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.tealPrimary.withValues(alpha: 0.1)
                          : (isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC)),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.tealPrimary
                            : (isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0)),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          loc.isGPS ? Icons.my_location_rounded : Icons.location_city_rounded,
                          size: 18,
                          color: isSelected ? AppColors.tealPrimary : AppColors.textMuted(isDark),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    loc.locality,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 13.5,
                                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                                      color: isSelected ? AppColors.tealPrimary : AppColors.textPrimary(isDark),
                                    ),
                                  ),
                                  if (loc.isGPS) ...[
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFDCFCE7),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        'DEFAULT GPS',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w800,
                                          color: const Color(0xFF16A34A),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${loc.city}, ${loc.state} • PIN: ${loc.pincode}',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 11.5,
                                  color: AppColors.textSecondary(isDark),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle_rounded, color: AppColors.tealPrimary, size: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
