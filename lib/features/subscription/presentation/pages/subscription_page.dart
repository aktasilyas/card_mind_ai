import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/subscription_status.dart';
import '../bloc/subscription_bloc.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Premium')),
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
    return Card(
      color: Colors.amber.shade50,
      child: const Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          children: [
            Icon(Icons.workspace_premium, size: 64, color: Colors.amber),
            SizedBox(height: 16),
            Text(
              'Premium Aktif',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Tüm özelliklere erişiminiz var.'),
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
    return DataTable(
      columns: const [
        DataColumn(label: Text('Özellik')),
        DataColumn(label: Text('Free')),
        DataColumn(label: Text('Premium')),
      ],
      rows: const [
        DataRow(cells: [
          DataCell(Text('Reklamlar')),
          DataCell(Text('Var')),
          DataCell(Text('Yok')),
        ]),
        DataRow(cells: [
          DataCell(Text('AI Kart Üretimi')),
          DataCell(Text('5/gün')),
          DataCell(Text('Sınırsız')),
        ]),
        DataRow(cells: [
          DataCell(Text('Öncelikli Destek')),
          DataCell(Icon(Icons.close, color: Colors.red)),
          DataCell(Icon(Icons.check, color: Colors.green)),
        ]),
      ],
    );
  }
}

class _PricingSection extends StatelessWidget {
  const _PricingSection();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text(
          'Premium Planlar',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _PriceCard(label: 'Aylık', price: '\$2.99/ay'),
            _PriceCard(label: 'Yıllık', price: '\$19.99/yıl'),
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
          : const Text("Premium'a Geç"),
    );
  }
}

class _RestoreButton extends StatelessWidget {
  const _RestoreButton();

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context
          .read<SubscriptionBloc>()
          .add(const RestorePurchasesEvent()),
      child: const Text('Satın Alımları Geri Yükle'),
    );
  }
}
