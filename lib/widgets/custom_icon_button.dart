import 'package:flutter/material.dart';

import 'package:adb_manager/constants/constants.dart';

class CustomIconButton extends StatelessWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  const CustomIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: kElevationToShadow[3],
      ),
      textStyle: Theme.of(context).textTheme.subtitle2,
      waitDuration: const Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 3),
        child: SizedBox(
          height: 35,
          width: 35,
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(borderRadiusM),
            elevation: 3,
            child: InkWell(
              borderRadius: BorderRadius.circular(borderRadiusM),
              onTap: onTap,
              child: Icon(
                icon,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
