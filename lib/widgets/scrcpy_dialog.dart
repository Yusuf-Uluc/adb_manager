import 'package:adb_manager/constants/constants.dart';
import 'package:adb_manager/riverpod/riverpod.dart';
import 'package:adb_manager/services/services.dart';
import 'package:adb_manager/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class ScrcpyDialog extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  const ScrcpyDialog({required this.scaffoldKey, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultDialog(
      title: 'Select Device',
      customContent: SizedBox(
        height: 230,
        child: Consumer(
          builder: (context, watch, child) {
            final devices = watch(adbDevicesProvider);
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  onPressed: () async {
                    await launch('https://github.com/Genymobile/scrcpy');
                  },
                  child: const Text('Install Scrcpy'),
                ),
                const SizedBox(height: 5),
                Expanded(
                  child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: devices.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(borderRadiusM),
                          ),
                          onTap: () {
                            ADBServices().scrcpy(
                              scaffoldKey,
                              devices[index],
                            );
                          },
                          title: Text(
                            devices[index].name,
                          ),
                          subtitle: Text(
                            devices[index].ipv4,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      button1: TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: const Text('OK'),
      ),
    );
  }
}
