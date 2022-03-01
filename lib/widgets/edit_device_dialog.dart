import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:adb_manager/constants/constants.dart';
import 'package:adb_manager/models/models.dart';
import 'package:adb_manager/riverpod/adb_devices.dart';
import 'package:adb_manager/widgets/widgets.dart';

class EditDeviceDialog extends StatelessWidget {
  final nameFormKey = GlobalKey<FormState>();
  final ipv4Formkey = GlobalKey<FormState>();

  final TextEditingController newNameController;
  final TextEditingController newIpv4Controller;
  final Device device;
  EditDeviceDialog({
    Key? key,
    required this.newNameController,
    required this.newIpv4Controller,
    required this.device,
  }) : super(key: key);

  void close(BuildContext context) {
    Navigator.pop(context);
  }

  void validate(BuildContext context, List<Device> adbDevices) {
    if (nameFormKey.currentState!.validate() &&
        ipv4Formkey.currentState!.validate()) {
      if (adbDevices.any((item) => item.ipv4 == newIpv4Controller.text) &&
              device.ipv4 != newIpv4Controller.text ||
          adbDevices.any((item) => item.name == newNameController.text) &&
              device.name != newNameController.text) {
        showDialog(
          context: context,
          builder: (context) {
            return DefaultDialog(
              title: 'Error',
              content: 'A device with the same IP or name already exists',
              button1: TextButton(
                onPressed: () {
                  close(context);
                },
                child: const Text('OK'),
              ),
            );
          },
        );
      } else {
        context.read(adbDevicesProvider.notifier).editDevice(
              context: context,
              deviceToEdit: device,
              newIpv4: newIpv4Controller.text,
              newName: newNameController.text,
            );
        close(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultDialog(
      title: 'Edit Device',
      customContent: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextField(
            formKey: nameFormKey,
            maxLength: 12,
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter a Name';
              }
            },
            controller: newNameController,
            label: 'Device Name',
          ),
          const SizedBox(height: 10),
          CustomTextField(
            formKey: ipv4Formkey,
            validator: (value) {
              final regExp = RegExp(ipv4Regex);
              if (!regExp.hasMatch(value!)) {
                return 'Please enter a valid Ipv4 Adress';
              }
            },
            controller: newIpv4Controller,
            label: 'Ipv4 Adress',
          )
        ],
      ),
      button2: Consumer(
        builder: (context, watch, child) {
          return TextButton(
            onPressed: () {
              validate(
                context,
                watch(adbDevicesProvider),
              );
            },
            child: const Text('Edit'),
          );
        },
      ),
      button1: TextButton(
        onPressed: () {
          close(context);
        },
        child: const Text('Cancel'),
      ),
    );
  }
}
