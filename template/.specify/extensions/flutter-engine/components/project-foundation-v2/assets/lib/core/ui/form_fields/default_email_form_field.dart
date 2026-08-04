import 'package:flutter/material.dart';

import '../../validation/app_validators.dart';
import '../../../l10n/app_localizations.dart';
import 'default_form_field.dart';

final class DefaultEmailFormField extends StatelessWidget {
  const DefaultEmailFormField({this.controller, super.key});

  final TextEditingController? controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DefaultFormField(
      label: l10n.emailLabel,
      controller: controller,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.email],
      validator: (value) => AppValidators.email(
        value,
        requiredMessage: l10n.requiredField,
        invalidMessage: l10n.invalidEmail,
      ),
    );
  }
}
