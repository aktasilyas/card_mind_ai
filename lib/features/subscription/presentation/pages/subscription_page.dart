import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/subscription_status.dart';
import '../bloc/subscription_bloc.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.premium)),
      body: BlocConsumer<SubscriptionBloc, SubscriptionState>(
        listener: (context, state) {
          if (state is SubscriptionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          final isPremium = state is SubscriptionLoaded &&
              state.status.tier == SubscriptionTier.premium;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (isPremium)
                  const _PremiumActiveCard()
                else ...[
                  const _ComparisonTable(),
                  const SizedBox(height: 24),
                  const _PricingSection(),
                  const SizedBox(height: 24),
                  _PurchaseButton(isLoading: state is SubscriptionLoading),
                  const SizedBox(height: 12),
                  const _RestoreButton(),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class _PremiumActiveCard extends StatelessWidget {
  const _PremiumActiveCard();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      color: Colors.amber.shade50,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.workspace_premium, size: 64, color: Colors.amber),
            const SizedBox(height: 16),
            Text(
              l10n.premiumActiveTitle,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(l10n.allFeaturesAccess),
          ],
        ),
      ),
    );
  }
}

class _ComparisonTable extends StatelessWidget {
  const _ComparisonTable();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DataTable(
      columns: [
        DataColumn(label: Text(l10n.feature)),
        DataColumn(label: Text(l10n.free)),
        DataColumn(label: Text(l10n.premium)),
      ],
      rows: [
        DataRow(cells: [
          DataCell(Text(l10n.ads)),
          DataCell(Text(l10n.adsYes)),
          DataCell(Text(l10n.adsNo)),
        ]),
        DataRow(cells: [
          DataCell(Text(l10n.aiCardGeneration)),
          DataCell(Text(l10n.fivePerDay)),
          DataCell(Text(l10n.unlimited)),
        ]),
        DataRow(cells: [
          DataCell(Text(l10n.prioritySupport)),
          const DataCell(Icon(Icons.close, color: Colors.red)),
          const DataCell(Icon(Icons.check, color: Colors.green)),
        ]),
      ],
    );
  }
}

class _PricingSection extends StatelessWidget {
  const _PricingSection();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      children: [
        Text(
          l10n.premiumPlans,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _PriceCard(label: l10n.monthly, price: '\$2.99/ay'),
            _PriceCard(label: l10n.yearly, price: '\$19.99/yıl'),
          ],
        ),
      ],
    );
  }
}

class _PriceCard extends StatelessWidget {
  const _PriceCard({required this.label, required this.price});

  final String label;
  final String price;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          children: [
            Text(label, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 4),
            Text(
              price,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PurchaseButton extends StatelessWidget {
  const _PurchaseButton({required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ElevatedButton(
      onPressed: isLoading
          ? null
          : () => context
              .read<SubscriptionBloc>()
              .add(const PurchasePremiumEvent()),
      child: isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(l10n.upgradeToPremium),
    );
  }
}

class _RestoreButton extends StatelessWidget {
  const _RestoreButton();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return TextButton(
      onPressed: () => context
          .read<SubscriptionBloc>()
          .add(const RestorePurchasesEvent()),
      child: Text(l10n.restorePurchases),
    );
  }
}
