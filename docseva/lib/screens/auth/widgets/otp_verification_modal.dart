import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docusewa/config/supabase_config.dart';
import 'package:docusewa/services/auth_service.dart';
import 'package:docusewa/theme/app_colors.dart';
import 'package:docusewa/screens/auth/widgets/otp_input_row.dart';

enum _VerifyState { idle, verifying, success, error }

/// Professional, minimal OTP verification modal matching the Web interface.
class OtpVerificationModal extends StatefulWidget {
  final String target;
  final bool isEmail;
  final bool isDark;
  final VoidCallback onEditNumber;
  final VoidCallback onVerified;

  const OtpVerificationModal({
    super.key,
    required this.target,
    this.isEmail = false,
    required this.isDark,
    required this.onEditNumber,
    required this.onVerified,
  });

  @override
  State<OtpVerificationModal> createState() => _OtpVerificationModalState();
}

class _OtpVerificationModalState extends State<OtpVerificationModal> {
  final _auth = DocuSewaAuthService();
  final _otpRowKey = GlobalKey<OtpInputRowState>();

  // Timer state
  Timer? _countdownTimer;
  int _secondsRemaining = SupabaseConfig.resendCooldownSeconds;
  bool _canResend = false;

  // Input state
  String _enteredOtp = '';

  // UI state
  _VerifyState _state = _VerifyState.idle;
  String? _errorMessage;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    _secondsRemaining = SupabaseConfig.resendCooldownSeconds;
    _canResend = false;
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsRemaining <= 1) {
        timer.cancel();
        setState(() {
          _secondsRemaining = 0;
          _canResend = true;
        });
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  Future<void> _handleVerify([String? otpToVerify]) async {
    final otp = otpToVerify ?? _enteredOtp;
    if (otp.length < 6) {
      setState(() => _errorMessage = 'Please enter all 6 digits of the OTP.');
      return;
    }

    if (_state == _VerifyState.verifying || _state == _VerifyState.success) {
      return;
    }

    setState(() {
      _state = _VerifyState.verifying;
      _errorMessage = null;
    });

    final result = await _auth.verifyOtp(widget.target, otp);

    if (!mounted) return;

    if (result.success) {
      setState(() => _state = _VerifyState.success);
      await Future.delayed(const Duration(milliseconds: 550));
      if (mounted) widget.onVerified();
    } else {
      setState(() {
        _state = _VerifyState.error;
        _errorMessage = result.errorMessage ?? 'Verification failed';
      });
      _otpRowKey.currentState?.shake();
      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted && _state == _VerifyState.error) {
        _otpRowKey.currentState?.clear();
        setState(() {
          _enteredOtp = '';
          _state = _VerifyState.idle;
        });
      }
    }
  }

  Future<void> _handleResend() async {
    if (!_canResend || _isResending) return;

    setState(() {
      _isResending = true;
      _errorMessage = null;
    });

    final result = await _auth.sendOtp(widget.target);

    if (!mounted) return;

    setState(() => _isResending = false);

    if (result.success) {
      _otpRowKey.currentState?.clear();
      setState(() => _enteredOtp = '');
      _startCountdown();
    } else {
      setState(() => _errorMessage = result.errorMessage);
    }
  }

  String get _displayTarget {
    if (widget.isEmail) return widget.target;
    if (widget.target.length == 10) {
      return '+91 ${widget.target.substring(0, 5)} ${widget.target.substring(5)}';
    }
    return '+91 ${widget.target}';
  }

  String get _timerLabel {
    final s = _secondsRemaining.toString().padLeft(2, '0');
    return '00:$s';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    final screenWidth = MediaQuery.of(context).size.width;
    final isVerySmall = screenWidth < 380;

    return Center(
      child: SingleChildScrollView(
        child: Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          insetPadding: EdgeInsets.symmetric(
            horizontal: isVerySmall ? 12 : 20,
            vertical: 20,
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 420),
            padding: EdgeInsets.all(isVerySmall ? 20 : 28),
            decoration: BoxDecoration(
              color: AppColors.surface(isDark),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.tealSubtle,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.1),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Close Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: widget.onEditNumber,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkSurfaceSubtle : AppColors.tealSurface,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          size: 16,
                          color: AppColors.textMuted(isDark),
                        ),
                      ),
                    ),
                  ],
                ),

                // Title
                Text(
                  _state == _VerifyState.success
                      ? 'Verification Complete'
                      : 'Enter Verification Code',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: isVerySmall ? 18.5 : 21,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary(isDark),
                    letterSpacing: -0.4,
                  ),
                ),
                const SizedBox(height: 5),

                Text(
                  'We sent a 6-digit verification code to',
                  style: GoogleFonts.plusJakartaSans(
                    fontSize: 13,
                    color: AppColors.textSecondary(isDark),
                  ),
                ),
                const SizedBox(height: 8),

                // Target pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 4),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceSubtle : AppColors.tealSurface,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.tealSubtle,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        _displayTarget,
                        style: GoogleFonts.plusJakartaSans(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary(isDark),
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: widget.onEditNumber,
                        child: Text(
                          'Change',
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.tealPrimary,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),

                // 6-digit input row
                OtpInputRow(
                  key: _otpRowKey,
                  isDark: isDark,
                  isError: _state == _VerifyState.error,
                  isSuccess: _state == _VerifyState.success,
                  onCompleted: (otp) {
                    setState(() => _enteredOtp = otp);
                    _handleVerify(otp);
                  },
                  onChanged: () {
                    if (_errorMessage != null) {
                      setState(() => _errorMessage = null);
                    }
                  },
                ),
                const SizedBox(height: 14),

                // Error Message
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 15, color: AppColors.error),
                        const SizedBox(width: 5),
                        Flexible(
                          child: Text(
                            _errorMessage!,
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.error,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],

                // Professional "Verify & Proceed" Button
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: _state == _VerifyState.verifying || _state == _VerifyState.success
                        ? null
                        : () => _handleVerify(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _state == _VerifyState.success
                          ? AppColors.success
                          : AppColors.tealPrimary,
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
                    child: _state == _VerifyState.verifying
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text(
                            _state == _VerifyState.success
                                ? '✓ Verified'
                                : 'Verify & Proceed',
                            style: GoogleFonts.plusJakartaSans(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 14),

                // Resend footer
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurfaceSubtle : AppColors.lightSurfaceSubtle,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.border(isDark),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          "Didn't receive code?",
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 12,
                            color: AppColors.textSecondary(isDark),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      _canResend
                          ? GestureDetector(
                              onTap: _handleResend,
                              child: Text(
                                _isResending ? 'Sending…' : 'Resend OTP',
                                style: GoogleFonts.plusJakartaSans(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.tealPrimary,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            )
                          : Text(
                              'Resend in $_timerLabel',
                              style: GoogleFonts.plusJakartaSans(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.tealPrimary,
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
    );
  }
}
