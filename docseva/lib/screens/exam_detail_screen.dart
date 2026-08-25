import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:docusewa/config/translations.dart';
import 'package:docusewa/screens/home_screen.dart';
import 'package:docusewa/theme/app_colors.dart';

class ExamDetailScreen extends StatefulWidget {
  final ServiceData service;
  final VoidCallback? onOpenVault;

  const ExamDetailScreen({
    super.key,
    required this.service,
    this.onOpenVault,
  });

  @override
  State<ExamDetailScreen> createState() => _ExamDetailScreenState();
}

class _ExamDetailScreenState extends State<ExamDetailScreen> {
  int _selectedTab = 0; // 0: Overview, 1: Documents, 2: Steps
  final Set<int> _checkedDocs = {0, 1}; // Pre-check photo & signature as ready
  int _activeStepIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final langCode = appLanguageNotifier.value;
    final service = widget.service;
    final serviceName = ServiceTranslator.getServiceName(service.id, langCode);
    final formUrl = service.applyUrl ?? service.portalUrl;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B132B) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: AppColors.surface(isDark),
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: AppColors.textPrimary(isDark),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          serviceName,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary(isDark),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.copy_rounded, size: 19),
            tooltip: 'Copy Link',
            onPressed: () {
              Clipboard.setData(ClipboardData(text: formUrl));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: const [
                      Icon(Icons.check_circle_rounded, color: Colors.white, size: 16),
                      SizedBox(width: 8),
                      Text('Official portal link copied!'),
                    ],
                  ),
                  backgroundColor: const Color(0xFF0D9488),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.open_in_new_rounded, size: 19),
            tooltip: 'Open in Browser',
            onPressed: () async {
              final uri = Uri.parse(formUrl);
              try {
                await launchUrl(uri, mode: LaunchMode.externalApplication);
              } catch (_) {}
            },
          ),
          const SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            height: 1,
          ),
        ),
      ),
      body: Column(
        children: [
          // ── COMPACT HERO HEADER ──────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            color: AppColors.surface(isDark),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFBFDBFE),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(service.iconEmoji, style: const TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              service.tag.toUpperCase(),
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w800,
                                color: const Color(0xFF2563EB),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF10B981).withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              children: const [
                                Icon(Icons.verified_rounded, size: 11, color: Color(0xFF10B981)),
                                SizedBox(width: 3),
                                Text(
                                  'Active Portal',
                                  style: TextStyle(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF10B981),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        service.portalDomain,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary(isDark),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── INTERACTIVE SEGMENTED TABS ──────────────────────────────────
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.surface(isDark),
              border: Border(
                bottom: BorderSide(
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
                ),
              ),
            ),
            child: Container(
              height: 38,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  _buildTabButton(0, '📊 Highlights', isDark),
                  _buildTabButton(1, '📑 Docs (${_checkedDocs.length}/${service.requiredDocs.length})', isDark),
                  _buildTabButton(2, '🚀 How to Apply', isDark),
                ],
              ),
            ),
          ),

          // ── TAB CONTENT ─────────────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 90),
              child: _selectedTab == 0
                  ? _buildOverviewTab(service, isDark)
                  : _selectedTab == 1
                      ? _buildDocsTab(service, isDark)
                      : _buildStepsTab(service, isDark),
            ),
          ),
        ],
      ),

      // ── STICKY BOTTOM BUTTON ──────────────────────────────────────────
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        decoration: BoxDecoration(
          color: AppColors.surface(isDark),
          border: Border(
            top: BorderSide(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            ),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 46,
            child: ElevatedButton.icon(
              onPressed: () async {
                final uri = Uri.parse(formUrl);
                try {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                } catch (_) {}
              },
              icon: const Icon(Icons.open_in_new_rounded, size: 16),
              label: Text(
                'Open Official Application Form ↗',
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w700,
                  fontSize: 13.5,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tealPrimary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabButton(int index, String title, bool isDark) {
    final isSelected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? const Color(0xFF0F766E) : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    )
                  ]
                : null,
          ),
          child: Text(
            title,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              color: isSelected
                  ? (isDark ? Colors.white : const Color(0xFF0F766E))
                  : AppColors.textSecondary(isDark),
            ),
          ),
        ),
      ),
    );
  }

  // ── TAB 1: HIGHLIGHTS & STATS ─────────────────────────────────────────
  Widget _buildOverviewTab(ServiceData service, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 2x3 Visual Grid
        GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.6,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildStatTile(
              icon: Icons.school_outlined,
              iconColor: const Color(0xFF2563EB),
              title: 'Eligibility',
              value: service.eligibility ?? 'Graduate in any discipline',
              isDark: isDark,
            ),
            _buildStatTile(
              icon: Icons.cake_outlined,
              iconColor: const Color(0xFF7C3AED),
              title: 'Age Limit',
              value: service.ageLimit ?? '18 to 32 Years',
              isDark: isDark,
            ),
            _buildStatTile(
              icon: Icons.groups_outlined,
              iconColor: const Color(0xFF059669),
              title: 'Vacancies',
              value: service.vacancyCount ?? 'All India Openings',
              isDark: isDark,
            ),
            _buildStatTile(
              icon: Icons.payments_outlined,
              iconColor: const Color(0xFFEA580C),
              title: 'Application Fee',
              value: service.price,
              isDark: isDark,
            ),
            _buildStatTile(
              icon: Icons.calendar_month_outlined,
              iconColor: const Color(0xFF0284C7),
              title: 'Exam Schedule',
              value: service.examDates ?? 'Active Calendar',
              isDark: isDark,
            ),
            _buildStatTile(
              icon: Icons.laptop_chromebook_rounded,
              iconColor: const Color(0xFF0D9488),
              title: 'Test Pattern',
              value: service.examMode ?? 'CBT / Objective OMR',
              isDark: isDark,
            ),
          ],
        ),
        const SizedBox(height: 14),

        // Pay Scale Banner
        if (service.salaryScale != null)
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF16A34A).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.currency_rupee_rounded, size: 18, color: Color(0xFF16A34A)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pay Scale & Benefits',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textSecondary(isDark),
                        ),
                      ),
                      Text(
                        service.salaryScale!,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary(isDark),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  // ── TAB 2: INTERACTIVE REQUIRED DOCUMENTS ─────────────────────────────
  Widget _buildDocsTab(ServiceData service, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Vault Direct Connect Card
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDark
                  ? [const Color(0xFF0F766E), const Color(0xFF1E293B)]
                  : [const Color(0xFF0F766E), const Color(0xFF134E4A)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              const Icon(Icons.folder_special_rounded, color: Color(0xFF5EEAD4), size: 24),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ready in Personal Vault',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Photo & Signature are verified & ready',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  widget.onOpenVault?.call();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF0F766E),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  elevation: 0,
                ),
                child: Text(
                  'Open Vault',
                  style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        Text(
          'Document Readiness Checklist (Tap to toggle)',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary(isDark),
          ),
        ),
        const SizedBox(height: 8),

        // Interactive Checklist
        ...List.generate(service.requiredDocs.length, (index) {
          final doc = service.requiredDocs[index];
          final isChecked = _checkedDocs.contains(index);

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () {
                setState(() {
                  if (isChecked) {
                    _checkedDocs.remove(index);
                  } else {
                    _checkedDocs.add(index);
                  }
                });
              },
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isChecked
                      ? (isDark ? const Color(0xFF064E3B).withValues(alpha: 0.3) : const Color(0xFFECFDF5))
                      : AppColors.surface(isDark),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isChecked
                        ? const Color(0xFF10B981)
                        : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isChecked ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
                      color: isChecked ? const Color(0xFF10B981) : AppColors.textSecondary(isDark),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        doc,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: isChecked ? FontWeight.w700 : FontWeight.w500,
                          color: isChecked
                              ? (isDark ? Colors.white : const Color(0xFF065F46))
                              : AppColors.textPrimary(isDark),
                        ),
                      ),
                    ),
                    if (index < 2)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0D9488).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'IN VAULT',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF0D9488),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  // ── TAB 3: INTERACTIVE STEPS ──────────────────────────────────────────
  Widget _buildStepsTab(ServiceData service, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Online Application Walkthrough',
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary(isDark),
          ),
        ),
        const SizedBox(height: 8),

        ...List.generate(service.procedure.length, (index) {
          final isCurrent = _activeStepIndex == index;

          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: InkWell(
              onTap: () => setState(() => _activeStepIndex = index),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? (isDark ? const Color(0xFF1E293B) : const Color(0xFFF0FDFA))
                      : AppColors.surface(isDark),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isCurrent
                        ? AppColors.tealPrimary
                        : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: isCurrent ? AppColors.tealPrimary : (isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${index + 1}',
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
                        service.procedure[index],
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
                          color: AppColors.textPrimary(isDark),
                          height: 1.35,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildStatTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface(isDark),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: iconColor),
              const SizedBox(width: 4),
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary(isDark),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary(isDark),
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
