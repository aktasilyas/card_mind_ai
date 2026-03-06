import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../shared/widgets/duo_button.dart';

class StudyCompletePage extends StatefulWidget {
  const StudyCompletePage({
    super.key,
    required this.totalCards,
    required this.averageRating,
    required this.xpEarned,
  });

  final int totalCards;
  final double averageRating;
  final int xpEarned;

  @override
  State<StudyCompletePage> createState() => _StudyCompletePageState();
}

class _StudyCompletePageState extends State<StudyCompletePage>
    with SingleTickerProviderStateMixin {
  late final ConfettiController _confettiController;
  late final AnimationController _xpAnimController;
  late final Animation<double> _xpAnimation;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();

    _xpAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _xpAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _xpAnimController, curve: Curves.easeOutBack),
    );
    _xpAnimController.forward();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _xpAnimController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.emoji_events,
                    size: 80,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Harika Is!',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  AnimatedBuilder(
                    animation: _xpAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(0, -20 * _xpAnimation.value),
                        child: Opacity(
                          opacity: _xpAnimation.value.clamp(0.0, 1.0),
                          child: Text(
                            '+${widget.xpEarned} XP',
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF58CC02),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                  _StatRow(
                    icon: Icons.style,
                    label: 'Toplam Kart',
                    value: '${widget.totalCards}',
                  ),
                  const SizedBox(height: 12),
                  _StatRow(
                    icon: Icons.star,
                    label: 'Ortalama Puan',
                    value: widget.averageRating.toStringAsFixed(1),
                  ),
                  const SizedBox(height: 40),
                  DuoButton(
                    text: 'Ana Sayfaya Don',
                    icon: Icons.home,
                    onPressed: () => context.go('/'),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              maxBlastForce: 30,
              minBlastForce: 10,
              gravity: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 20),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
