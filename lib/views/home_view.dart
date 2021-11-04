import 'dart:io' show Platform;

import 'package:adb_manager/models/models.dart';
import 'package:adb_manager/riverpod/riverpod.dart';
import 'package:adb_manager/services/services.dart';
import 'package:adb_manager/widgets/widgets.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:system_tray/system_tray.dart' as st;

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final st.SystemTray _systemTray = st.SystemTray();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    context.read(adbDevicesProvider.notifier).initialize(context).then(
          (devices) => initSystemTray(devices),
        );
  }

  Future<void> initSystemTray(List<Device> devices) async {
    final menu = [
      st.SubMenu(
        label: 'Connect to...',
        children: [
          for (final device in devices)
            st.MenuItem(
              label: device.name,
              onClicked: () {
                ADBServices().connectDevice(context, device);
              },
            ),
        ],
      ),
      st.SubMenu(
        label: 'Run scrcpy...',
        children: [
          for (final device in devices)
            st.MenuItem(
              label: device.name,
              onClicked: () {
                ADBServices().scrcpy(scaffoldKey, device);
              },
            ),
        ],
      ),
      st.MenuItem(
        label: 'Disconnect everything',
        onClicked: () {
          ADBServices().disconnectAll(context);
        },
      ),
      st.MenuItem(
        label: 'Show Application',
        onClicked: () {
          appWindow.show();
        },
      ),
      st.MenuItem(
        label: 'Quit Application',
        onClicked: () {
          appWindow.close();
        },
      ),
    ];

    await _systemTray.initSystemTray(
      "ADB Manager",

      /// NOT WORKING/NO ICON SHOWING -------------
      iconPath: p.joinAll([
        p.dirname(Platform.resolvedExecutable),
        'data/flutter_assets/assets',
        'app_icon.png'
      ]),

      /// --------------------
      toolTip: "ADB Manager",
    );

    await _systemTray.setContextMenu(menu);
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
