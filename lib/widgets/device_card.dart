import 'package:adb_manager/constants/constants.dart';
import 'package:adb_manager/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_context_menu/native_context_menu.dart' as cm;

import 'package:adb_manager/models/models.dart';
import 'package:adb_manager/riverpod/riverpod.dart';

class DeviceCard extends StatelessWidget {
  final Device device;
  final bool selected;
  final VoidCallback onTap;
  const DeviceCard(
      {Key? key,
      required this.device,
      required this.selected,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final newNameController = TextEditingController(text: device.name);
    final newIpv4Controller = TextEditingController(text: device.ipv4);
    return cm.ContextMenuRegion(
      onItemSelected: (item) {
        item.onSelected!();
      },
      menuItems: [
        cm.MenuItem(
            title: 'Edit',
            onSelected: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return EditDeviceDialog(
                      device: device,
                      newNameController: newNameController,
                      newIpv4Controller: newIpv4Controller,
                    );
                  });
            }),
        cm.MenuItem(
            title: 'Delete',
            onSelected: () {
              context
                  .read(adbDevicesProvider.notifier)
                  .deleteDevice(context, device);
            })
      ],
      child: DecoratedBox(
        decoration: selected
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: Theme.of(context).colorScheme.primary, width: 2),
              )
            : const BoxDecoration(),
        child: Card(
          margin: const EdgeInsets.all(2),
          child: ListTile(
            hoverColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadiusM),
            ),
            onTap: onTap,
            selected: selected,
            contentPadding: const EdgeInsets.only(left: 10),
            title: Text(
              device.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            subtitle: Text(
              device.ipv4,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ),
      ),
    );
  }
}
