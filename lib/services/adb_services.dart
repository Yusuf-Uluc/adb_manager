import 'dart:io' show Process;

import 'package:adb_manager/models/models.dart';
import 'package:adb_manager/riverpod/riverpod.dart';
import 'package:adb_manager/widgets/widgets.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:process_run/shell.dart';
import 'package:url_launcher/url_launcher.dart';

class ADBServices {
  final shell = Shell();

  Future<void> restartABD(BuildContext context) async {
    try {
      startIndicator(context);
      await shell.run('adb tcpip 5555');
      stopIndicator(context);
    } on ShellException {
      stopIndicator(context);
      showErrorDialog(
        context: context,
        title: 'Error',
        content: 'Check if your device is connected to  your Computer',
      );
    } catch (e) {
      stopIndicator(context);
      showErrorDialog(
        context: context,
        title: 'Error',
        content: 'An unknown error occurred',
      );
    }
  }

  Future<void> disconnectAll(BuildContext context) async {
    try {
      startIndicator(context);
      final result = await shell.run('adb disconnect');
      if (result.outText.startsWith('disconnected everything')) {
        context.read(selectedDevicesProvider.notifier).unSelectAll();
      }
      stopIndicator(context);
    } catch (e) {
      stopIndicator(context);
      showErrorDialog(
        context: context,
        title: 'Error',
        content: 'An unknown error occured',
      );
    }
  }

  Future<void> connectDevice(
    BuildContext context,
    Device device,
  ) async {
    startIndicator(context);
    // Try to connect without specifying port
    final result0 = await shell.run('adb connect ${device.ipv4}');
    //CONNECTED
    if (result0.outText.startsWith('connected to')) {
      context.read(selectedDevicesProvider.notifier).selectDevice(
            context,
            device,
          );
      stopIndicator(context);
    }
    //ERROR 1
    else if (result0.outText.startsWith('failed to connect')) {
      startIndicator(context);

      // set port to 5555
      try {
        await shell.run('adb tcpip 5555');
        Future.delayed(
          // Wait until device is connected again after port changed
          (const Duration(seconds: 3)),
          () async {
            // try to connect with port 5555
            final result1 = await shell.run('adb connect ${device.ipv4}:5555');
            if (result1.outText.startsWith('connected to')) {
              context.read(selectedDevicesProvider.notifier).selectDevice(
                    context,
                    device,
                  );
              stopIndicator(context);
            } else {
              stopIndicator(context);
              showErrorDialog(
                context: context,
                title: 'Error',
                content:
                    'Failed to connect to device. Make sure the IP is correct and the device is connected to your computer.',
              );
            }
          },
        );
      } catch (e) {
        stopIndicator(context);
        showErrorDialog(
          context: context,
          title: 'Error',
          content:
              'Make sure your computer has access to the device and the IP is correct.',
        );
      }
    }
    //ERROR 2
    else if (result0.outText.startsWith('failed to resolve host')) {
      showErrorDialog(
        context: context,
        title: 'Error',
        content:
            'Could not detect a device with the given IP adress. Make sure that the IP adress is correct.',
      );
      stopIndicator(context);
    }
    //ERROR 3
    else if (result0.outText.startsWith('failed to authenticate')) {
      showErrorDialog(
        context: context,
        title: 'Error',
        content:
            'Could not authenticate. Check if your computer has permissions to access your device.',
      );
      stopIndicator(context);
    } else if (result0.outText.startsWith('already connected to')) {
      showErrorDialog(
        context: context,
        title: 'Error',
        content: 'You are already connected to this device.',
      );
      stopIndicator(context);
    } else {
      stopIndicator(context);
      showErrorDialog(
        context: context,
        title: 'Error',
        content:
            'Check if your computer is permitted to access your device or try reconnecting it.',
      );
    }
  }

  Future<void> disconnectDevice(
    BuildContext context,
    Device device,
  ) async {
    startIndicator(context);
    final result1 = await Process.run('adb', ['devices']);
    if (result1.stdout.toString().contains(device.ipv4 + ':5555')) {
      await shell.run('adb disconnect ${device.ipv4}');
      context.read(selectedDevicesProvider.notifier).unselectDevice(
            context,
            device,
          );
      stopIndicator(context);
    }
  }

  Future<void> scrcpy(
      GlobalKey<ScaffoldState> scaffoldKey, Device device) async {
    final result = await Process.run(
      'adb',
      ['devices'],
    );
    if (result.stdout.toString().contains(device.ipv4 + ':5555')) {
      try {
        await shell.run('scrcpy -s ${device.ipv4}');
      } catch (e) {
        showErrorDialog(
          context: scaffoldKey.currentContext!,
          title: 'Error',
          content: 'Make sure you have Scrcpy installed',
        );
      }
    } else {
      try {
        await connectDevice(scaffoldKey.currentContext!, device);
        await shell.run('scrcpy -s ${device.ipv4}');
      } catch (e) {
        showErrorDialog(
          context: scaffoldKey.currentContext!,
          title: 'Error',
          content: 'An Unknown error happened.',
        );
      }
    }
  }
}

void showErrorDialog({
  required BuildContext context,
  required String title,
  required String content,
}) {
  appWindow.show();
  showDialog(
    context: context,
    builder: (context) {
      return DefaultDialog(
        title: title,
        content: content,
        button1: TextButton(
          onPressed: () {
            Navigator.pop(context);
            launch('https://github.com/Yusuf-Uluc/adb_manager/issues');
          },
          child: const Text('Report Error'),
        ),
        button2: TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('OK'),
        ),
      );
    },
  );
}

void startIndicator(BuildContext context) {
  context.read(loadingIndicatorProvider.notifier).updateValue(true);
}

void stopIndicator(BuildContext context) {
  context.read(loadingIndicatorProvider.notifier).updateValue(false);
}
