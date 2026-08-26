import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docusewa/models/service_dealer.dart';
import 'package:docusewa/models/service_request.dart';
import 'package:docusewa/screens/home_screen.dart' show ServiceData;
import 'package:docusewa/services/service_request_service.dart';
import 'package:docusewa/theme/app_colors.dart';

/// Modal bottom sheet to book assisted government service with a verified provider
class AssistedBookingSheet extends StatefulWidget {
  final ServiceDealer dealer;
  final ServiceData service;

  const AssistedBookingSheet({
    super.key,
    required this.dealer,
    required this.service,
  });

  static Future<void> show(
    BuildContext context, {
    required ServiceDealer dealer,
    required ServiceData service,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => AssistedBookingSheet(
        dealer: dealer,
        service: service,
      ),
    );
  }

  @override
  State<AssistedBookingSheet> createState() => _AssistedBookingSheetState();
}

class _AssistedBookingSheetState extends State<AssistedBookingSheet> {
  bool _isSubmitting = false;
  bool _isSuccess = false;
  String _bookingRef = '';
  int _assistanceMode = 0; // 0: Digital Assisted (Online), 1: Center Walk-in Priority Pass

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final dealer = widget.dealer;
    final service = widget.service;
    final fee = dealer.getFeeForService(service.id);

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
        child: _isSuccess
            ? _buildSuccessView(isDark, dealer, service)
            : _buildBookingForm(isDark, dealer, service, fee),
      ),
    );
  }

  Widget _buildBookingForm(bool isDark, ServiceDealer dealer, ServiceData service, int fee) {
    return Column(
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

        // Header
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.tealPrimary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.handshake_rounded, color: AppColors.tealPrimary, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Book Assisted Application',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary(isDark),
                    ),
                  ),
                  Text(
                    'Handled securely by verified government operator',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 11.5,
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
        const SizedBox(height: 14),

        // Assigned Provider Box
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border(isDark)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.tealPrimary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: const Icon(Icons.verified_rounded, color: AppColors.tealPrimary, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      dealer.name,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary(isDark),
                      ),
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
        ),
        const SizedBox(height: 14),

        // Service Summary
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF042F2E) : const Color(0xFFF0FDFA),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isDark ? const Color(0xFF115E59) : const Color(0xFFCCFBF1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TARGET SERVICE',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                  color: AppColors.tealPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text(service.iconEmoji, style: const TextStyle(fontSize: 18)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      service.documentType,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
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

        // Mode of Assistance
        Text(
          'SELECT ASSISTANCE MODE',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 10.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.5,
            color: AppColors.textMuted(isDark),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _assistanceMode = 0),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _assistanceMode == 0
                        ? AppColors.tealPrimary.withValues(alpha: 0.12)
                        : (isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC)),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _assistanceMode == 0 ? AppColors.tealPrimary : AppColors.border(isDark),
                      width: _assistanceMode == 0 ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.cloud_upload_rounded,
                            size: 16,
                            color: _assistanceMode == 0 ? AppColors.tealPrimary : AppColors.textMuted(isDark),
                          ),
                          const Spacer(),
                          if (_assistanceMode == 0)
                            const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.tealPrimary),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '100% Digital / Online',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: _assistanceMode == 0 ? AppColors.tealPrimary : AppColors.textPrimary(isDark),
                        ),
                      ),
                      Text(
                        'VLE processes via portal',
                        style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.textMuted(isDark)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: InkWell(
                onTap: () => setState(() => _assistanceMode = 1),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _assistanceMode == 1
                        ? AppColors.tealPrimary.withValues(alpha: 0.12)
                        : (isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC)),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _assistanceMode == 1 ? AppColors.tealPrimary : AppColors.border(isDark),
                      width: _assistanceMode == 1 ? 1.5 : 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.store_rounded,
                            size: 16,
                            color: _assistanceMode == 1 ? AppColors.tealPrimary : AppColors.textMuted(isDark),
                          ),
                          const Spacer(),
                          if (_assistanceMode == 1)
                            const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.tealPrimary),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Center Priority Pass',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: _assistanceMode == 1 ? AppColors.tealPrimary : AppColors.textPrimary(isDark),
                        ),
                      ),
                      Text(
                        'Zero-wait walk-in slot',
                        style: GoogleFonts.plusJakartaSans(fontSize: 10, color: AppColors.textMuted(isDark)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Fee Summary
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border(isDark)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Official Govt Portal Fee',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.textSecondary(isDark)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Direct on Portal',
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary(isDark)),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Authorized CSC Assistance Fee',
                      style: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.textSecondary(isDark)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '₹$fee (On Delivery)',
                    style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.tealPrimary),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Submit Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSubmitting ? null : _submitRequest,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.tealPrimary,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 46),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 0,
            ),
            child: _isSubmitting
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                : Text(
                    'Confirm & Send Request • ₹$fee',
                    style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 13.5, color: Colors.white),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessView(bool isDark, ServiceDealer dealer, ServiceData service) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFDCFCE7),
            ),
            child: const Center(
              child: Icon(Icons.check_rounded, color: Color(0xFF16A34A), size: 36),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Assistance Request Dispatched!',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary(isDark),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Assigned to ${dealer.operatorName} at ${dealer.name}.\nYou will receive updates via SMS and DocSeva notifications.',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 13,
              color: AppColors.textSecondary(isDark),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),

          // Ref Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border(isDark)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.confirmation_number_outlined, size: 16, color: AppColors.tealPrimary),
                const SizedBox(width: 8),
                Text(
                  'Tracking ID: $_bookingRef',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.tealPrimary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tealPrimary,
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 44),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: Text(
                'Done',
                style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _submitRequest() {
    setState(() => _isSubmitting = true);
    final ref = 'DS-CSC-${DateTime.now().millisecondsSinceEpoch % 1000000}';

    // Register service request
    ServiceRequestService.instance.createRequest(
      title: '${widget.service.documentType} (Assisted by ${widget.dealer.name})',
      description: 'Assisted application for ${widget.service.documentType} routed to ${widget.dealer.name} (${widget.dealer.authCertNumber}). Mode: ${_assistanceMode == 0 ? "Digital" : "Center Walk-in"}.',
      category: ServiceCategory.fromString(widget.service.category),
    );

    Future.delayed(const Duration(milliseconds: 700), () {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
          _isSuccess = true;
          _bookingRef = ref;
        });
      }
    });
  }
}
