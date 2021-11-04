import 'package:adb_manager/constants/constants.dart';
import 'package:flutter/material.dart';

class DefaultDialog extends StatelessWidget {
  final String title;
  final String? content;
  final Widget? customContent;
  final Widget? button1;
  final Widget? button2;
  const DefaultDialog({
    required this.title,
    this.content,
    this.customContent,
    this.button1,
    this.button2,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.zero,
      content: Container(
        width: 200,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadiusM),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: <Color>[
              const Color(0xFF0B2031),
              Theme.of(context).colorScheme.background
            ],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 20.0, 24.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const SizedBox(height: 10),
                  customContent ??
                      Text(
                        content!,
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SizedBox(child: button1),
                  SizedBox(child: button2)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
