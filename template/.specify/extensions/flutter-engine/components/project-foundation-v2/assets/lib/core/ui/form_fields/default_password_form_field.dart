import 'package:flutter/material.dart';

import '../../validation/app_validators.dart';
import '../../../l10n/app_localizations.dart';
import 'default_form_field.dart';

final class DefaultPasswordFormField extends StatefulWidget {
  const DefaultPasswordFormField({this.controller, super.key});

  final TextEditingController? controller;

  @override
  State<DefaultPasswordFormField> createState() =>
      _DefaultPasswordFormFieldState();
}

final class _DefaultPasswordFormFieldState
    extends State<DefaultPasswordFormField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return DefaultFormField(
      label: l10n.passwordLabel,
      controller: widget.controller,
      obscureText: _obscure,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.password],
      suffixIcon: IconButton(
        onPressed: () => setState(() => _obscure = !_obscure),
        icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
      ),
      validator: (value) => AppValidators.password(
        value,
        requiredMessage: l10n.requiredField,
        invalidMessage: l10n.invalidPassword,
      ),
    );
  }
}
