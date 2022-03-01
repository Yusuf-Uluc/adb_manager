import 'dart:convert';
import 'dart:io' show Process;

import 'package:adb_manager/models/models.dart';
import 'package:adb_manager/services/adb_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'riverpod.dart';

List<Device> prefsToList(List<String> prefs) {
  return prefs.map((item) => Device.fromJson(jsonDecode(item))).toList();
}

List<String> stateToListString(List<Device> state) {
  return state.map((item) => jsonEncode(item)).toList();
}

class ADBDevicesNotifier extends StateNotifier<List<Device>> {
  ADBDevicesNotifier() : super([]);

  Future<List<Device>> initialize(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    state = prefs.getStringList('adbDevices') == null
        ? []
        : prefsToList(prefs.getStringList('adbDevices')!);

    final result = await Process.run(
      'adb',
      ['devices'],
    );
    for (final device in state) {
      if (result.stdout.toString().contains(device.ipv4 + ':5555')) {
        context.read(selectedDevicesProvider.notifier).selectDevice(
              context,
              device,
            );
      }
    }
    return state;
  }

  Future<void> addDevice({required String name, required String ipv4}) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList(
      'adbDevices',
      [
        ...stateToListString(state),
        jsonEncode(
          Device(name: name, ipv4: ipv4),
        )
      ],
    );

    state = prefsToList(prefs.getStringList('adbDevices')!);
  }

  Future<void> deleteDevice(BuildContext context, Device device) async {
    ADBServices().disconnectDevice(context, device);
    final prefs = await SharedPreferences.getInstance();
    state = prefsToList(prefs.getStringList('adbDevices')!);
    state = state.where((item) => item != device).toList();
    await prefs.setStringList(
      'adbDevices',
      stateToListString(state),
    );
  }

  Future<void> editDevice({
    required BuildContext context,
    required Device deviceToEdit,
    required String newName,
    required String newIpv4,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    state = prefsToList(prefs.getStringList('adbDevices')!);

    state = [
      for (final device in state)
        if (device == deviceToEdit)
          Device(
            name: newName,
            ipv4: newIpv4,
          )
        else
          device,
    ];

    await prefs.setStringList(
      'adbDevices',
      stateToListString(state),
    );
  }
}

final adbDevicesProvider =
    StateNotifierProvider<ADBDevicesNotifier, List<Device>>((ref) {
  return ADBDevicesNotifier();
});
