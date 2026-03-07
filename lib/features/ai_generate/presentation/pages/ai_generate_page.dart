import 'dart:math' as math;

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/duo_button.dart';
import '../../../deck/domain/entities/flashcard.dart';
import '../../../deck/domain/usecases/add_card.dart';
import '../../domain/usecases/extract_text_from_file.dart';
import '../bloc/ai_generate_bloc.dart';

class AiGeneratePage extends StatelessWidget {
  const AiGeneratePage({super.key, required this.deckId});

  final String deckId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AiGenerateBloc>(),
      child: _AiGenerateView(deckId: deckId),
    );
  }
}

class _AiGenerateView extends StatefulWidget {
  const _AiGenerateView({required this.deckId});

  final String deckId;

  @override
  State<_AiGenerateView> createState() => _AiGenerateViewState();
}

class _AiGenerateViewState extends State<_AiGenerateView> {
  final _textController = TextEditingController();
  final _addCard = getIt<AddCard>();
  final _extractText = getIt<ExtractTextFromFile>();
  bool _saving = false;
  bool _hasText = false;
  bool _extractingFile = false;
  List<Flashcard> _localCards = [];

  static const List<int> _cardCountOptions = [5, 10, 15, 20];

  @override
  void initState() {
    super.initState();
    _textController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = _textController.text.trim().isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  @override
  void dispose() {
    _textController.removeListener(_onTextChanged);
    _textController.dispose();
    super.dispose();
  }

  void _removeCard(int index) {
    setState(() {
      _localCards = List<Flashcard>.from(_localCards)..removeAt(index);
    });
  }

  Future<void> _addAllCards() async {
    if (_localCards.isEmpty) return;
    setState(() => _saving = true);

    int addedCount = 0;
    for (final card in _localCards) {
      final cardWithDeck = card.copyWith(deckId: widget.deckId);
      final result = await _addCard(cardWithDeck);
      result.fold((_) {}, (_) => addedCount++);
    }

    if (!mounted) return;
    setState(() => _saving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$addedCount kart desteye eklendi'),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );

    if (addedCount > 0) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'AI Kart Üretici',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ShaderMask(
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                colors: [AppTheme.duoOrange, Color(0xFFCE82FF)],
              ).createShader(bounds);
            },
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
      body: BlocConsumer<AiGenerateBloc, AiGenerateState>(
        listener: (context, state) {
          if (state is AiGenerateError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                behavior: SnackBarBehavior.floating,
                backgroundColor: AppTheme.duoRed,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
          if (state is AiGenerateSuccess) {
            setState(() {
              _localCards = List<Flashcard>.from(state.cards);
            });
          }
        },
        builder: (context, state) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // --- File Upload Button ---
                _buildFileUploadButton(),
                const SizedBox(height: 12),

                // --- Text Input ---
                _buildTextInput(context),
                const SizedBox(height: 20),

                // --- Card Count Chips ---
                _buildCardCountChips(context, state),
                const SizedBox(height: 20),

                // --- Generate Button ---
                _buildGenerateButton(context, state),
                const SizedBox(height: 20),

                // --- Loading State ---
                if (state is AiGenerateLoading) _buildShimmerCards(),

                // --- Success State ---
                if (state is AiGenerateSuccess && _localCards.isNotEmpty) ...[
                  _buildResultBadge(),
                  const SizedBox(height: 12),
                  _buildResultCards(),
                  const SizedBox(height: 16),
                  _buildSaveButton(),
                  const SizedBox(height: 24),
                ],

                // --- Limit Reached State ---
                if (state is AiGenerateLimitReached) _buildLimitBanner(context),
              ],
            ),
          );
        },
      ),
    );
  }

  // ──────────────────────────────────────────────
  // File Pick & Extract
  // ──────────────────────────────────────────────
  Future<void> _pickAndExtractFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'txt'],
    );

    if (result == null || result.files.isEmpty) return;

    final file = result.files.first;
    if (file.path == null) return;

    final extension = file.extension ?? '';

    setState(() => _extractingFile = true);

    final extractResult = await _extractText(
      ExtractTextFromFileParams(
        filePath: file.path!,
        fileExtension: extension,
      ),
    );

    if (!mounted) return;
    setState(() => _extractingFile = false);

    extractResult.fold(
      (failure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failure.message),
            behavior: SnackBarBehavior.floating,
            backgroundColor: AppTheme.duoRed,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      },
      (text) {
        _textController.text = text;
      },
    );
  }

  // ──────────────────────────────────────────────
  // File Upload Button
  // ──────────────────────────────────────────────
  Widget _buildFileUploadButton() {
    // TODO: Premium kontrolü eklenecek (SubscriptionBloc ile)
    return DuoButton(
      text: 'Dosyadan Yükle',
      icon: Icons.upload_file_rounded,
      variant: DuoButtonVariant.secondary,
      isLoading: _extractingFile,
      onPressed: _extractingFile ? null : _pickAndExtractFile,
    );
  }

  // ──────────────────────────────────────────────
  // Text Input
  // ──────────────────────────────────────────────
  Widget _buildTextInput(BuildContext context) {
    final theme = Theme.of(context);
    return TextField(
      controller: _textController,
      minLines: 4,
      maxLines: 8,
      maxLength: 2000,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: 'Konuyu veya metni buraya yazın...',
        hintStyle: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
        ),
        filled: true,
        fillColor: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.2),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: AppTheme.duoGreen,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.all(20),
        counterStyle: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Card Count Chips
  // ──────────────────────────────────────────────
  Widget _buildCardCountChips(BuildContext context, AiGenerateState state) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kart Sayısı',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: _cardCountOptions.map((int count) {
            final bool isSelected = state.cardCount == count;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  right: count != _cardCountOptions.last ? 8.0 : 0,
                ),
                child: GestureDetector(
                  onTap: () {
                    context
                        .read<AiGenerateBloc>()
                        .add(UpdateCardCount(count));
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppTheme.duoGreen
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? AppTheme.duoGreen
                            : theme.colorScheme.outline.withValues(alpha: 0.3),
                        width: 2,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '$count',
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : theme.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────
  // Generate Button
  // ──────────────────────────────────────────────
  Widget _buildGenerateButton(BuildContext context, AiGenerateState state) {
    final bool isLoading = state is AiGenerateLoading;
    return DuoButton(
      text: 'Kart Üret',
      icon: Icons.auto_awesome,
      isLoading: isLoading,
      onPressed: _hasText && !isLoading
          ? () {
              final text = _textController.text.trim();
              context.read<AiGenerateBloc>().add(GenerateCards(text: text));
            }
          : null,
    );
  }

  // ──────────────────────────────────────────────
  // Shimmer / Loading Cards
  // ──────────────────────────────────────────────
  Widget _buildShimmerCards() {
    return Column(
      children: List.generate(
        4,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _ShimmerCard(delay: index * 150),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Result Badge
  // ──────────────────────────────────────────────
  Widget _buildResultBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.duoGreen.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            color: AppTheme.duoGreen,
            size: 18,
          ),
          const SizedBox(width: 6),
          Text(
            '${_localCards.length} kart üretildi',
            style: const TextStyle(
              color: AppTheme.duoGreen,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Result Cards (Flip Preview)
  // ──────────────────────────────────────────────
  Widget _buildResultCards() {
    return Column(
      children: List.generate(_localCards.length, (index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _FlipCard(
            card: _localCards[index],
            index: index,
            onDelete: () => _removeCard(index),
          ),
        );
      }),
    );
  }

  // ──────────────────────────────────────────────
  // Save All Button
  // ──────────────────────────────────────────────
  Widget _buildSaveButton() {
    return DuoButton(
      text: 'Tümünü Kaydet (${_localCards.length})',
      icon: Icons.save_rounded,
      variant: DuoButtonVariant.secondary,
      isLoading: _saving,
      onPressed: _saving ? null : _addAllCards,
    );
  }

  // ──────────────────────────────────────────────
  // Limit Reached Banner
  // ──────────────────────────────────────────────
  Widget _buildLimitBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: AppTheme.cardGradient,
      child: Column(
        children: [
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.lock_rounded,
              color: Colors.white,
              size: 36,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Günlük Limitinize Ulaştınız',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Premium ile sınırsız kart üretin ve tüm özelliklerin kilidini açın.',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          DuoButton(
            text: "Premium'a Geç",
            icon: Icons.workspace_premium_rounded,
            variant: DuoButtonVariant.secondary,
            onPressed: () => context.push('/subscription'),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════
// Shimmer Card Widget
// ════════════════════════════════════════════════
class _ShimmerCard extends StatefulWidget {
  const _ShimmerCard({required this.delay});

  final int delay;

  @override
  State<_ShimmerCard> createState() => _ShimmerCardState();
}

class _ShimmerCardState extends State<_ShimmerCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    Future<void>.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) {
        _controller.repeat();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final baseColor = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.grey.withValues(alpha: 0.12);
    final highlightColor = isDark
        ? Colors.white.withValues(alpha: 0.15)
        : Colors.grey.withValues(alpha: 0.04);

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [baseColor, highlightColor, baseColor],
              stops: [
                math.max(0.0, _animation.value - 0.3),
                _animation.value.clamp(0.0, 1.0),
                math.min(1.0, _animation.value + 0.3),
              ],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 14,
                width: 180,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(7),
                ),
              ),
              Container(
                height: 12,
                width: 120,
                decoration: BoxDecoration(
                  color: baseColor,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ════════════════════════════════════════════════
// Flip Card Widget
// ════════════════════════════════════════════════
class _FlipCard extends StatefulWidget {
  const _FlipCard({
    required this.card,
    required this.index,
    required this.onDelete,
  });

  final Flashcard card;
  final int index;
  final VoidCallback onDelete;

  @override
  State<_FlipCard> createState() => _FlipCardState();
}

class _FlipCardState extends State<_FlipCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _flipController;
  late final Animation<double> _flipAnimation;
  bool _showFront = true;

  @override
  void initState() {
    super.initState();
    _flipController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _flipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _flipController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _flipController.dispose();
    super.dispose();
  }

  void _toggleFlip() {
    if (_showFront) {
      _flipController.forward();
    } else {
      _flipController.reverse();
    }
    setState(() => _showFront = !_showFront);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: _toggleFlip,
      child: AnimatedBuilder(
        animation: _flipAnimation,
        builder: (context, child) {
          final double angle = _flipAnimation.value * math.pi;
          final bool isFront = _flipAnimation.value < 0.5;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(angle),
            child: isFront
                ? _buildFrontSide(theme)
                : Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateX(math.pi),
                    child: _buildBackSide(theme),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildFrontSide(ThemeData theme) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 100),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.cardTheme.color ?? theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.duoGreen.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'SORU',
                      style: TextStyle(
                        color: AppTheme.duoGreen,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Çevirmek için dokun',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(right: 32),
                child: Text(
                  widget.card.front,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: -8,
            right: -8,
            child: IconButton(
              onPressed: widget.onDelete,
              icon: const Icon(Icons.close_rounded),
              iconSize: 20,
              color: AppTheme.duoRed,
              style: IconButton.styleFrom(
                backgroundColor: AppTheme.duoRed.withValues(alpha: 0.1),
                minimumSize: const Size(32, 32),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBackSide(ThemeData theme) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 100),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.duoBlue.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.duoBlue.withValues(alpha: 0.3),
        ),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.duoBlue.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'CEVAP',
                      style: TextStyle(
                        color: AppTheme.duoBlue,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    'Çevirmek için dokun',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.only(right: 32),
                child: Text(
                  widget.card.back,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: -8,
            right: -8,
            child: IconButton(
              onPressed: widget.onDelete,
              icon: const Icon(Icons.close_rounded),
              iconSize: 20,
              color: AppTheme.duoRed,
              style: IconButton.styleFrom(
                backgroundColor: AppTheme.duoRed.withValues(alpha: 0.1),
                minimumSize: const Size(32, 32),
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
