import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docusewa/config/profile_state.dart';
import 'package:docusewa/config/translations.dart';
import 'package:docusewa/config/vault_state.dart';
import 'package:docusewa/models/vault_doc.dart';
import 'package:docusewa/theme/app_colors.dart';

class VaultScreen extends StatefulWidget {
  final VoidCallback? onNavigateToHome;

  const VaultScreen({super.key, this.onNavigateToHome});

  @override
  State<VaultScreen> createState() => _VaultScreenState();
}

class _VaultScreenState extends State<VaultScreen> {
  String _selectedCategory = 'all';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, String>> _categories = [
    {'id': 'all', 'label': 'All Documents', 'emoji': '📂'},
    {'id': 'identity', 'label': 'Identity (Aadhaar & PAN)', 'emoji': '🏛️'},
    {'id': 'education', 'label': 'Education & APAAR', 'emoji': '🎓'},
    {'id': 'signature', 'label': 'Sign & Photo', 'emoji': '✍️'},
    {'id': 'vehicle', 'label': 'Driving & RC', 'emoji': '🚗'},
    {'id': 'health', 'label': 'ABHA Health', 'emoji': '🏥'},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<VaultDoc> _getFilteredDocs(List<VaultDoc> allDocs) {
    return allDocs.where((doc) {
      final matchesCategory =
          _selectedCategory == 'all' || doc.category == _selectedCategory;
      final q = _searchQuery.toLowerCase().trim();
      if (q.isEmpty) return matchesCategory;

      final matchesSearch =
          doc.title.toLowerCase().contains(q) ||
          doc.issuer.toLowerCase().contains(q) ||
          doc.docNumber.toLowerCase().contains(q) ||
          (doc.extraDetails?.toLowerCase().contains(q) ?? false) ||
          (doc.holderName?.toLowerCase().contains(q) ?? false) ||
          doc.category.toLowerCase().contains(q);
      return matchesCategory && matchesSearch;
    }).toList();
  }

  // ── AUTHENTIC OFFICIAL EMBLEM LOGO BUILDER ──────────────────────────────────
  Widget _buildOfficialOrgLogo(String logoType, {double size = 48}) {
    switch (logoType) {
      case 'uidai':
        // Authentic Aadhaar Sun & Fingerprint Logo
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(painter: AadhaarLogoPainter()),
        );

      case 'itd':
        // Authentic Income Tax Department Circular Seal
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(painter: IncomeTaxLogoPainter()),
        );

      case 'abc':
      case 'apaar':
        // Authentic Academic Bank of Credits Logo
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(painter: AcademicBankLogoPainter()),
        );

      case 'pseb':
      case 'cbse':
        // Authentic School Education Board Circular Emblem
        return SizedBox(
          width: size,
          height: size,
          child: CustomPaint(painter: EducationBoardLogoPainter()),
        );

