import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:docusewa/theme/app_colors.dart';

/// Six responsive OTP digit boxes with auto-advance, paste support,
/// keyboard navigation, and shake animation on error.
class OtpInputRow extends StatefulWidget {
  final bool isDark;
  final bool isError;
  final bool isSuccess;
  final ValueChanged<String> onCompleted;
  final VoidCallback? onChanged;

  const OtpInputRow({
    super.key,
    required this.isDark,
    required this.onCompleted,
    this.isError = false,
    this.isSuccess = false,
    this.onChanged,
  });

  @override
  State<OtpInputRow> createState() => OtpInputRowState();
}

class OtpInputRowState extends State<OtpInputRow>
    with SingleTickerProviderStateMixin {
  static const int _length = 6;

  final List<TextEditingController> _controllers =
      List.generate(_length, (_) => TextEditingController());
  final List<FocusNode> _focusNodes =
      List.generate(_length, (_) => FocusNode());

  late final AnimationController _shakeController;
  late final Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _shakeAnimation = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -8.0), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 8.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 8.0, end: -6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: -6.0, end: 6.0), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 6.0, end: 0.0), weight: 1),
    ]).animate(CurvedAnimation(
      parent: _shakeController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _shakeController.dispose();
    super.dispose();
  }

  /// Triggers shake animation (called by parent on error).
  void shake() {
    _shakeController.forward(from: 0);
  }

  /// Clears all boxes and refocuses first input.
  void clear() {
    for (final c in _controllers) {
      c.clear();
    }
    _focusNodes[0].requestFocus();
  }

  String get _currentOtp => _controllers.map((c) => c.text).join();

  void _onDigitChanged(int index, String value) {
    widget.onChanged?.call();

    if (value.length == 6) {
      // Full paste — distribute across all boxes
      for (int i = 0; i < _length; i++) {
        _controllers[i].text = i < value.length ? value[i] : '';
      }
      _focusNodes[_length - 1].requestFocus();
      final otp = _currentOtp;
      if (otp.length == 6) {
        widget.onCompleted(otp);
      }
      return;
    }

    if (value.isNotEmpty) {
      // Move to next box
      if (index < _length - 1) {
        _focusNodes[index + 1].requestFocus();
      } else {
        _focusNodes[index].unfocus();
      }
      final otp = _currentOtp;
      if (otp.length == 6) {
        widget.onCompleted(otp);
      }
    }
  }

  void _onKeyEvent(int index, KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion = MediaQuery.of(context).disableAnimations;

    Widget row = LayoutBuilder(
      builder: (context, constraints) {
        // Calculate max box size based on available width
        final availableWidth = constraints.maxWidth;
        // 6 boxes with 5 gaps of 6px = 30px gaps
        final calculatedBoxWidth = ((availableWidth - 36) / 6).clamp(32.0, 46.0);
        final boxHeight = (calculatedBoxWidth * 1.15).clamp(40.0, 54.0);

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_length, (i) {
            return Flexible(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: calculatedBoxWidth,
                  maxHeight: boxHeight,
                ),
                margin: EdgeInsets.symmetric(
                  horizontal: calculatedBoxWidth < 38 ? 2.0 : 3.5,
                ),
                child: _OtpBox(
                  controller: _controllers[i],
                  focusNode: _focusNodes[i],
                  isDark: widget.isDark,
                  isError: widget.isError,
                  isSuccess: widget.isSuccess,
                  boxWidth: calculatedBoxWidth,
                  boxHeight: boxHeight,
                  onChanged: (val) => _onDigitChanged(i, val),
                  onKeyEvent: (event) => _onKeyEvent(i, event),
                ),
              ),
            );
          }),
        );
      },
    );

    if (reduceMotion) return row;

    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnimation.value, 0),
          child: child,
        );
      },
      child: row,
    );
  }
}

class _OtpBox extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isDark;
  final bool isError;
  final bool isSuccess;
  final double boxWidth;
  final double boxHeight;
  final ValueChanged<String> onChanged;
  final ValueChanged<KeyEvent> onKeyEvent;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.isDark,
    required this.isError,
    required this.isSuccess,
    required this.boxWidth,
    required this.boxHeight,
    required this.onChanged,
    required this.onKeyEvent,
  });

  @override
  State<_OtpBox> createState() => _OtpBoxState();
}

class _OtpBoxState extends State<_OtpBox> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      if (mounted) {
        setState(() {
          _isFocused = widget.focusNode.hasFocus;
        });
      }
    });
  }

  Color get _borderColor {
    if (widget.isError) return AppColors.error;
    if (widget.isSuccess) return AppColors.success;
    if (_isFocused) return AppColors.tealPrimary;
    return AppColors.border(widget.isDark);
  }

  Color get _bgColor {
    if (widget.isSuccess) {
      return AppColors.withAlpha(AppColors.success, 0.08);
    }
    if (widget.isError) {
      return AppColors.withAlpha(AppColors.error, 0.06);
    }
    if (_isFocused) {
      return AppColors.withAlpha(AppColors.tealPrimary, 0.06);
    }
    return AppColors.inputFill(widget.isDark);
  }

  @override
  Widget build(BuildContext context) {
    final fontSize = widget.boxWidth < 38 ? 17.0 : 20.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: widget.boxWidth,
      height: widget.boxHeight,
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: _borderColor,
          width: _isFocused || widget.isError || widget.isSuccess ? 2.0 : 1.5,
        ),
        boxShadow: _isFocused && !widget.isError
            ? [
                BoxShadow(
                  color: AppColors.withAlpha(AppColors.tealPrimary, 0.18),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ]
            : [],
      ),
      child: KeyboardListener(
        focusNode: FocusNode(),
        onKeyEvent: widget.onKeyEvent,
        child: Center(
          child: TextField(
            controller: widget.controller,
            focusNode: widget.focusNode,
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            style: GoogleFonts.plusJakartaSans(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              color: widget.isSuccess
                  ? AppColors.success
                  : AppColors.textPrimary(widget.isDark),
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.zero,
              isDense: true,
            ),
            onChanged: widget.onChanged,
          ),
        ),
      ),
    );
  }
}
