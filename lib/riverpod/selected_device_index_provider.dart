import 'package:adb_manager/models/models.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectedDevicesNotifier extends StateNotifier<List<Device>> {
  SelectedDevicesNotifier() : super([]);

  selectDevice(BuildContext context, Device device) {
    state = [...state, device];
  }

  unselectDevice(
    BuildContext context,
    Device device,
  ) {
    state = state.where((element) => element != device).toList();
  }

  unSelectAll() {
    state = [];
  }
}

final selectedDevicesProvider =
    StateNotifierProvider<SelectedDevicesNotifier, List<Device>>((ref) {
  return SelectedDevicesNotifier();
});
