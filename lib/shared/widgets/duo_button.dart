import 'package:flutter/material.dart';

enum DuoButtonVariant { primary, secondary, danger }

class DuoButton extends StatefulWidget {
  const DuoButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = DuoButtonVariant.primary,
    this.isLoading = false,
    this.icon,
  });

  final String text;
  final VoidCallback? onPressed;
  final DuoButtonVariant variant;
  final bool isLoading;
  final IconData? icon;

  @override
  State<DuoButton> createState() => _DuoButtonState();
}

class _DuoButtonState extends State<DuoButton> {
  bool _isPressed = false;

  Color get _color => switch (widget.variant) {
        DuoButtonVariant.primary => const Color(0xFF58CC02),
        DuoButtonVariant.secondary => const Color(0xFF1CB0F6),
        DuoButtonVariant.danger => const Color(0xFFFF4B4B),
      };

  Color get _shadowColor => switch (widget.variant) {
        DuoButtonVariant.primary => const Color(0xFF58A700),
        DuoButtonVariant.secondary => const Color(0xFF1899D6),
        DuoButtonVariant.danger => const Color(0xFFEA2B2B),
      };

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.onPressed == null || widget.isLoading;
    final offset = _isPressed ? 0.0 : 4.0;

    return GestureDetector(
      onTapDown: isDisabled ? null : (_) => setState(() => _isPressed = true),
      onTapUp: isDisabled
          ? null
          : (_) {
              setState(() => _isPressed = false);
              widget.onPressed?.call();
            },
      onTapCancel:
          isDisabled ? null : () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.translationValues(0, _isPressed ? 4 : 0, 0),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isDisabled ? _color.withValues(alpha: 0.5) : _color,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: isDisabled
                    ? _shadowColor.withValues(alpha: 0.3)
                    : _shadowColor,
                offset: Offset(0, offset),
              ),
            ],
          ),
          child: widget.isLoading
              ? const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                    ],
                    Text(
                      widget.text,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
