import 'package:adb_manager/constants/constants.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final GlobalKey<FormState> formKey;
  final String? Function(String?) validator;
  final int? maxLength;
  const CustomTextField({
    required this.controller,
    required this.label,
    required this.formKey,
    required this.validator,
    this.maxLength,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: TextFormField(
        maxLength: maxLength,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: Theme.of(context).colorScheme.background,
          hintText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadiusM),
            borderSide: const BorderSide(
              style: BorderStyle.none,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadiusM),
            borderSide: const BorderSide(
              style: BorderStyle.none,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(borderRadiusM),
            borderSide: const BorderSide(
              style: BorderStyle.none,
            ),
          ),
        ),
      ),
    );
  }
}
