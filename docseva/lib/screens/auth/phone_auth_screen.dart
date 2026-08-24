import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docusewa/services/auth_service.dart';
import 'package:docusewa/theme/app_colors.dart';
import 'package:docusewa/screens/auth/widgets/otp_verification_modal.dart';
import 'package:docusewa/screens/auth/widgets/google_logo.dart';

/// Responsive DocuSewa Login & Create Account Screen.
/// Pixel-perfect matching with Web (Plus Jakarta Sans + DigiLocker-inspired Teal Theme).
class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final _auth = DocuSewaAuthService();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();

  final _phoneFocus = FocusNode();
  final _emailFocus = FocusNode();

  bool _isPhoneMode = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _phoneFocus.addListener(() => setState(() {}));
    _emailFocus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _emailController.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  bool get _isPhoneValid {
    final digits = _phoneController.text.replaceAll(RegExp(r'\D'), '');
    return digits.length == 10 &&
        int.tryParse(digits[0]) != null &&
        int.tryParse(digits[0])! >= 6;
  }

  bool get _isEmailValid {
    final email = _emailController.text.trim();
    return RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email);
  }

  bool get _isValid => _isPhoneMode ? _isPhoneValid : _isEmailValid;

  Future<void> _handleContinue() async {
    if (!_isValid || _isSubmitting) return;

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    final target = _isPhoneMode
        ? _phoneController.text.replaceAll(RegExp(r'\D'), '')
        : _emailController.text.trim();

    final result = await _auth.sendOtp(target);

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    if (result.success) {
      _showOtpModal(target, !_isPhoneMode);
    } else {
      setState(() => _errorMessage = result.errorMessage);
    }
  }

  void _showOtpModal(String target, bool isEmail) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: 'OTP Verification',
      barrierColor: Colors.black.withValues(alpha: 0.55),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (ctx, anim1, anim2) => OtpVerificationModal(
        target: target,
        isEmail: isEmail,
        isDark: Theme.of(context).brightness == Brightness.dark,
        onEditNumber: () => Navigator.of(ctx).pop(),
        onVerified: () {
          Navigator.of(ctx).pop();
        },
      ),
      transitionBuilder: (ctx, anim, secondaryAnim, child) {
        final curved = CurvedAnimation(
          parent: anim,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  void _showQrModal() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'QR Login',
      barrierColor: Colors.black.withValues(alpha: 0.55),
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (ctx, anim1, anim2) => Dialog(
        backgroundColor: AppColors.surface(isDark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Scan QR Code',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary(isDark),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Scan using DocuSewa Mobile App to log in instantly.',
                textAlign: TextAlign.center,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 13,
                  color: AppColors.textSecondary(isDark),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: 180,
                height: 180,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkSurfaceSubtle : AppColors.tealSurface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.tealSubtle),
                ),
                child: Center(
                  child: Icon(
                    Icons.qr_code_2,
                    size: 140,
                    color: AppColors.textPrimary(isDark),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.of(ctx).pop(),
                  style: TextButton.styleFrom(
                    backgroundColor: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: AppColors.border(isDark)),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    'Close',
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.textPrimary(isDark),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      transitionBuilder: (ctx, anim, secondaryAnim, child) {
        final curved = CurvedAnimation(
          parent: anim,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.95, end: 1.0).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;
    final isWide = size.width > 700;

    return Scaffold(
      backgroundColor: AppColors.background(isDark),
      body: SafeArea(
        child: Column(
          children: [
            // Top Navigation Bar
            Container(
              height: 68,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              decoration: BoxDecoration(
                color: AppColors.surface(isDark),
                border: Border(
                  bottom: BorderSide(color: AppColors.border(isDark)),
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x05000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Indian National Emblem Representation
                  Icon(
                    Icons.account_balance,
                    color: isDark ? AppColors.tealLight : AppColors.tealPrimary,
                    size: 26,
                  ),
                  const SizedBox(width: 14),
                  Container(
                    width: 1,
                    height: 28,
                    color: AppColors.divider(isDark),
                  ),
                  const SizedBox(width: 14),

                  // Brand Logo
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.tealPrimary.withValues(alpha: 0.3),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.description_outlined,
                      color: Colors.white,
                      size: 19,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'DocuSewa',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            color: AppColors.tealPrimary,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          'Document Wallet to Empower Citizens',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textMuted(isDark),
                            letterSpacing: 0.1,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Responsive Scrollable Content
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: isWide ? 32 : 16,
                    vertical: 28,
                  ),
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 460),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Central Card
                        Container(
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            color: AppColors.surface(isDark),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isDark ? AppColors.darkBorder : AppColors.tealSubtle,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.tealPrimary.withValues(alpha: isDark ? 0.2 : 0.04),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Heading
                              Text(
                                'Login or Create Account',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textPrimary(isDark),
                                  letterSpacing: -0.4,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Enter your mobile number or email to proceed',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 13.5,
                                  color: AppColors.textSecondary(isDark),
                                ),
                              ),
                              const SizedBox(height: 20),

                              // Mobile / Email Mode Switcher Tabs
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _isPhoneMode = true;
                                            _errorMessage = null;
                                          });
                                        },
                                        borderRadius: BorderRadius.circular(6),
                                        child: Container(
                                          height: 34,
                                          decoration: BoxDecoration(
                                            color: _isPhoneMode
                                                ? AppColors.surface(isDark)
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(6),
                                            boxShadow: _isPhoneMode
                                                ? [
                                                    BoxShadow(
                                                      color: Colors.black.withValues(alpha: 0.05),
                                                      blurRadius: 2,
                                                      offset: const Offset(0, 1),
                                                    ),
                                                  ]
                                                : [],
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Mobile',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 13.5,
                                              fontWeight: _isPhoneMode ? FontWeight.w600 : FontWeight.w500,
                                              color: _isPhoneMode
                                                  ? AppColors.tealPrimary
                                                  : AppColors.textSecondary(isDark),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            _isPhoneMode = false;
                                            _errorMessage = null;
                                          });
                                        },
                                        borderRadius: BorderRadius.circular(6),
                                        child: Container(
                                          height: 34,
                                          decoration: BoxDecoration(
                                            color: !_isPhoneMode
                                                ? AppColors.surface(isDark)
                                                : Colors.transparent,
                                            borderRadius: BorderRadius.circular(6),
                                            boxShadow: !_isPhoneMode
                                                ? [
                                                    BoxShadow(
                                                      color: Colors.black.withValues(alpha: 0.05),
                                                      blurRadius: 2,
                                                      offset: const Offset(0, 1),
                                                    ),
                                                  ]
                                                : [],
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            'Email',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontSize: 13.5,
                                              fontWeight: !_isPhoneMode ? FontWeight.w600 : FontWeight.w500,
                                              color: !_isPhoneMode
                                                  ? AppColors.tealPrimary
                                                  : AppColors.textSecondary(isDark),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Input Box with smooth switcher transition
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 160),
                                switchInCurve: Curves.easeOut,
                                switchOutCurve: Curves.easeIn,
                                transitionBuilder: (child, animation) {
                                  return FadeTransition(
                                    opacity: animation,
                                    child: child,
                                  );
                                },
                                child: AnimatedContainer(
                                  key: ValueKey<bool>(_isPhoneMode),
                                  duration: const Duration(milliseconds: 150),
                                  decoration: BoxDecoration(
                                    color: AppColors.inputFill(isDark),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: (_isPhoneMode ? _phoneFocus.hasFocus : _emailFocus.hasFocus)
                                          ? AppColors.tealPrimary
                                          : (isDark ? AppColors.darkBorder : AppColors.tealLight),
                                      width: (_isPhoneMode ? _phoneFocus.hasFocus : _emailFocus.hasFocus) ? 2 : 1.5,
                                    ),
                                  ),
                                  child: _isPhoneMode
                                      ? Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                              decoration: BoxDecoration(
                                                border: Border(
                                                  right: BorderSide(color: AppColors.border(isDark)),
                                                ),
                                              ),
                                              child: Text(
                                                '+91',
                                                style: GoogleFonts.plusJakartaSans(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  color: AppColors.textSecondary(isDark),
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              child: TextField(
                                                controller: _phoneController,
                                                focusNode: _phoneFocus,
                                                keyboardType: TextInputType.phone,
                                                style: GoogleFonts.plusJakartaSans(
                                                  fontSize: 15,
                                                  color: AppColors.textPrimary(isDark),
                                                ),
                                                decoration: InputDecoration(
                                                  hintText: 'Mobile number',
                                                  hintStyle: GoogleFonts.plusJakartaSans(
                                                    color: AppColors.textMuted(isDark),
                                                    fontSize: 15,
                                                  ),
                                                  border: InputBorder.none,
                                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                                ),
                                                onChanged: (_) => setState(() {}),
                                                onSubmitted: (_) => _handleContinue(),
                                              ),
                                            ),
                                          ],
                                        )
                                      : TextField(
                                          controller: _emailController,
                                          focusNode: _emailFocus,
                                          keyboardType: TextInputType.emailAddress,
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 15,
                                            color: AppColors.textPrimary(isDark),
                                          ),
                                          decoration: InputDecoration(
                                            hintText: 'Enter your email address',
                                            hintStyle: GoogleFonts.plusJakartaSans(
                                              color: AppColors.textMuted(isDark),
                                              fontSize: 15,
                                            ),
                                            border: InputBorder.none,
                                            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                          ),
                                          onChanged: (_) => setState(() {}),
                                          onSubmitted: (_) => _handleContinue(),
                                        ),
                                ),
                              ),

                              // Demo Quick Fill Row
                              Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Wrap(
                                  alignment: WrapAlignment.spaceBetween,
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  spacing: 8,
                                  runSpacing: 6,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (_isPhoneMode) {
                                          _phoneController.text = kDemoPhone;
                                        } else {
                                          _emailController.text = kDemoEmail;
                                        }
                                        setState(() => _errorMessage = null);
                                      },
                                      borderRadius: BorderRadius.circular(6),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: isDark ? AppColors.darkSurfaceSubtle : AppColors.tealSubtle,
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(
                                            color: isDark ? AppColors.darkBorder : AppColors.tealLight,
                                          ),
                                        ),
                                        child: Text(
                                          '⚡ Auto-fill Demo: ${_isPhoneMode ? kDemoPhone : kDemoEmail}',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            color: isDark ? AppColors.tealLight : AppColors.tealHover,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Text(
                                      'Demo OTP: 123456',
                                      style: GoogleFonts.plusJakartaSans(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textMuted(isDark),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Inline Error
                              if (_errorMessage != null) ...[
                                const SizedBox(height: 8),
                                Text(
                                  _errorMessage!,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontSize: 12.5,
                                    color: AppColors.error,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],

                              const SizedBox(height: 16),

                              // Continue Button
                              SizedBox(
                                width: double.infinity,
                                height: 46,
                                child: ElevatedButton(
                                  onPressed: _isValid && !_isSubmitting ? _handleContinue : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.tealPrimary,
                                    disabledBackgroundColor: isDark
                                        ? AppColors.tealDark.withValues(alpha: 0.4)
                                        : AppColors.tealLight,
                                    foregroundColor: Colors.white,
                                    disabledForegroundColor: isDark ? Colors.white38 : AppColors.tealHover,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: _isSubmitting
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        )
                                      : Text(
                                          'Continue',
                                          style: GoogleFonts.plusJakartaSans(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                ),
                              ),

                              const SizedBox(height: 14),

                              // Terms of Service
                              Center(
                                child: Text.rich(
                                  TextSpan(
                                    text: 'By continuing, I agree to the ',
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 12,
                                      color: AppColors.textMuted(isDark),
                                    ),
                                    children: [
                                      TextSpan(
                                        text: 'Terms of Service',
                                        style: GoogleFonts.plusJakartaSans(
                                          color: AppColors.tealPrimary,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),

                              // Divider with "or"
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: AppColors.border(isDark),
                                        thickness: 1,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12),
                                      child: Text(
                                        'or',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 12.5,
                                          color: AppColors.textMuted(isDark),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: AppColors.border(isDark),
                                        thickness: 1,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Continue with Google Button (Official Vector Google Logo)
                              OutlinedButton(
                                onPressed: () {
                                  // Trigger Google OAuth via Supabase
                                },
                                style: OutlinedButton.styleFrom(
                                  minimumSize: const Size(double.infinity, 46),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  side: BorderSide(color: AppColors.border(isDark)),
                                  backgroundColor: AppColors.surface(isDark),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const GoogleLogo(size: 18),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Text(
                                        'Continue with Google',
                                        style: GoogleFonts.plusJakartaSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: AppColors.textPrimary(isDark),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 12),

                              // Login using QR Code
                              InkWell(
                                onTap: _showQrModal,
                                borderRadius: BorderRadius.circular(10),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: AppColors.border(isDark)),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          color: isDark ? AppColors.darkSurfaceSubtle : AppColors.tealSurface,
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(
                                          Icons.qr_code_scanner,
                                          color: AppColors.tealPrimary,
                                          size: 20,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Login using QR Code',
                                              style: GoogleFonts.plusJakartaSans(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700,
                                                color: AppColors.textPrimary(isDark),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 2),
                                            Text.rich(
                                              TextSpan(
                                                text: 'Scan using ',
                                                style: GoogleFonts.plusJakartaSans(
                                                  fontSize: 12,
                                                  color: AppColors.textSecondary(isDark),
                                                ),
                                                children: [
                                                  TextSpan(
                                                    text: 'DocuSewa Mobile App',
                                                    style: GoogleFonts.plusJakartaSans(
                                                      color: AppColors.tealPrimary,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
