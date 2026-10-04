import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_config.dart';
import '../../../core/constants/app_texts.dart';

/// null si [value] est un numéro béninois valide (10 chiffres, commence par 01).
String? validateBeninPhone(String? value) =>
    AppConfig.phonePattern.hasMatch(value ?? '') ? null : AppTexts.phoneInvalid;

/// Champ numéro de téléphone avec l'indicatif +229 affiché devant.
class PhoneInputField extends StatelessWidget {
  const PhoneInputField({super.key, required this.controller, this.onSubmitted});

  final TextEditingController controller;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: true,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      style: const TextStyle(fontSize: 22, letterSpacing: 1.4),
      maxLength: AppConfig.phoneLength,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      autofillHints: const [AutofillHints.telephoneNumberNational],
      decoration: InputDecoration(
        prefixText: '${AppConfig.countryCode} ',
        hintText: AppTexts.phoneHint,
        prefixIcon: const Icon(Icons.phone_android_rounded),
        counterText: '',
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.green.shade200),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide(color: Colors.green.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
        ),
      ),
      validator: validateBeninPhone,
      onFieldSubmitted: onSubmitted,
    );
  }
}
