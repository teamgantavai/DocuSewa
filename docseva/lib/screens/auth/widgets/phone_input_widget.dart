import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:docusewa/theme/app_colors.dart';

/// Premium India phone number input with +91 prefix and flag.
class PhoneInputWidget extends StatefulWidget {
  final TextEditingController controller;
  final bool isDark;
  final bool isError;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onSubmit;

  const PhoneInputWidget({
    super.key,
    required this.controller,
    required this.isDark,
    this.isError = false,
    this.errorText,
    this.onChanged,
    this.onSubmit,
  });

  @override
  State<PhoneInputWidget> createState() => _PhoneInputWidgetState();
}

class _PhoneInputWidgetState extends State<PhoneInputWidget> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = widget.isError
        ? AppColors.error
        : _isFocused
            ? AppColors.trustBlue
            : AppColors.border(widget.isDark);

    final borderWidth = _isFocused || widget.isError ? 2.0 : 1.5;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          'Mobile Number',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary(widget.isDark),
            letterSpacing: 0.1,
          ),
        ),
        const SizedBox(height: 8),

        // Input container
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: AppColors.inputFill(widget.isDark),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: borderWidth),
            boxShadow: _isFocused
                ? [
                    BoxShadow(
                      color: AppColors.withAlpha(AppColors.trustBlue, 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : [],
          ),
          child: Row(
            children: [
              // India flag + country code prefix
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: AppColors.border(widget.isDark),
                      width: 1.5,
                    ),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // India flag emoji
                    const Text(
                      '🇮🇳',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '+91',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary(widget.isDark),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ),

              // Phone number field
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  keyboardType: TextInputType.phone,
                  textInputAction: TextInputAction.done,
                  maxLength: 10,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary(widget.isDark),
                    letterSpacing: 1.0,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10),
                  ],
                  onChanged: widget.onChanged,
                  onSubmitted: (_) => widget.onSubmit?.call(),
                  decoration: InputDecoration(
                    hintText: 'Enter your mobile number',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      color: AppColors.textMuted(widget.isDark),
                      fontWeight: FontWeight.w400,
                      letterSpacing: 0.3,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                    counterText: '', // hide character counter
                  ),
                ),
              ),
            ],
          ),
        ),

        // Error message
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: widget.isError && widget.errorText != null
              ? Padding(
                  key: const ValueKey('error'),
                  padding: const EdgeInsets.only(top: 8, left: 2),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline_rounded,
                        size: 14,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        widget.errorText!,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.error,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(key: ValueKey('no-error')),
        ),
      ],
    );
  }
}
