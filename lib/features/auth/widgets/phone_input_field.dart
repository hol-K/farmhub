import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_texts.dart';
import '../../../core/constants/countries.dart';

/// null si [value] est un numéro valide pour [country].
String? validatePhone(Country country, String? value) {
  if (country.toE164(value) != null) return null;
  return country == Countries.benin
      ? AppTexts.phoneInvalid
      : AppTexts.phoneInvalidFor(country.name);
}

/// Champ numéro de téléphone, avec le choix du pays (drapeau + indicatif) devant.
class PhoneInputField extends StatelessWidget {
  const PhoneInputField({
    super.key,
    required this.controller,
    required this.country,
    required this.onCountryChanged,
    this.onSubmitted,
  });

  final TextEditingController controller;
  final Country country;
  final ValueChanged<Country> onCountryChanged;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      autofocus: true,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.done,
      style: const TextStyle(fontSize: 22, letterSpacing: 1.4),
      maxLength: country.maxInputLength,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      autofillHints: const [AutofillHints.telephoneNumberNational],
      decoration: InputDecoration(
        hintText: country == Countries.benin
            ? AppTexts.phoneHint
            : AppTexts.phoneHintOther,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12, right: 4),
          child: Tooltip(
            message: AppTexts.country,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Country>(
                value: country,
                onChanged: (c) {
                  if (c != null) onCountryChanged(c);
                },
                // Fermé : drapeau + indicatif. Ouvert : nom complet.
                selectedItemBuilder: (_) => [
                  for (final c in Countries.all)
                    Center(
                      child: Text(
                        '${c.flag} ${c.dialCode}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                ],
                items: [
                  for (final c in Countries.all)
                    DropdownMenuItem(
                      value: c,
                      child: Text('${c.flag}  ${c.name}  ${c.dialCode}'),
                    ),
                ],
              ),
            ),
          ),
        ),
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
      validator: (v) => validatePhone(country, v),
      onFieldSubmitted: onSubmitted,
    );
  }
}
