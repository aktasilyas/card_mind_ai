import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/subscription_status.dart';
import '../bloc/subscription_bloc.dart';
import '../pages/subscription_page.dart';

class SubscriptionGateWidget extends StatelessWidget {
  const SubscriptionGateWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SubscriptionBloc, SubscriptionState>(
      builder: (context, state) {
        if (state is SubscriptionLoaded &&
            state.status.tier == SubscriptionTier.premium) {
          return child;
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            const Text('Bu özellik Premium kullanıcılara özeldir.'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => BlocProvider.value(
                    value: context.read<SubscriptionBloc>(),
                    child: const SubscriptionPage(),
                  ),
                ),
              ),
              child: const Text("Premium'a Geç"),
            ),
          ],
        );
      },
    );
  }
}
