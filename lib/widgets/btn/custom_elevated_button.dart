import 'package:afrik_flow/themes/app_theme.dart';
import 'package:flutter/material.dart';

// TODO:: animate btn
class CustomElevatedButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? hoverColor;
  final Color? focusColor;
  final Color? activeColor;
  final Color? textColor;
  final bool isLoading;

  const CustomElevatedButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.backgroundColor,
    this.hoverColor,
    this.focusColor,
    this.activeColor,
    this.textColor,
    this.isLoading = false,
  });

  @override
  CustomElevatedButtonState createState() => CustomElevatedButtonState();
}

class CustomElevatedButtonState extends State<CustomElevatedButton> {
  bool _isHovered = false;
  bool _isFocused = false;

  @override
  Widget build(BuildContext context) {
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: ElevatedButton(
          onPressed: widget.isLoading ? null : widget.onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: _isHovered
                ? (widget.hoverColor ?? AppTheme.secondaryColor)
                : (_isFocused
                    ? (widget.focusColor ??
                        AppTheme.primaryColor.withOpacity(0.8))
                    : (widget.backgroundColor ?? AppTheme.primaryColor)),
            padding: const EdgeInsets.symmetric(vertical: 0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: _isHovered ? 6 : 2,
          ),
          child: SizedBox(
            height: 50,
            child: Center(
              child: widget.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      widget.label,
                      style: TextStyle(
                        color: widget.textColor ?? Colors.white,
                        fontSize: 16,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
