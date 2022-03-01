import 'package:adb_manager/constants/constants.dart';
import 'package:adb_manager/models/models.dart';
import 'package:adb_manager/riverpod/adb_devices.dart';
import 'package:adb_manager/views/home_view.dart';
import 'package:flutter/material.dart';

import 'package:adb_manager/widgets/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddDeviceDialog extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController ipv4Controller;
  final nameFormKey = GlobalKey<FormState>();
  final ipv4Formkey = GlobalKey<FormState>();
  AddDeviceDialog({
    required this.nameController,
    required this.ipv4Controller,
    Key? key,
  }) : super(key: key);

  void close(BuildContext context) {
    Navigator.pop(context);
    nameController.clear();
    ipv4Controller.clear();
  }

  void validate(BuildContext context, List<Device> adbDevices) {
    if (nameFormKey.currentState!.validate() &&
        ipv4Formkey.currentState!.validate()) {
      if (adbDevices.any((device) => device.ipv4 == ipv4Controller.text) ||
          adbDevices.any((device) => device.name == nameController.text)) {
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
        context.read(adbDevicesProvider.notifier).addDevice(
              name: nameController.text,
              ipv4: ipv4Controller.text,
            );
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomeView()));
        close(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultDialog(
      title: 'Add Device',
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
            controller: nameController,
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
            controller: ipv4Controller,
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
            child: const Text('Add'),
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
