import 'package:flutter/material.dart';

import '../../validation/app_validators.dart';
import '../../../l10n/app_localizations.dart';
import 'default_form_field.dart';

final class DefaultPhoneFormField extends StatelessWidget {
  const DefaultPhoneFormField({
    this.controller,
    this.countryCode = '+20',
    super.key,
  });

  final TextEditingController? controller;
  final String countryCode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DefaultFormField(
      label: l10n.phoneLabel,
      controller: controller,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.telephoneNumber],
      prefixIcon: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Center(widthFactor: 1, child: Text(countryCode)),
      ),
      validator: (value) => AppValidators.phone(
        '$countryCode${value ?? ''}',
        requiredMessage: l10n.requiredField,
        invalidMessage: l10n.invalidPhone,
      ),
    );
  }
}
