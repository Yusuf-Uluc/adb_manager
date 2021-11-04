import 'package:adb_manager/riverpod/riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomLoadingIndicator extends StatelessWidget {
  const BottomLoadingIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return watch(loadingIndicatorProvider)
            ? const LinearProgressIndicator()
            : const SizedBox();
      },
    );
  }
}
