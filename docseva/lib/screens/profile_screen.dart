import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docusewa/services/auth_service.dart';
import 'package:docusewa/theme/app_colors.dart';
import 'package:docusewa/config/translations.dart';
import 'package:docusewa/config/profile_state.dart';

class ProfileScreen extends StatefulWidget {
  final int vaultCount;
  final VoidCallback? onNavigateToVault;

  const ProfileScreen({
    super.key,
    this.vaultCount = 3,
    this.onNavigateToVault,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // 3 Clean Tabs: 0: Digital ID, 1: Personal & KYC, 2: Settings
  int _selectedSubTab = 0;

  // Profile data state (connected to ProfileState)
  late String _fullName;
  late String _phone;
  late String _email;
  late String _fatherName;
  late String _address;
  late String _avatarUrl;

  final String _dob = '15 Aug 1998';
  final String _gender = 'Male';
  final String _bloodGroup = 'O+ Positive';
  final String _state = 'Uttar Pradesh';
  final String _pincode = '201301';
  final String _citizenId = 'DS-IN-2026-89210';
  final String _aadhaarLast4 = '8921';
  final String _panNumber = 'ABCDE1234F';
  final String _abhaId = '91-8921-4412-3320';
  final String _uanNumber = '101293849120';

  @override
  void initState() {
    super.initState();
    _fullName = ProfileState.fullNameNotifier.value;
    _phone = ProfileState.phoneNotifier.value;
    _email = ProfileState.emailNotifier.value;
    _fatherName = ProfileState.fatherNameNotifier.value;
    _address = ProfileState.addressNotifier.value;
    _avatarUrl = ProfileState.avatarNotifier.value;
  }

  // Security toggles
  bool _twoFactorEnabled = true;
  bool _biometricLockEnabled = true;

  // Preferences
  bool _whatsappAlerts = true;
  bool _smsAlerts = true;

  // Avatar presets list
  static const List<String> _avatarPresets = [
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=200&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=200&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=200&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=200&auto=format&fit=crop&q=80',
    'https://images.unsplash.com/photo-1519085360753-af0119f7cbe7?w=200&auto=format&fit=crop&q=80',
  ];

  void _showSnackBar(String message, {bool isSuccess = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle_rounded : Icons.info_outline_rounded,
              color: isSuccess ? const Color(0xFF10B981) : Colors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    _showSnackBar('Copied $label to clipboard!');
  }

  void _openPhotoCropDialog(bool isDark) {
    String selectedUrl = _avatarUrl;
    double zoomLevel = 1.0;
    final urlController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Container(
            decoration: BoxDecoration(
              color: AppColors.surface(isDark),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.tealSubtle),
            ),
            padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(ctx).viewInsets.bottom + 24),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: AppColors.border(isDark),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Title Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Crop & Update Profile Photo',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: AppColors.textPrimary(isDark),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Position and crop your citizen ID photo',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 11.5,
                              color: AppColors.textSecondary(isDark),
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(ctx),
                        icon: const Icon(Icons.close_rounded, size: 20),
                        color: AppColors.textMuted(isDark),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Circular Crop & Preview Area
                  Center(
                    child: Container(
                      width: 170,
                      height: 170,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: const Color(0xFF0F172A),
                        border: Border.all(color: AppColors.tealPrimary, width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.tealPrimary.withValues(alpha: 0.25),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipOval(
                        child: Transform.scale(
                          scale: zoomLevel,
                          child: Image.network(
                            selectedUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => Container(
                              color: AppColors.tealPrimary,
                              alignment: Alignment.center,
                              child: const Text('DK', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Zoom slider and controls
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (zoomLevel > 1.0) {
                            setDialogState(() => zoomLevel = (zoomLevel - 0.2).clamp(1.0, 2.5));
                          }
                        },
                        icon: const Icon(Icons.remove_circle_outline_rounded, size: 20),
                        color: AppColors.tealPrimary,
                      ),
                      Expanded(
                        child: Slider(
                          value: zoomLevel,
                          min: 1.0,
                          max: 2.5,
                          divisions: 15,
                          activeColor: AppColors.tealPrimary,
                          inactiveColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                          onChanged: (val) {
                            setDialogState(() => zoomLevel = val);
                          },
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          if (zoomLevel < 2.5) {
                            setDialogState(() => zoomLevel = (zoomLevel + 0.2).clamp(1.0, 2.5));
                          }
                        },
                        icon: const Icon(Icons.add_circle_outline_rounded, size: 20),
                        color: AppColors.tealPrimary,
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // Preset Citizen Avatars
                  Text(
                    'Select Profile Preset:',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary(isDark),
                    ),
                  ),
                  const SizedBox(height: 8),

                  SizedBox(
                    height: 54,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _avatarPresets.length,
                      separatorBuilder: (context, index) => const SizedBox(width: 10),
                      itemBuilder: (context, idx) {
                        final presetUrl = _avatarPresets[idx];
                        final isSelected = selectedUrl == presetUrl;
                        return GestureDetector(
                          onTap: () {
                            setDialogState(() {
                              selectedUrl = presetUrl;
                              zoomLevel = 1.0;
                            });
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected ? AppColors.tealPrimary : AppColors.border(isDark),
                                width: isSelected ? 2.5 : 1,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.network(
                                presetUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (c, e, s) => const Icon(Icons.person),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Custom Image URL Input
                  Text(
                    'Or Enter Image URL:',
                    style: GoogleFonts.plusJakartaSans(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textSecondary(isDark),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: urlController,
                          style: GoogleFonts.plusJakartaSans(fontSize: 12.5, color: AppColors.textPrimary(isDark)),
                          decoration: InputDecoration(
                            hintText: 'https://example.com/photo.jpg',
                            hintStyle: GoogleFonts.plusJakartaSans(fontSize: 12, color: AppColors.textMuted(isDark)),
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            filled: true,
                            fillColor: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: AppColors.border(isDark))),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          if (urlController.text.trim().isNotEmpty) {
                            setDialogState(() {
                              selectedUrl = urlController.text.trim();
                              zoomLevel = 1.0;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.tealPrimary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text('Load', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Actions
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            setState(() {
                              _avatarUrl = ProfileState.defaultAvatar;
                              ProfileState.avatarNotifier.value = ProfileState.defaultAvatar;
                            });
                            Navigator.pop(ctx);
                            _showSnackBar('Profile photo reset to default.');
                          },
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 44),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            side: BorderSide(color: AppColors.border(isDark)),
                          ),
                          child: Text(
                            'Reset',
                            style: GoogleFonts.plusJakartaSans(color: AppColors.textSecondary(isDark), fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _avatarUrl = selectedUrl;
                              ProfileState.avatarNotifier.value = selectedUrl;
                            });
                            Navigator.pop(ctx);
                            _showSnackBar('Profile photo cropped & updated successfully! ✓');
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.tealPrimary,
                            foregroundColor: Colors.white,
                            minimumSize: const Size(double.infinity, 44),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: Text(
                            'Apply & Save Crop',
                            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
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

  void _openEditProfileDialog(bool isDark) {
    final nameCtrl = TextEditingController(text: _fullName);
    final phoneCtrl = TextEditingController(text: _phone);
    final emailCtrl = TextEditingController(text: _email);
    final fatherCtrl = TextEditingController(text: _fatherName);
    final addressCtrl = TextEditingController(text: _address);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          decoration: BoxDecoration(
            color: AppColors.surface(isDark),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.fromLTRB(20, 16, 20, MediaQuery.of(ctx).viewInsets.bottom + 24),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: AppColors.border(isDark),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                Text(
                  'Edit Citizen Profile',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary(isDark),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Update your communication details & photo',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12,
                    color: AppColors.textSecondary(isDark),
                  ),
                ),
                const SizedBox(height: 16),

                // Photo row in edit sheet
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: AppColors.border(isDark)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.tealPrimary, width: 2),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            _avatarUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => const Icon(Icons.person),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Profile Photo',
                              style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.textPrimary(isDark)),
                            ),
                            Text(
                              'Tap to crop and adjust photo',
                              style: GoogleFonts.plusJakartaSans(fontSize: 11, color: AppColors.textSecondary(isDark)),
                            ),
                          ],
                        ),
                      ),
                      TextButton.icon(
                        onPressed: () {
                          Navigator.pop(ctx);
                          _openPhotoCropDialog(isDark);
                        },
                        icon: const Icon(Icons.crop_rounded, size: 16, color: AppColors.tealPrimary),
                        label: Text('Crop/Change', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.tealPrimary)),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),
                _buildTextField('Full Legal Name', nameCtrl, isDark),
                const SizedBox(height: 12),
                _buildTextField('Mobile Number', phoneCtrl, isDark),
                const SizedBox(height: 12),
                _buildTextField('Email Address', emailCtrl, isDark),
                const SizedBox(height: 12),
                _buildTextField('Father / Guardian Name', fatherCtrl, isDark),
                const SizedBox(height: 12),
                _buildTextField('Permanent Address', addressCtrl, isDark),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 44),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _fullName = nameCtrl.text;
                            _phone = phoneCtrl.text;
                            _email = emailCtrl.text;
                            _fatherName = fatherCtrl.text;
                            _address = addressCtrl.text;
                          });
                          // Sync with global state
                          ProfileState.fullNameNotifier.value = nameCtrl.text;
                          ProfileState.phoneNotifier.value = phoneCtrl.text;
                          ProfileState.emailNotifier.value = emailCtrl.text;
                          ProfileState.fatherNameNotifier.value = fatherCtrl.text;
                          ProfileState.addressNotifier.value = addressCtrl.text;

                          Navigator.pop(ctx);
                          _showSnackBar('Profile updated successfully! ✓');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.tealPrimary,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 44),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: Text(
                          'Save Changes',
                          style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700),
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
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary(isDark),
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary(isDark),
          ),
          decoration: InputDecoration(
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            filled: true,
            fillColor: isDark ? AppColors.darkInputFill : const Color(0xFFF8FAFC),
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
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = DocuSewaAuthService();

    return ValueListenableBuilder<String>(
      valueListenable: appLanguageNotifier,
      builder: (context, langCode, _) {
        final strings = AppStrings.getStrings(langCode);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =========================================================================
            // 1. CLEAN & PROFESSIONAL CITIZEN PROFILE HEADER
            // =========================================================================
            Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 14),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface(isDark),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: AppColors.border(isDark)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                    blurRadius: 12,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // High-res Avatar with Interactive Camera / Crop Badge
                      GestureDetector(
                        onTap: () => _openPhotoCropDialog(isDark),
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: AppColors.tealPrimary.withValues(alpha: 0.5),
                                  width: 2.5,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.08),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  _avatarUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: AppColors.tealPrimary,
                                    child: const Center(
                                      child: Text(
                                        'DK',
                                        style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w900,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            // Camera crop badge
                            Positioned(
                              right: -2,
                              bottom: -2,
                              child: Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.tealPrimary,
                                  border: Border.all(
                                    color: AppColors.surface(isDark),
                                    width: 2,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.15),
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                                child: const Icon(Icons.camera_alt_rounded, size: 11, color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Name, Citizen ID, Location
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    _fullName,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 16.5,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary(isDark),
                                      letterSpacing: -0.3,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.verified_rounded,
                                  size: 16,
                                  color: Color(0xFF0D9488),
                                ),
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: isDark ? Colors.white10 : const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: AppColors.border(isDark)),
                                  ),
                                  child: const Text('🇮🇳', style: TextStyle(fontSize: 9.5)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),

                            // Location
                            Row(
                              children: [
                                const Icon(Icons.location_on_rounded, size: 12, color: AppColors.tealPrimary),
                                const SizedBox(width: 3),
                                Expanded(
                                  child: Text(
                                    '$_address, $_state',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w500,
                                      color: AppColors.textSecondary(isDark),
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),

                            // Citizen ID Pill with Copy Action
                            InkWell(
                              onTap: () => _copyToClipboard(_citizenId, 'Citizen ID'),
                              borderRadius: BorderRadius.circular(6),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: AppColors.border(isDark)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'ID: $_citizenId',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary(isDark),
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    Icon(Icons.copy_rounded, size: 10, color: AppColors.textSecondary(isDark)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),
                  Divider(color: AppColors.border(isDark), height: 1),
                  const SizedBox(height: 10),

                  // 3 Clean Status Chips
                  Row(
                    children: [
                      Expanded(
                        child: _buildCleanStatusChip(
                          'KYC STATUS',
                          'Tier 3 Active',
                          const Color(0xFF0D9488),
                          isDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildCleanStatusChip(
                          'DIGILOCKER',
                          '● Linked',
                          const Color(0xFF10B981),
                          isDark,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildCleanStatusChip(
                          'VAULT DOCS',
                          '${widget.vaultCount} Certs →',
                          AppColors.textPrimary(isDark),
                          isDark,
                          onTap: widget.onNavigateToVault,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // =========================================================================
            // 2. SEGMENTED TABS (CLEAN 2 TABS: PERSONAL & KYC, SETTINGS)
            // =========================================================================
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border(isDark)),
              ),
              child: Row(
                children: [
                  _buildSubTabItem(0, strings.tabPersonalKYC, isDark),
                  _buildSubTabItem(1, strings.tabSettings, isDark),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // =========================================================================
            // 3. SUB-TAB CONTENT
            // =========================================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 180),
                child: _buildSelectedTabContent(isDark, auth, strings, langCode),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCleanStatusChip(String label, String value, Color color, bool isDark, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border(isDark)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 8.5,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary(isDark),
                letterSpacing: 0.3,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: color,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubTabItem(int index, String label, bool isDark) {
    final isSelected = _selectedSubTab == index;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedSubTab = index),
        borderRadius: BorderRadius.circular(9),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.tealPrimary
                : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.tealPrimary.withValues(alpha: 0.25),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              color: isSelected
                  ? Colors.white
                  : isDark
                      ? Colors.white70
                      : const Color(0xFF475569),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedTabContent(bool isDark, DocuSewaAuthService auth, AppStrings strings, String langCode) {
    switch (_selectedSubTab) {
      case 0:
        return _buildPersonalDetailsTab(isDark, strings);
      case 1:
      default:
        return _buildSettingsTab(isDark, auth, strings, langCode);
    }
  }

  // ===========================================================================
  // TAB 1: PERSONAL & KYC DETAILS
  // ===========================================================================
  Widget _buildPersonalDetailsTab(bool isDark, AppStrings strings) {
    return Column(
      key: const ValueKey(1),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              strings.personalTitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 14.5,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary(isDark),
              ),
            ),
            TextButton.icon(
              onPressed: () => _openEditProfileDialog(isDark),
              icon: const Icon(Icons.edit_rounded, size: 14, color: AppColors.tealPrimary),
              label: Text(
                strings.editDetails,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.tealPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),

        // Official Credentials
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border(isDark)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'GOVERNMENT CREDENTIALS',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: AppColors.tealPrimary,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              _buildCredentialTile('Aadhaar Number', '•••• $_aadhaarLast4', isDark, verified: true),
              const Divider(height: 12),
              _buildCredentialTile('PAN Number', _panNumber, isDark, verified: true),
              const Divider(height: 12),
              _buildCredentialTile('ABHA Health ID', _abhaId, isDark, verified: true),
              const Divider(height: 12),
              _buildCredentialTile('EPFO UAN Number', _uanNumber, isDark, verified: true),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Contact & Demographics Box
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface(isDark),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border(isDark)),
          ),
          child: Column(
            children: [
              _buildDetailRow(strings.lblFullName, _fullName, isDark),
              const Divider(height: 12),
              _buildDetailRow(strings.lblPhone, _phone, isDark, verified: true),
              const Divider(height: 12),
              _buildDetailRow(strings.lblEmail, _email, isDark, verified: true),
              const Divider(height: 12),
              _buildDetailRow(strings.lblDob, '$_dob • $_gender', isDark),
              const Divider(height: 12),
              _buildDetailRow(strings.lblBloodGroup, _bloodGroup, isDark),
              const Divider(height: 12),
              _buildDetailRow(strings.lblFather, _fatherName, isDark),
              const Divider(height: 12),
              _buildDetailRow(strings.lblAddress, '$_address, $_pincode', isDark),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCredentialTile(String label, String value, bool isDark, {bool verified = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary(isDark),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary(isDark),
              ),
            ),
            if (verified) ...[
              const SizedBox(width: 4),
              const Icon(Icons.check_circle_rounded, size: 13, color: Color(0xFF16A34A)),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, bool isDark, {bool verified = false}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary(isDark),
          ),
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary(isDark),
                  ),
                ),
              ),
              if (verified) ...[
                const SizedBox(width: 4),
                const Icon(Icons.check_circle_rounded, size: 12, color: Color(0xFF16A34A)),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // TAB 2: SETTINGS (CLEAN & SINGLE-LINE ALIGNED)
  // ===========================================================================
  Widget _buildSettingsTab(bool isDark, DocuSewaAuthService auth, AppStrings strings, String langCode) {
    return Column(
      key: const ValueKey(2),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // =====================================================================
        // REGIONAL PORTAL LANGUAGE (CLEAN DROPDOWN SELECTOR)
        // =====================================================================
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.surface(isDark),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border(isDark)),
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
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.tealPrimary.withValues(alpha: isDark ? 0.2 : 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.translate_rounded,
                          size: 16,
                          color: AppColors.tealPrimary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        strings.portalLanguage,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary(isDark),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
                    decoration: BoxDecoration(
                      color: AppColors.tealPrimary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '3 REGIONS',
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: AppColors.tealPrimary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border(isDark)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: ['en', 'hi', 'pa'].contains(langCode) ? langCode : 'en',
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.tealPrimary,
                    ),
                    dropdownColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    items: [
                      DropdownMenuItem(
                        value: 'en',
                        child: Row(
                          children: [
                            const Text('🇬🇧', style: TextStyle(fontSize: 15)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'English (Default Portal Language)',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary(isDark),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'hi',
                        child: Row(
                          children: [
                            const Text('🇮🇳', style: TextStyle(fontSize: 15)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'हिन्दी (Hindi · राष्ट्रीय आधिकारिक भाषा)',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary(isDark),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'pa',
                        child: Row(
                          children: [
                            const Text('🇮🇳', style: TextStyle(fontSize: 15)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                'ਪੰਜਾਬੀ (Punjabi · ਖੇਤਰੀ ਭਾਸ਼ਾ)',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary(isDark),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null && val != langCode) {
                        appLanguageNotifier.value = val;
                        _showSnackBar(
                          val == 'hi'
                              ? 'भाषा हिन्दी में बदली गई'
                              : val == 'pa'
                                  ? 'ਭਾਸ਼ਾ ਪੰਜਾਬੀ ਵਿੱਚ ਬਦਲੀ ਗਈ'
                                  : 'Language switched to English',
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Security Toggles
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surface(isDark),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border(isDark)),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.twoFactorTitle,
                          style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary(isDark)),
                        ),
                        Text(
                          strings.twoFactorDesc,
                          style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.textSecondary(isDark)),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _twoFactorEnabled,
                    activeThumbColor: AppColors.tealPrimary,
                    onChanged: (val) {
                      setState(() => _twoFactorEnabled = val);
                      _showSnackBar('2FA Authentication ${val ? "Enabled" : "Disabled"}');
                    },
                  ),
                ],
              ),
              const Divider(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.bioLockTitle,
                          style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.textPrimary(isDark)),
                        ),
                        Text(
                          strings.bioLockDesc,
                          style: GoogleFonts.plusJakartaSans(fontSize: 10.5, color: AppColors.textSecondary(isDark)),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: _biometricLockEnabled,
                    activeThumbColor: AppColors.tealPrimary,
                    onChanged: (val) {
                      setState(() => _biometricLockEnabled = val);
                      _showSnackBar('Biometric Protection ${val ? "Locked" : "Unlocked"}');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Expiry & Renewal Alerts Box (Clean Single Line Rows)
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurfaceSubtle : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border(isDark)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.alertsTitle,
                style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.textPrimary(isDark)),
              ),
              const SizedBox(height: 8),

              // WhatsApp Alert Single Line Row
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surface(isDark),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border(isDark)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        strings.whatsappAlerts,
                        style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary(isDark)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _whatsappAlerts,
                        activeColor: AppColors.tealPrimary,
                        onChanged: (val) => setState(() => _whatsappAlerts = val ?? true),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 6),

              // SMS Alert Single Line Row
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.surface(isDark),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border(isDark)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        strings.smsAlerts,
                        style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.textPrimary(isDark)),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      height: 24,
                      width: 24,
                      child: Checkbox(
                        value: _smsAlerts,
                        activeColor: AppColors.tealPrimary,
                        onChanged: (val) => setState(() => _smsAlerts = val ?? true),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // Action Buttons Row (Single Line Aligned)
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _showSnackBar('Citizen archive (JSON) exported!'),
                icon: const Icon(Icons.archive_outlined, size: 14),
                label: Text(
                  strings.exportData,
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 42),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  side: BorderSide(color: AppColors.border(isDark)),
                  foregroundColor: AppColors.textPrimary(isDark),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () async {
                  await auth.signOut();
                },
                icon: const Icon(Icons.logout_rounded, size: 15),
                label: Text(
                  strings.signOut,
                  style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFFF1F2),
                  foregroundColor: const Color(0xFFE11D48),
                  minimumSize: const Size(double.infinity, 42),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFFFECDD3)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
