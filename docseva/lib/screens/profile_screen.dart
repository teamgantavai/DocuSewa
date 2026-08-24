import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docusewa/services/auth_service.dart';
import 'package:docusewa/theme/app_colors.dart';
import 'package:docusewa/config/translations.dart';

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
  int _selectedSubTab = 0; // 0: Digital ID, 1: Personal & KYC, 2: Linked Portals, 3: Security & Consent, 4: Preferences

  // Profile data state
  String _fullName = 'Dilkhush Kumar';
  String _phone = '+91 98765 43210';
  String _email = 'dilkhush.citizen@docusewa.gov.in';
  String _dob = '15 Aug 1998';
  String _gender = 'Male';
  String _bloodGroup = 'O+ Positive';
  String _fatherName = 'Rajendra Kumar';
  String _address = 'H-42, Sector 62, Electronic City, Noida';
  String _state = 'Uttar Pradesh';
  String _pincode = '201301';
  final String _citizenId = 'DS-IN-2026-89210';
  final String _aadhaarLast4 = '8921';
  final String _panNumber = 'ABCDE1234F';

  // Security toggles
  bool _twoFactorEnabled = true;
  bool _biometricLockEnabled = true;

  // Preferences
  bool _whatsappAlerts = true;
  bool _smsAlerts = true;

  // Syncing state
  bool _isSyncing = false;

  // Linked accounts
  late List<Map<String, dynamic>> _linkedAccounts;

  // Consent logs
  late List<Map<String, dynamic>> _consentLogs;

  @override
  void initState() {
    super.initState();
    _linkedAccounts = [
      {
        'id': 'uidai',
        'name': 'UIDAI Aadhaar System',
        'dept': 'Unique Identification Authority of India',
        'identifier': 'XXXXXXXX8921',
        'status': 'Connected',
        'lastSynced': '2 mins ago',
        'color': const Color(0xFFEA580C),
      },
      {
        'id': 'itd',
        'name': 'e-Filing PAN Database',
        'dept': 'Income Tax Department, Govt of India',
        'identifier': 'ABCDE1234F',
        'status': 'Connected',
        'lastSynced': 'Yesterday, 18:30',
        'color': const Color(0xFF0D9488),
      },
      {
        'id': 'digilocker',
        'name': 'DigiLocker Central Vault',
        'dept': 'National e-Governance Division (MeitY)',
        'identifier': 'DL-IN-987654',
        'status': 'Live Sync',
        'lastSynced': 'Live Sync Active',
        'color': const Color(0xFF2563EB),
      },
      {
        'id': 'morth',
        'name': 'Parivahan Sarathi / Vahan',
        'dept': 'Ministry of Road Transport & Highways',
        'identifier': 'DL-04202100892',
        'status': 'Connected',
        'lastSynced': '12 Feb 2026',
        'color': const Color(0xFF16A34A),
      },
      {
        'id': 'nha',
        'name': 'Ayushman Bharat ABHA Health ID',
        'dept': 'National Health Authority',
        'identifier': '91-8921-4412-3320',
        'status': 'Connected',
        'lastSynced': '04 Jan 2026',
        'color': const Color(0xFF9333EA),
      },
      {
        'id': 'epfo',
        'name': 'EPFO Member Unified Portal',
        'dept': 'Employees’ Provident Fund Organisation',
        'identifier': 'UAN 101293849120',
        'status': 'Connected',
        'lastSynced': '28 Jan 2026',
        'color': const Color(0xFFB45309),
      },
    ];

    _consentLogs = [
      {
        'id': 'c-1',
        'portal': 'State Bank of India (KYC)',
        'purpose': 'Instant Account Opening & CIBIL Check',
        'docs': 'Aadhaar e-KYC, PAN Verification',
        'date': '22 Feb 2026, 11:20 AM',
        'active': true,
      },
      {
        'id': 'c-2',
        'portal': 'UPSC One Time Registration',
        'purpose': 'Candidate Age & Domicile Verification',
        'docs': 'Class X Marksheet, Aadhaar ID',
        'date': '10 Feb 2026, 04:15 PM',
        'active': true,
      },
      {
        'id': 'c-3',
        'portal': 'National Testing Agency (NTA)',
        'purpose': 'Exam Center Biometric Match',
        'docs': 'Aadhaar ID, Passport Photo',
        'date': '15 Jan 2026, 09:30 AM',
        'active': true,
      },
    ];
  }

  void _showSnackBar(String message, {bool isSuccess = true}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isSuccess ? Icons.check_circle_rounded : Icons.info_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    _showSnackBar('Copied $label to clipboard!');
  }

  void _syncAllPortals() {
    setState(() => _isSyncing = true);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() {
          _isSyncing = false;
          for (var item in _linkedAccounts) {
            item['lastSynced'] = 'Just now (Verified)';
          }
        });
        _showSnackBar('All 6 Government Portals synchronized with National Gateway!');
      }
    });
  }

  void _openEditProfileDialog(bool isDark) {
    final nameCtrl = TextEditingController(text: _fullName);
    final phoneCtrl = TextEditingController(text: _phone);
    final emailCtrl = TextEditingController(text: _email);
    final dobCtrl = TextEditingController(text: _dob);
    final genderCtrl = TextEditingController(text: _gender);
    final addressCtrl = TextEditingController(text: _address);
    final stateCtrl = TextEditingController(text: _state);
    final pincodeCtrl = TextEditingController(text: _pincode);
    final fatherCtrl = TextEditingController(text: _fatherName);
    final bloodCtrl = TextEditingController(text: _bloodGroup);

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
                  'Update your contact details and communication address',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    color: AppColors.textSecondary(isDark),
                  ),
                ),
                const SizedBox(height: 16),

                _buildTextField('Full Legal Name', nameCtrl, isDark),
                const SizedBox(height: 12),
                _buildTextField('Mobile Number', phoneCtrl, isDark),
                const SizedBox(height: 12),
                _buildTextField('Email Address', emailCtrl, isDark),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildTextField('Date of Birth', dobCtrl, isDark)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildTextField('Gender', genderCtrl, isDark)),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTextField('Father / Guardian Name', fatherCtrl, isDark),
                const SizedBox(height: 12),
                _buildTextField('Blood Group', bloodCtrl, isDark),
                const SizedBox(height: 12),
                _buildTextField('Permanent Address', addressCtrl, isDark),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildTextField('State', stateCtrl, isDark)),
                    const SizedBox(width: 10),
                    Expanded(child: _buildTextField('Pincode', pincodeCtrl, isDark)),
                  ],
                ),
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
                            _dob = dobCtrl.text;
                            _gender = genderCtrl.text;
                            _fatherName = fatherCtrl.text;
                            _bloodGroup = bloodCtrl.text;
                            _address = addressCtrl.text;
                            _state = stateCtrl.text;
                            _pincode = pincodeCtrl.text;
                          });
                          Navigator.pop(ctx);
                          _showSnackBar('Citizen profile details updated successfully!');
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
            // TOP BANNER: CITIZEN SUMMARY & HERO
            // =========================================================================
            Container(
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF042F2E), Color(0xFF0F766E), Color(0xFF0D9488)],
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.tealPrimary.withValues(alpha: 0.25),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      // Avatar with Verified badge
                      Stack(
                        children: [
                          Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: const LinearGradient(
                                colors: [Color(0xFF14B8A6), Color(0xFF0F766E)],
                              ),
                              border: Border.all(color: Colors.white, width: 2.5),
                              boxShadow: const [
                                BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3)),
                              ],
                            ),
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
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF10B981),
                              ),
                              child: const Icon(Icons.check_rounded, size: 14, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 14),

                      // Name & ID
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
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                      letterSpacing: -0.3,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: const Text('🇮🇳', style: TextStyle(fontSize: 10)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'ID: $_citizenId',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFFCCFBF1),
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              strings.verifiedAccount,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF99F6E4),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),
                  const Divider(color: Colors.white24, height: 1),
                  const SizedBox(height: 12),

                  // Metrics Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildHeaderMetric(strings.aadhaarSeeded, '•••• $_aadhaarLast4'),
                      _buildHeaderMetric(strings.panNumber, _panNumber),
                      _buildHeaderMetric(strings.vaultRecords, '${widget.vaultCount} Docs'),
                      _buildHeaderMetric(strings.securityStatus, strings.secHigh, color: const Color(0xFF4ADE80)),
                    ],
                  ),
                ],
              ),
            ),

            // =========================================================================
            // HORIZONTAL SUB-NAVIGATION TABS
            // =========================================================================
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildSubTabItem(0, strings.tabDigitalPass, isDark),
                  const SizedBox(width: 8),
                  _buildSubTabItem(1, strings.tabPersonalKYC, isDark),
                  const SizedBox(width: 8),
                  _buildSubTabItem(2, '${strings.tabLinkedPortals} (${_linkedAccounts.length})', isDark),
                  const SizedBox(width: 8),
                  _buildSubTabItem(3, strings.tabSecurity, isDark),
                  const SizedBox(width: 8),
                  _buildSubTabItem(4, strings.tabSettings, isDark),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // =========================================================================
            // SUB-TAB CONTENT
            // =========================================================================
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: _buildSelectedTabContent(isDark, auth, strings, langCode),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHeaderMetric(String label, String value, {Color color = Colors.white}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 9.5,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF99F6E4),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 11.5,
            fontWeight: FontWeight.w800,
            color: color,
          ),
        ),
      ],
    );
  }

  Widget _buildSubTabItem(int index, String label, bool isDark) {
    final isSelected = _selectedSubTab == index;
    return InkWell(
      onTap: () => setState(() => _selectedSubTab = index),
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.tealPrimary
              : isDark
                  ? AppColors.darkSurfaceSubtle
                  : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? AppColors.tealPrimary
                : isDark
                    ? AppColors.darkBorder
                    : const Color(0xFFE2E8F0),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected
                ? Colors.white
                : isDark
                    ? Colors.white70
                    : const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  Widget _buildSelectedTabContent(bool isDark, DocuSewaAuthService auth, AppStrings strings, String langCode) {
    switch (_selectedSubTab) {
      case 0:
        return _buildDigitalCardTab(isDark, strings);
      case 1:
        return _buildPersonalDetailsTab(isDark, strings);
      case 2:
        return _buildLinkedAccountsTab(isDark, strings);
      case 3:
        return _buildSecurityTab(isDark, strings);
      case 4:
      default:
        return _buildPreferencesTab(isDark, auth, strings, langCode);
    }
  }

  // ===========================================================================
  // TAB 0: DIGITAL CARD (DIGICARD)
  // ===========================================================================
  Widget _buildDigitalCardTab(bool isDark, AppStrings strings) {
    return Column(
      key: const ValueKey(0),
      children: [
        // Digital Citizen Pass Card
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF092E2B), Color(0xFF0D5952), Color(0xFF0A423D)],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0xFF5EEAD4).withValues(alpha: 0.3), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: AppColors.tealPrimary.withValues(alpha: 0.25),
                blurRadius: 18,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card Top Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('🇮🇳', style: TextStyle(fontSize: 16)),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            strings.govtOfIndia,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF5EEAD4),
                              letterSpacing: 0.5,
                            ),
                          ),
                          Text(
                            strings.citizenPass,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF134E4A),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF2DD4BF)),
                    ),
                    child: Text(
                      strings.digilockerVerified,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 9,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF5EEAD4),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Middle: Photo & Details
              Row(
                children: [
                  Container(
                    width: 64,
                    height: 78,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF14B8A6), Color(0xFF0F766E)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('DK', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                        SizedBox(height: 2),
                        Text('CITIZEN', style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w800, color: Colors.white70)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.lblFullName.toUpperCase(),
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF99F6E4),
                            letterSpacing: 0.4,
                          ),
                        ),
                        Text(
                          _fullName,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  strings.lblDob.toUpperCase(),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF99F6E4),
                                  ),
                                ),
                                Text(
                                  _dob,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  strings.lblGender.toUpperCase(),
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 8,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF99F6E4),
                                  ),
                                ),
                                Text(
                                  _gender,
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
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 18),

              // Card Bottom Strip
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'CITIZEN ID NUMBER',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF99F6E4),
                            letterSpacing: 0.4,
                          ),
                        ),
                        Text(
                          _citizenId,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Center(
                        child: Icon(Icons.qr_code_2_rounded, size: 22, color: Color(0xFF0F172A)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Action Buttons
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: () => _copyToClipboard(_citizenId, 'Citizen ID'),
                icon: const Icon(Icons.copy_rounded, size: 15),
                label: Text(
                  strings.copyId,
                  style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 42),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  side: BorderSide(color: AppColors.border(isDark)),
                  foregroundColor: AppColors.textPrimary(isDark),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => _showSnackBar('Citizen Pass downloaded as PKCS#7 signed file!'),
                icon: const Icon(Icons.download_rounded, size: 16),
                label: Text(
                  strings.downloadPass,
                  style: GoogleFonts.plusJakartaSans(fontSize: 12.5, fontWeight: FontWeight.w700),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.tealPrimary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 42),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
              ),
            ),
          ],
        ),
      ],
    );
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
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary(isDark),
              ),
            ),
            TextButton.icon(
              onPressed: () => _openEditProfileDialog(isDark),
              icon: const Icon(Icons.edit_rounded, size: 15, color: AppColors.tealPrimary),
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
        const SizedBox(height: 8),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface(isDark),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border(isDark)),
          ),
          child: Column(
            children: [
              _buildDetailRow(strings.lblFullName, _fullName, isDark),
              const Divider(height: 18),
              _buildDetailRow(strings.lblPhone, _phone, isDark, verified: true),
              const Divider(height: 18),
              _buildDetailRow(strings.lblEmail, _email, isDark, verified: true),
              const Divider(height: 18),
              _buildDetailRow(strings.lblDob, _dob, isDark),
              const Divider(height: 18),
              _buildDetailRow(strings.lblGender, _gender, isDark),
              const Divider(height: 18),
              _buildDetailRow(strings.lblBloodGroup, _bloodGroup, isDark),
              const Divider(height: 18),
              _buildDetailRow(strings.lblFather, _fatherName, isDark),
              const Divider(height: 18),
              _buildDetailRow(strings.lblState, _state, isDark),
              const Divider(height: 18),
              _buildDetailRow(strings.lblAddress, '$_address, $_pincode', isDark),
            ],
          ),
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
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: AppColors.textSecondary(isDark),
          ),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(
                  value,
                  textAlign: TextAlign.right,
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary(isDark),
                  ),
                ),
              ),
              if (verified) ...[
                const SizedBox(width: 4),
                const Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF16A34A)),
              ],
            ],
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // TAB 2: LINKED GOVT ACCOUNTS
  // ===========================================================================
  Widget _buildLinkedAccountsTab(bool isDark, AppStrings strings) {
    return Column(
      key: const ValueKey(2),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              strings.linkedTitle,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary(isDark),
              ),
            ),
            InkWell(
              onTap: _isSyncing ? null : _syncAllPortals,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF042F2E) : const Color(0xFFF0FDFA),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFCCFBF1)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _isSyncing
                        ? const SizedBox(
                            width: 12,
                            height: 12,
                            child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.tealPrimary),
                          )
                        : const Icon(Icons.sync_rounded, size: 14, color: AppColors.tealPrimary),
                    const SizedBox(width: 4),
                    Text(
                      _isSyncing ? strings.syncing : strings.syncAll,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.tealPrimary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),

        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _linkedAccounts.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (ctx, idx) {
            final acc = _linkedAccounts[idx];
            return Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.surface(isDark),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.border(isDark)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: (acc['color'] as Color).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Icon(Icons.account_balance_rounded, size: 20, color: acc['color'] as Color),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                acc['name'] as String,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary(isDark),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                              decoration: BoxDecoration(
                                color: const Color(0xFFDCFCE7),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                strings.lblLinked,
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF16A34A),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          acc['dept'] as String,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 10.5,
                            color: AppColors.textSecondary(isDark),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              acc['identifier'] as String,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white70 : const Color(0xFF0F172A),
                              ),
                            ),
                            Text(
                              acc['lastSynced'] as String,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: AppColors.tealPrimary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // ===========================================================================
  // TAB 3: SECURITY & PRIVACY
  // ===========================================================================
  Widget _buildSecurityTab(bool isDark, AppStrings strings) {
    return Column(
      key: const ValueKey(3),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.securityTitle,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary(isDark),
          ),
        ),
        const SizedBox(height: 10),

        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface(isDark),
            borderRadius: BorderRadius.circular(16),
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
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary(isDark),
                          ),
                        ),
                        Text(
                          strings.twoFactorDesc,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: AppColors.textSecondary(isDark),
                          ),
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
              const Divider(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          strings.bioLockTitle,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary(isDark),
                          ),
                        ),
                        Text(
                          strings.bioLockDesc,
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11,
                            color: AppColors.textSecondary(isDark),
                          ),
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

        const SizedBox(height: 18),

        // Consent Logs
        Text(
          strings.consentTitle,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary(isDark),
          ),
        ),
        const SizedBox(height: 10),

        ..._consentLogs.map(
          (log) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface(isDark),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border(isDark)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              log['portal'] as String,
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary(isDark),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                            decoration: BoxDecoration(
                              color: (log['active'] as bool) ? const Color(0xFFDCFCE7) : const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              (log['active'] as bool) ? 'Active' : 'Revoked',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: (log['active'] as bool) ? const Color(0xFF16A34A) : const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Shared: ${log['docs']}',
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 10.5,
                          color: AppColors.textSecondary(isDark),
                        ),
                      ),
                      Text(
                        log['date'] as String,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 9.5,
                          color: isDark ? Colors.white38 : const Color(0xFF94A3B8),
                        ),
                      ),
                    ],
                  ),
                ),
                if (log['active'] as bool)
                  TextButton(
                    onPressed: () {
                      setState(() => log['active'] = false);
                      _showSnackBar('Authorization revoked for ${log['portal']}');
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFE11D48),
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                    ),
                    child: Text(
                      strings.revoke,
                      style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w700),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // TAB 4: PREFERENCES & SIGN OUT
  // ===========================================================================
  Widget _buildPreferencesTab(bool isDark, DocuSewaAuthService auth, AppStrings strings, String langCode) {
    final currentDropdownVal = langCode == 'hi'
        ? 'हिंदी (Hindi)'
        : langCode == 'pa'
            ? 'ਪੰਜਾਬੀ (Punjabi)'
            : 'English (Default)';

    return Column(
      key: const ValueKey(4),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.preferencesTitle,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary(isDark),
          ),
        ),
        const SizedBox(height: 10),

        // Language Box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface(isDark),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border(isDark)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.portalLanguage,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary(isDark),
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                initialValue: currentDropdownVal,
                isExpanded: true,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  filled: true,
                  fillColor: isDark ? AppColors.darkInputFill : const Color(0xFFF8FAFC),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AppColors.border(isDark)),
                  ),
                ),
                dropdownColor: AppColors.surface(isDark),
                items: [
                  'English (Default)',
                  'हिंदी (Hindi)',
                  'ਪੰਜਾਬੀ (Punjabi)',
                ].map((lang) {
                  return DropdownMenuItem(
                    value: lang,
                    child: Text(
                      lang,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 13,
                        color: AppColors.textPrimary(isDark),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    if (val.contains('Hindi')) {
                      appLanguageNotifier.value = 'hi';
                    } else if (val.contains('Punjabi')) {
                      appLanguageNotifier.value = 'pa';
                    } else {
                      appLanguageNotifier.value = 'en';
                    }
                    _showSnackBar('Language set to $val');
                  }
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Notifications Box
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface(isDark),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border(isDark)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                strings.alertsTitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary(isDark),
                ),
              ),
              const SizedBox(height: 10),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                value: _whatsappAlerts,
                activeColor: AppColors.tealPrimary,
                title: Text(
                  strings.whatsappAlerts,
                  style: GoogleFonts.plusJakartaSans(fontSize: 12.5, color: AppColors.textPrimary(isDark)),
                ),
                onChanged: (val) => setState(() => _whatsappAlerts = val ?? true),
              ),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                dense: true,
                value: _smsAlerts,
                activeColor: AppColors.tealPrimary,
                title: Text(
                  strings.smsAlerts,
                  style: GoogleFonts.plusJakartaSans(fontSize: 12.5, color: AppColors.textPrimary(isDark)),
                ),
                onChanged: (val) => setState(() => _smsAlerts = val ?? true),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Export Data
        OutlinedButton.icon(
          onPressed: () => _showSnackBar('Full encrypted citizen archive (JSON) created!'),
          icon: const Icon(Icons.archive_outlined, size: 16),
          label: Text(
            strings.exportData,
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13),
          ),
          style: OutlinedButton.styleFrom(
            minimumSize: const Size(double.infinity, 44),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            side: BorderSide(color: AppColors.border(isDark)),
            foregroundColor: AppColors.textPrimary(isDark),
          ),
        ),

        const SizedBox(height: 12),

        // Sign Out Button
        ElevatedButton.icon(
          onPressed: () async {
            await auth.signOut();
          },
          icon: const Icon(Icons.logout_rounded, size: 18),
          label: Text(
            strings.signOut,
            style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w700, fontSize: 13.5),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFFF1F2),
            foregroundColor: const Color(0xFFE11D48),
            minimumSize: const Size(double.infinity, 46),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Color(0xFFFECDD3)),
            ),
          ),
        ),
      ],
    );
  }
}
