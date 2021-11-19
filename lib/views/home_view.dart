import 'dart:io' show Platform;

import 'package:adb_manager/models/models.dart';
import 'package:adb_manager/riverpod/riverpod.dart';
import 'package:adb_manager/services/services.dart';
import 'package:adb_manager/widgets/widgets.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tray_manager/tray_manager.dart' as tm;

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with tm.TrayListener {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  late List<Device> devices;
  Future<void> initSystemTray() async {
    await tm.TrayManager.instance.setIcon(
      Platform.isWindows ? 'assets/tray_icon.ico' : 'assets/tray_icon.png',
    );
    List<tm.MenuItem> items = [
      tm.MenuItem(
        key: 'connect_to',
        title: 'Connect to...',
        items: devices.map((device) {
          return tm.MenuItem(
            key: 'connect_to_${device.name}',
            title: device.name,
          );
        }).toList(),
      ),
      tm.MenuItem(
        key: 'run_scrcpy',
        title: 'Run scrcpy...',
        items: devices.map((device) {
          return tm.MenuItem(
            key: 'run_scrcpy_${device.name}',
            title: device.name,
          );
        }).toList(),
      ),
      tm.MenuItem.separator,
      tm.MenuItem(
        key: 'disconnect_all',
        title: 'Disconnect All',
      ),
      tm.MenuItem(
        key: 'show_application',
        title: 'Show Application',
      ),
      tm.MenuItem(
        key: 'quit_application',
        title: 'Quit Application',
      )
    ];

    await tm.TrayManager.instance.setContextMenu(items);
  }

  @override
  void onTrayMenuItemClick(tm.MenuItem menuItem) {
    if (menuItem.key.startsWith('connect_to')) {
      final deviceName = menuItem.key.split('_')[2];
      final device = devices.firstWhere((device) => device.name == deviceName);
      ADBServices().connectDevice(context, device);
    } else if (menuItem.key.startsWith('run_scrcpy')) {
      final deviceName = menuItem.key.split('_')[2];
      final device = devices.firstWhere((device) => device.name == deviceName);
      ADBServices().scrcpy(scaffoldKey, device);
    } else if (menuItem.key == 'disconnect_all') {
      ADBServices().disconnectAll(context);
    } else if (menuItem.key == 'show_application') {
      appWindow.show();
    } else if (menuItem.key == 'quit_application') {
      appWindow.close();
    }
  }

  @override
  void initState() {
    context.read(loadingIndicatorProvider.notifier).updateValue(true);
    context
        .read(adbDevicesProvider.notifier)
        .initialize(context)
        .then((value) => setState(() => devices = value))
        .then((value) => initSystemTray());
    context.read(loadingIndicatorProvider.notifier).updateValue(false);
    tm.TrayManager.instance.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    tm.TrayManager.instance.removeListener(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              const Color(0xFF0B2031),
              Theme.of(context).colorScheme.background
            ],
          ),
        ),
        child: WindowBorder(
          color: Colors.black,
          width: 1,
          child: Column(
            children: [
              const WindowBar(),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MenuBar(scaffoldKey: scaffoldKey),
                      const SizedBox(height: 10),
                      Consumer(
                        builder: (context, watch, child) {
                          final devices = watch(adbDevicesProvider);
                          final selectedDevices =
                              watch(selectedDevicesProvider);
                          return Expanded(
                            child: GridView.builder(
                              padding: EdgeInsets.zero,
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 230,
                                mainAxisExtent: 80,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: devices.length,
                              itemBuilder: (context, index) {
                                return DeviceCard(
                                  device: devices[index],
                                  selected:
                                      selectedDevices.contains(devices[index]),
                                  onTap: () {
                                    if (selectedDevices
                                        .contains(devices[index])) {
                                      ADBServices().disconnectDevice(
                                        context,
                                        devices[index],
                                      );
                                    } else {
                                      ADBServices().connectDevice(
                                        context,
                                        devices[index],
                                      );
                                    }
                                  },
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const BottomLoadingIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
