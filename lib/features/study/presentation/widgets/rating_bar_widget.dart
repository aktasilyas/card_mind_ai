import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class RatingBarWidget extends StatelessWidget {
  const RatingBarWidget({super.key, required this.onRatingSelected});

  final void Function(int quality) onRatingSelected;

  static const _colors = [
    Color(0xFFE53935),
    Color(0xFFFF5722),
    Color(0xFFFF9800),
    Color(0xFFFFEB3B),
    Color(0xFF8BC34A),
    Color(0xFF4CAF50),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final labels = [
      l10n.ratingWorst,
      l10n.ratingHard,
      l10n.ratingStruggled,
      l10n.ratingMedium,
      l10n.ratingEasy,
      l10n.ratingPerfect,
    ];
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.center,
      children: List.generate(6, (index) {
        return _RatingButton(
          quality: index,
          label: labels[index],
          color: _colors[index],
          onTap: () => onRatingSelected(index),
        );
      }),
    );
  }
}

class _RatingButton extends StatefulWidget {
  const _RatingButton({
    required this.quality,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final int quality;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  State<_RatingButton> createState() => _RatingButtonState();
}

class _RatingButtonState extends State<_RatingButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 1.15 : 1.0,
        duration: const Duration(milliseconds: 150),
        child: Container(
          width: 56,
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: widget.color.withValues(alpha: 0.85),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${widget.quality}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                widget.label,
                style: const TextStyle(fontSize: 10, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
