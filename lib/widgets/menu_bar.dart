// custom Menubar widget Flutter
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:adb_manager/services/services.dart';
import 'package:adb_manager/widgets/widgets.dart';

class MenuBar extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  MenuBar({
    Key? key,
    required this.scaffoldKey,
  }) : super(key: key);

  final newDeviceIpv4Controller = TextEditingController();

  final newDeviceNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Devices',
          style: Theme.of(context).textTheme.headline4!.copyWith(
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomIconButton(
              icon: Icons.flag_rounded,
              tooltip: 'Report an issue',
              onTap: () {
                launch('https://github.com/Mesota22/adb_manager/issues');
              },
            ),
            CustomIconButton(
              icon: Icons.info_outline_rounded,
              tooltip: 'Try right clicking on a card',
              onTap: () {},
            ),
            CustomIconButton(
              icon: Icons.devices_rounded,
              tooltip: 'Run scrcpy',
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return ScrcpyDialog(scaffoldKey: scaffoldKey);
                    });
              },
            ),
            CustomIconButton(
              icon: Icons.link_off_rounded,
              tooltip: 'Disconnect Everything',
              onTap: () {
                ADBServices().disconnectAll(context);
              },
            ),
            CustomIconButton(
              icon: Icons.add_rounded,
              tooltip: 'Add Device',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AddDeviceDialog(
                      ipv4Controller: newDeviceIpv4Controller,
                      nameController: newDeviceNameController,
                    );
                  },
                );
              },
            )
          ],
        ),
      ],
    );
  }
}