      case 'signature':
        // Digital Signature Badge
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: const Color(0xFFEFF6FF),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF93C5FD)),
          ),
          child: const Center(
            child: Icon(Icons.draw_rounded, color: Color(0xFF2563EB), size: 26),
          ),
        );

      case 'photo':
        // Passport Photo Biometric Badge
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: const Color(0xFFFFFBEB),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFFDE68A)),
          ),
          child: const Center(
            child: Icon(
              Icons.portrait_rounded,
              color: Color(0xFFD97706),
              size: 26,
            ),
          ),
        );

      case 'morth':
        // MoRTH Parivahan Transport Emblem
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: const Color(0xFFF0FDF4),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFF86EFAC), width: 1.5),
          ),
          child: const Center(
            child: Icon(
              Icons.directions_car_rounded,
              color: Color(0xFF16A34A),
              size: 24,
            ),
          ),
        );

      case 'pmjay':
        // ABHA Health Emblem
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: const Color(0xFFFAF5FF),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFD8B4FE), width: 1.5),
          ),
          child: const Center(
            child: Icon(
              Icons.health_and_safety_rounded,
              color: Color(0xFF7C3AED),
              size: 24,
            ),
          ),
        );

      default:
        return Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFCBD5E1)),
          ),
          child: const Center(
            child: Icon(
              Icons.description_rounded,
              color: Color(0xFF0D9488),
              size: 24,
            ),
          ),
        );
    }
  }

  // ── EXACT DIGILOCKER STYLE CARD (AS SHOWN IN IMAGE) ─────────────────────────
  Widget _buildDigiLockerCard(VaultDoc doc, bool isDark, {double? width}) {
    return GestureDetector(
      onTap: () => _openDocViewerModal(context, doc),
      child: Container(
        width: width,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1E293B) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Row: Official Logo + Title and Number
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOfficialOrgLogo(doc.logoType, size: 46),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc.title,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                          letterSpacing: -0.2,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        doc.docNumber,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: isDark
                              ? Colors.white60
                              : const Color(0xFF64748B),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Bottom Text: Issuing Authority
            Text(
              doc.issuer,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11.5,
                fontWeight: FontWeight.w400,
                color: isDark ? Colors.white54 : const Color(0xFF94A3B8),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ── DRAW / UPLOAD SIGNATURE MODAL ──────────────────────────────────────────
  void _openSignatureDrawingPad(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final List<Offset?> points = [];
    Color penColor = const Color(0xFF1E3A8A);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.88,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface(isDark),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.tealSubtle,
              ),
            ),
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0284C7).withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.draw_rounded,
                        color: Color(0xFF0284C7),
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Digital Signature Studio',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary(isDark),
                            ),
                          ),
                          Text(
                            'Draw your official legal signature with finger or mouse',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11,
                              color: AppColors.textSecondary(isDark),
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      icon: const Icon(Icons.close_rounded),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Ink: ',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary(isDark),
                          ),
                        ),
                        const SizedBox(width: 4),
                        GestureDetector(
                          onTap: () => setModalState(
                            () => penColor = const Color(0xFF1E3A8A),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E3A8A),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: penColor == const Color(0xFF1E3A8A)
                                    ? Colors.tealAccent
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              'Royal Blue',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        GestureDetector(
                          onTap: () =>
                              setModalState(() => penColor = Colors.black),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(
                                color: penColor == Colors.black
                                    ? Colors.tealAccent
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Text(
                              'Black',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () => setModalState(() => points.clear()),
                      borderRadius: BorderRadius.circular(6),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 4,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.refresh_rounded,
                              size: 15,
                              color: Color(0xFFEF4444),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              'Clear',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFEF4444),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // Canvas Container
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF0F172A)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF0284C7).withValues(alpha: 0.5),
                        width: 1.5,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          final localPosition = details.localPosition;
                          setModalState(() {
                            points.add(localPosition);
                          });
                        },
                        onPanEnd: (details) {
                          setModalState(() {
                            points.add(null);
                          });
                        },
                        child: CustomPaint(
                          painter: DrawSignaturePainter(
                            points: points,
                            strokeColor: penColor,
                          ),
                          size: Size.infinite,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final updatedDoc = VaultDoc(
                        id: 'v-signature',
                        title: 'Candidate Digital Signature',
                        category: 'signature',
                        issuer: 'Self Attested & DigiLocker e-Signed',
                        docNumber: 'SIGN-SHA256-8921',
                        issueDate: 'Updated Just Now',
                        isVerified: true,
                        logoType: 'signature',
                        storageSource: 'digital_sign',
                        fileName: 'official_signature_transparent.png',
                        fileSize: '158 KB',
                        extraDetails:
                            'Format: High-Res PNG (300 DPI) | Valid for all Govt Applications',
                        holderName: ProfileState.fullNameNotifier.value,
                        createdAt: DateTime.now(),
                      );
                      VaultState.updateDocument(updatedDoc);
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Row(
                            children: [
                              Icon(
                                Icons.check_circle_rounded,
                                color: Colors.white,
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Digital Signature saved to Vault!',
                                ),
                              ),
                            ],
                          ),
                          backgroundColor: const Color(0xFF0D9488),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.lock_rounded, size: 16),
                    label: Text(
                      'Save & Encrypt Signature in Vault',
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w800,
                        fontSize: 13.5,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0284C7),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 46),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ── UPLOAD DOCUMENT DIALOG ─────────────────────────────────────────────────
  void _openUploadDocumentDialog(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final langCode = appLanguageNotifier.value;

    final titleCtrl = TextEditingController();
    final issuerCtrl = TextEditingController();
    final docNumberCtrl = TextEditingController();
    String selectedCat = 'identity';
    String selectedSource = 'phone_upload';
    String uploadedFileName =
        'document_scan_${DateTime.now().millisecondsSinceEpoch % 10000}.pdf';
    String uploadedFileSize = '1.8 MB';
    bool isSaving = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.88,
            ),
            decoration: BoxDecoration(
              color: AppColors.surface(isDark),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.tealSubtle,
              ),
            ),
            padding: EdgeInsets.fromLTRB(
              20,
              12,
              20,
              MediaQuery.of(context).viewInsets.bottom + 24,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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

                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.tealPrimary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.cloud_upload_rounded,
                          color: AppColors.tealPrimary,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              langCode == 'hi'
                                  ? 'दस्तावेज़ सुरक्षित अपलोड करें'
                                  : 'Upload Government Document',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary(isDark),
                              ),
                            ),
                            Text(
                              '256-bit AES Encrypted Digital Vault',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                color: const Color(0xFF10B981),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(ctx).pop(),
                        icon: const Icon(Icons.close_rounded),
                        color: AppColors.textSecondary(isDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Choose Document Source',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary(isDark),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: _buildSourceOption(
                          icon: Icons.camera_alt_rounded,
                          label: 'Camera Scan',
                          isSelected: selectedSource == 'camera_scan',
                          isDark: isDark,
                          onTap: () {
                            setModalState(() {
                              selectedSource = 'camera_scan';
                              uploadedFileName =
                                  'camera_scan_${DateTime.now().millisecondsSinceEpoch % 1000}.jpg';
                              uploadedFileSize = '2.4 MB';
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildSourceOption(
                          icon: Icons.photo_library_rounded,
                          label: 'Gallery Photo',
                          isSelected: selectedSource == 'phone_upload',
                          isDark: isDark,
                          onTap: () {
                            setModalState(() {
                              selectedSource = 'phone_upload';
                              uploadedFileName =
                                  'gallery_doc_${DateTime.now().millisecondsSinceEpoch % 1000}.png';
                              uploadedFileSize = '1.6 MB';
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildSourceOption(
                          icon: Icons.file_present_rounded,
                          label: 'PDF / File',
                          isSelected: selectedSource == 'pdf_file',
                          isDark: isDark,
                          onTap: () {
                            setModalState(() {
                              selectedSource = 'pdf_file';
                              uploadedFileName =
                                  'signed_doc_${DateTime.now().millisecondsSinceEpoch % 1000}.pdf';
                              uploadedFileSize = '3.2 MB';
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isDark
                          ? const Color(0xFF1E293B)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border(isDark)),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.attach_file_rounded,
                          size: 18,
                          color: AppColors.tealPrimary,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '$uploadedFileName ($uploadedFileSize)',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary(isDark),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF10B981,
                            ).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Ready',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF10B981),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  Text(
                    'Document Title / Name *',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary(isDark),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: titleCtrl,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      color: AppColors.textPrimary(isDark),
                    ),
                    decoration: InputDecoration(
                      hintText: 'e.g. 10th Marksheet, Rent Agreement, RC Book',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        color: AppColors.textMuted(isDark),
                      ),
                      filled: true,
                      fillColor: isDark
                          ? AppColors.darkSurfaceSubtle
                          : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.border(isDark)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  Text(
                    'Category',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary(isDark),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _categories.where((c) => c['id'] != 'all').map((
                      cat,
                    ) {
                      final isSelected = selectedCat == cat['id'];
                      return ChoiceChip(
                        label: Text(
                          '${cat['emoji']} ${cat['label']}',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? Colors.white
                                : (isDark
                                      ? Colors.white70
                                      : const Color(0xFF334155)),
                          ),
                        ),
                        selected: isSelected,
                        selectedColor: AppColors.tealPrimary,
                        backgroundColor: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFF1F5F9),
                        onSelected: (selected) {
                          if (selected) {
                            setModalState(() => selectedCat = cat['id']!);
                          }
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 14),

                  Text(
                    'Issuing Authority / Dept',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary(isDark),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: issuerCtrl,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      color: AppColors.textPrimary(isDark),
                    ),
                    decoration: InputDecoration(
                      hintText: 'e.g. Delhi University, CBSE, HDFC Bank, RTO',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        color: AppColors.textMuted(isDark),
                      ),
                      filled: true,
                      fillColor: isDark
                          ? AppColors.darkSurfaceSubtle
                          : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.border(isDark)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  Text(
                    'Document Number / Roll No / ID (Optional)',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary(isDark),
                    ),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: docNumberCtrl,
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 13.5,
                      color: AppColors.textPrimary(isDark),
                    ),
                    decoration: InputDecoration(
                      hintText: 'e.g. DOC-${DateTime.now().millisecond}-9821',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        color: AppColors.textMuted(isDark),
                      ),
                      filled: true,
                      fillColor: isDark
                          ? AppColors.darkSurfaceSubtle
                          : Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: AppColors.border(isDark)),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 12,
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 44),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            side: BorderSide(color: AppColors.border(isDark)),
                          ),
                          child: Text(
                            'Cancel',
                            style: GoogleFonts.plusJakartaSans(
                              color: AppColors.textPrimary(isDark),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: isSaving
                              ? null
                              : () {
                                  final title = titleCtrl.text.trim().isEmpty
                                      ? 'Official Stored Document'
                                      : titleCtrl.text.trim();
                                  final issuer = issuerCtrl.text.trim().isEmpty
                                      ? 'DigiLocker / Citizen Import'
                                      : issuerCtrl.text.trim();
                                  final docNum =
                                      docNumberCtrl.text.trim().isEmpty
                                      ? 'VAULT-${100000 + (DateTime.now().millisecond * 700) % 900000}'
                                      : docNumberCtrl.text.trim();

                                  setModalState(() => isSaving = true);
                                  Future.delayed(
                                    const Duration(milliseconds: 600),
                                    () {
                                      if (ctx.mounted) {
                                        final newDoc = VaultDoc(
                                          id: 'v-${DateTime.now().millisecondsSinceEpoch}',
                                          title: title,
                                          category: selectedCat,
                                          issuer: issuer,
                                          docNumber: docNum,
                                          issueDate: 'Uploaded Today',
                                          isVerified: true,
                                          logoType: 'custom',
                                          storageSource: selectedSource,
                                          fileName: uploadedFileName,
                                          fileSize: uploadedFileSize,
                                          createdAt: DateTime.now(),
                                        );
                                        VaultState.addDocument(newDoc);
                                        Navigator.of(ctx).pop();
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Row(
                                              children: [
                                                const Icon(
                                                  Icons.check_circle_rounded,
                                                  color: Colors.white,
                                                  size: 18,
                                                ),
                                                const SizedBox(width: 8),
                                                Expanded(
                                                  child: Text(
                                                    'Document "$title" securely saved & encrypted!',
                                                    style:
                                                        GoogleFonts.plusJakartaSans(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            backgroundColor: const Color(
                                              0xFF0D9488,
                                            ),
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.tealPrimary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 44),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: isSaving
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.lock_rounded, size: 16),
                                    const SizedBox(width: 6),
                                    Text(
                                      'Encrypt & Save Document',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSourceOption({
    required IconData icon,
    required String label,
    required bool isSelected,
    required bool isDark,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.tealPrimary.withValues(alpha: 0.12)
              : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC)),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppColors.tealPrimary
                : AppColors.border(isDark),
            width: isSelected ? 1.5 : 1.0,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? AppColors.tealPrimary
                  : AppColors.textSecondary(isDark),
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                color: isSelected
                    ? AppColors.tealPrimary
                    : AppColors.textPrimary(isDark),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ── FULL DOCUMENT VIEWER MODAL ─────────────────────────────────────────────
  void _openDocViewerModal(BuildContext context, VaultDoc doc) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final userName = ProfileState.fullNameNotifier.value.isNotEmpty
        ? ProfileState.fullNameNotifier.value
        : (doc.holderName ?? 'Rajesh Kumar Sharma');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.90,
        ),
        decoration: BoxDecoration(
          color: AppColors.surface(isDark),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : AppColors.tealSubtle,
          ),
        ),
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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

              // Visual Smart Document Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF0F766E),
                      Color(0xFF115E59),
                      Color(0xFF134E4A),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.tealPrimary.withValues(alpha: 0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 34,
                              height: 34,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white24,
                              ),
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.verified_user_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'DIGITAL CITIZEN VAULT',
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w800,
                                    color: const Color(0xFF99F6E4),
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Text(
                                  doc.issuer,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.check_rounded,
                                size: 12,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 3),
                              Text(
                                'VERIFIED',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),

                    Text(
                      doc.title,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'HOLDER: $userName'.toUpperCase(),
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFCCFBF1),
                      ),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'DOCUMENT NUMBER',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Colors.white60,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              doc.docNumber,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'ISSUED: ${doc.issueDate}',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 9.5,
                                color: const Color(0xFF99F6E4),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.qr_code_2_rounded,
                            color: Color(0xFF0F766E),
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.darkSurfaceSubtle
                      : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppColors.border(isDark)),
                ),
                child: Column(
                  children: [
                    _buildMetaRow(
                      'Category',
                      doc.category.toUpperCase(),
                      isDark,
                    ),
                    const Divider(height: 14),
                    _buildMetaRow(
                      'File Attached',
                      doc.fileName ?? 'digital_document.pdf',
                      isDark,
                    ),
                    const Divider(height: 14),
                    _buildMetaRow(
                      'File Size',
                      doc.fileSize ?? '1.5 MB',
                      isDark,
                    ),
                    const Divider(height: 14),
                    _buildMetaRow(
                      'Source',
                      doc.storageSource == 'phone_upload'
                          ? '📱 Stored from Phone'
                          : doc.storageSource == 'camera_scan'
                          ? '📸 Camera Scan'
                          : doc.storageSource == 'digital_sign'
                          ? '✍️ DigiLocker e-Sign'
                          : '🏛️ Govt Portal Import',
                      isDark,
                    ),
                    const Divider(height: 14),
                    _buildMetaRow(
                      'Security Encryption',
                      'AES-256 Bit Encrypted',
                      isDark,
                      isSecure: true,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {
                        _copyToClipboard(doc.docNumber, doc.title);
                      },
                      icon: const Icon(Icons.copy_rounded, size: 16),
                      label: Text(
                        'Copy ID',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary(isDark),
                        minimumSize: const Size(double.infinity, 44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(color: AppColors.border(isDark)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        _downloadDocFile(doc);
                      },
                      icon: const Icon(Icons.download_rounded, size: 16),
                      label: Text(
                        'Download',
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.tealPrimary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 44),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (dCtx) => AlertDialog(
                          title: Text(
                            'Delete Document?',
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          content: Text(
                            'Are you sure you want to remove "${doc.title}" from your Digital Vault?',
                            style: GoogleFonts.plusJakartaSans(),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(dCtx).pop(),
                              child: const Text('Cancel'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                VaultState.deleteDocument(doc.id);
                                Navigator.of(dCtx).pop();
                                Navigator.of(ctx).pop();
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Document "${doc.title}" deleted from Vault.',
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFEF4444),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.delete_outline_rounded,
                      color: Color(0xFFEF4444),
                    ),
                    tooltip: 'Delete Document',
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMetaRow(
    String label,
    String value,
    bool isDark, {
    bool isSecure = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            color: AppColors.textSecondary(isDark),
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isSecure
                ? const Color(0xFF10B981)
                : AppColors.textPrimary(isDark),
          ),
        ),
      ],
    );
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.white,
              size: 16,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text('$label "$text" copied to clipboard!')),
          ],
        ),
        backgroundColor: const Color(0xFF0D9488),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  void _downloadDocFile(VaultDoc doc) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.download_done_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                'Downloaded "${doc.fileName ?? doc.title}" to device storage!',
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF16A34A),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  // ── BUILD MAIN VAULT SCREEN ────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ValueListenableBuilder<List<VaultDoc>>(
      valueListenable: VaultState.vaultDocsNotifier,
      builder: (context, allDocs, _) {
        final filteredDocs = _getFilteredDocs(allDocs);

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // ── QUICK ACTION BUTTONS BAR ─────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _openUploadDocumentDialog(context),
                      icon: const Icon(Icons.upload_file_rounded, size: 16),
                      label: Text(
                        'Upload Document',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.tealPrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _openSignatureDrawingPad(context),
                      icon: const Icon(
                        Icons.draw_rounded,
                        size: 16,
                        color: Color(0xFF0284C7),
                      ),
                      label: Text(
                        'Signature Studio',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0F172A),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        side: BorderSide(
                          color: isDark
                              ? const Color(0xFF334155)
                              : const Color(0xFFE2E8F0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // ── SEARCH BAR ───────────────────────────────────────────────────
              Container(
                height: 44,
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E293B) : Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFE2E8F0),
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) => setState(() => _searchQuery = val),
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppColors.textPrimary(isDark),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search APAAR ID, Aadhaar, PAN, Marksheets...',
                    hintStyle: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      color: AppColors.textMuted(isDark),
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      size: 18,
                      color: AppColors.tealPrimary,
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 16),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ── CATEGORY HORIZONTAL CHIPS ────────────────────────────────────
              SizedBox(
                height: 36,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, idx) {
                    final cat = _categories[idx];
                    final isSelected = _selectedCategory == cat['id'];
                    return Padding(
                      padding: const EdgeInsets.only(right: 6),
                      child: FilterChip(
                        label: Text('${cat['emoji']} ${cat['label']}'),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = cat['id']!;
                          });
                        },
                        labelStyle: GoogleFonts.plusJakartaSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isSelected
                              ? Colors.white
                              : (isDark
                                    ? Colors.white70
                                    : const Color(0xFF475569)),
                        ),
                        selectedColor: AppColors.tealPrimary,
                        backgroundColor: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFF1F5F9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected
                                ? AppColors.tealPrimary
                                : (isDark
                                      ? const Color(0xFF334155)
                                      : const Color(0xFFE2E8F0)),
                          ),
                        ),
                        showCheckmark: false,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 4,
                          vertical: 0,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // ── SECTION HEADER: "Your Issued Documents" + "VIEW ALL (8)" ──────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Your Personal Vault',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white : const Color(0xFF1E1B4B),
                      letterSpacing: -0.2,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedCategory = 'all';
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                    child: Text(
                      'VIEW ALL (${allDocs.length})',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF2563EB),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // ── ISSUED DOCUMENTS LIST (DIGILOCKER STYLE) ─────────────────────
              if (filteredDocs.isEmpty) ...[
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    vertical: 40,
                    horizontal: 20,
                  ),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border(isDark)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.tealPrimary.withValues(alpha: 0.1),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.folder_open_rounded,
                            color: AppColors.tealPrimary,
                            size: 26,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'No Documents Found',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary(isDark),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Upload your ID cards, signature photos or marksheets.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12,
                          color: AppColors.textSecondary(isDark),
                        ),
                      ),
                    ],
                  ),
                ),
              ] else ...[
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: filteredDocs.length,
                  itemBuilder: (context, index) {
                    final doc = filteredDocs[index];
                    return _buildDigiLockerCard(doc, isDark);
                  },
                ),
              ],
              const SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}

// ── CUSTOM VECTOR PAINTERS FOR EXACT OFFICIAL LOGOS ───────────────────────────

/// Authentic Aadhaar UIDAI Sun & Fingerprint Logo
class AadhaarLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.45);
    final radius = size.width * 0.36;

    // Outer Yellow Sun Rays
    final rayPaint = Paint()
      ..color = const Color(0xFFF59E0B)
      ..style = PaintingStyle.fill;

    const numRays = 12;
    for (int i = 0; i < numRays; i++) {
      final angle = (i * 3.14159265 / (numRays / 2));
      // Top half rays arch
      if (angle >= 0 && angle <= 3.14159265) {
        final rayRect = Rect.fromCircle(
          center: Offset(
            center.dx +
                (radius + 4) * 0.8 * (i < 6 ? -(6 - i) / 6 : (i - 6) / 6),
            center.dy - (radius + 2) * (1 - ((i - 6).abs() / 6) * 0.4),
          ),
          radius: 3.2,
        );
        canvas.drawCircle(rayRect.center, 2.5, rayPaint);
      }
    }

    // Red Fingerprint Arch
    final fpPaint = Paint()
      ..color = const Color(0xFFDC2626)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;

    final fpRect1 = Rect.fromCenter(
      center: center,
      width: radius * 1.5,
      height: radius * 1.4,
    );
    canvas.drawArc(fpRect1, 3.14, 3.14, false, fpPaint);

    final fpRect2 = Rect.fromCenter(
      center: center,
      width: radius * 1.1,
      height: radius * 1.0,
    );
    canvas.drawArc(fpRect2, 3.14, 3.14, false, fpPaint);

    final fpRect3 = Rect.fromCenter(
      center: center,
      width: radius * 0.7,
      height: radius * 0.6,
    );
    canvas.drawArc(fpRect3, 3.14, 3.14, false, fpPaint);

    // "AADHAAR" text at bottom
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'AADHAAR',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 7.5,
          fontWeight: FontWeight.w900,
          color: const Color(0xFFDC2626),
          letterSpacing: 0.5,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset((size.width - textPainter.width) / 2, size.height - 10),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Authentic Income Tax Department Circular Seal Logo
class IncomeTaxLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.44);
    final radius = size.width * 0.40;

    // Green Circular Wreath
    final wreathPaint = Paint()
      ..color = const Color(0xFF16A34A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8;
    canvas.drawCircle(center, radius, wreathPaint);

    // Gold Ashoka Pillar icon inside
    final goldPaint = Paint()
      ..color = const Color(0xFFD97706)
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.45, goldPaint);

    // White core
    final whitePaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius * 0.22, whitePaint);

    // Red Banner at bottom
    final bannerPaint = Paint()
      ..color = const Color(0xFFDC2626)
      ..style = PaintingStyle.fill;
    final bannerRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
        center: Offset(center.dx, size.height - 8),
        width: size.width * 0.92,
        height: 10,
      ),
      const Radius.circular(3),
    );
    canvas.drawRRect(bannerRect, bannerPaint);

    // ITD text
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'INCOME TAX',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 6.5,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          letterSpacing: 0.2,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(
      canvas,
      Offset((size.width - textPainter.width) / 2, size.height - 12),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Authentic Academic Bank of Credits Logo (APAAR ID)
class AcademicBankLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Ashoka Emblem / ABC Blue Logo
    final bluePaint = Paint()
      ..color = const Color(0xFF1E3A8A)
      ..style = PaintingStyle.fill;

    // 3 pillars
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.20,
          size.height * 0.35,
          size.width * 0.14,
          size.height * 0.35,
        ),
        const Radius.circular(2),
      ),
      bluePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.43,
          size.height * 0.25,
          size.width * 0.14,
          size.height * 0.45,
        ),
        const Radius.circular(2),
      ),
      bluePaint,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.66,
          size.height * 0.35,
          size.width * 0.14,
          size.height * 0.35,
        ),
        const Radius.circular(2),
      ),
      bluePaint,
    );

    // Base bar
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          size.width * 0.15,
          size.height * 0.74,
          size.width * 0.70,
          4,
        ),
        const Radius.circular(2),
      ),
      bluePaint,
    );

    // "ABC" text
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'ABC',
        style: GoogleFonts.plusJakartaSans(
          fontSize: 7.5,
          fontWeight: FontWeight.w900,
          color: const Color(0xFF1E3A8A),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset((size.width - textPainter.width) / 2, 2));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Authentic Education Board Circular Emblem (PSEB / CBSE)
class EducationBoardLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.44;

    // Maroon Outer Ring
    final ringPaint = Paint()
      ..color = const Color(0xFF78350F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4;
    canvas.drawCircle(center, radius, ringPaint);

    final innerRingPaint = Paint()
      ..color = const Color(0xFF78350F)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0;
    canvas.drawCircle(center, radius * 0.78, innerRingPaint);

    // Open Book Icon in Center
    final bookPaint = Paint()
      ..color = const Color(0xFF78350F)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(center.dx - 10, center.dy + 4);
    path.lineTo(center.dx - 10, center.dy - 3);
    path.quadraticBezierTo(
      center.dx - 5,
      center.dy - 5,
      center.dx,
      center.dy - 3,
    );
    path.quadraticBezierTo(
      center.dx + 5,
      center.dy - 5,
      center.dx + 10,
      center.dy - 3,
    );
    path.lineTo(center.dx + 10, center.dy + 4);
    path.quadraticBezierTo(
      center.dx + 5,
      center.dy + 2,
      center.dx,
      center.dy + 4,
    );
    path.quadraticBezierTo(
      center.dx - 5,
      center.dy + 2,
      center.dx - 10,
      center.dy + 4,
    );
    canvas.drawPath(path, bookPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class DrawSignaturePainter extends CustomPainter {
  final List<Offset?> points;
  final Color strokeColor;

  const DrawSignaturePainter({required this.points, required this.strokeColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = strokeColor
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 3.0;

    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null) {
        canvas.drawLine(points[i]!, points[i + 1]!, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant DrawSignaturePainter oldDelegate) => true;
}
