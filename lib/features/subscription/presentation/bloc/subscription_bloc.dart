import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/subscription_status.dart';
import '../../domain/usecases/get_subscription_status.dart';
import '../../domain/usecases/purchase_premium.dart';
import '../../domain/usecases/restore_purchases.dart';

part 'subscription_event.dart';
part 'subscription_state.dart';

@injectable
class SubscriptionBloc extends Bloc<SubscriptionEvent, SubscriptionState> {
  SubscriptionBloc(
    this._getSubscriptionStatus,
    this._purchasePremium,
    this._restorePurchases,
  ) : super(const SubscriptionInitial()) {
    on<LoadSubscription>(_onLoadSubscription);
    on<PurchasePremiumEvent>(_onPurchasePremium);
    on<RestorePurchasesEvent>(_onRestorePurchases);
  }

  final GetSubscriptionStatus _getSubscriptionStatus;
  final PurchasePremium _purchasePremium;
  final RestorePurchases _restorePurchases;

  Future<void> _onLoadSubscription(
    LoadSubscription event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(const SubscriptionLoading());
    final result = await _getSubscriptionStatus(const NoParams());
    result.fold(
      (failure) => emit(SubscriptionError(failure.message)),
      (status) => emit(SubscriptionLoaded(status)),
    );
  }

  Future<void> _onPurchasePremium(
    PurchasePremiumEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(const SubscriptionLoading());
    final result = await _purchasePremium(const NoParams());
    if (result.isLeft()) {
      result.fold(
        (failure) => emit(SubscriptionError(failure.message)),
        (_) {},
      );
      return;
    }
    final statusResult = await _getSubscriptionStatus(const NoParams());
    statusResult.fold(
      (failure) => emit(SubscriptionError(failure.message)),
      (status) => emit(SubscriptionLoaded(status)),
    );
  }

  Future<void> _onRestorePurchases(
    RestorePurchasesEvent event,
    Emitter<SubscriptionState> emit,
  ) async {
    emit(const SubscriptionLoading());
    final result = await _restorePurchases(const NoParams());
    result.fold(
      (failure) => emit(SubscriptionError(failure.message)),
      (status) => emit(SubscriptionLoaded(status)),
    );
  }
}
