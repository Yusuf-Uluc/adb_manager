import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoadingIndicatorNotifier extends StateNotifier<bool> {
  LoadingIndicatorNotifier() : super(false);

  updateValue(bool newValue) {
    state = newValue;
  }
}

final loadingIndicatorProvider =
    StateNotifierProvider<LoadingIndicatorNotifier, bool>((ref) {
  return LoadingIndicatorNotifier();
});
