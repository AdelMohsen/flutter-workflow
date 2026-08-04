import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/media/media_picker_service.dart';
import '../core/ui/adaptive/adaptive_widgets.dart';
import '../core/ui/app_content.dart';
import '../core/ui/app_feedback.dart';
import '../core/ui/form_fields/default_email_form_field.dart';
import '../core/ui/form_fields/default_file_form_field.dart';
import '../core/ui/form_fields/default_image_form_field.dart';
import '../core/ui/form_fields/default_password_form_field.dart';
import '../core/ui/form_fields/default_phone_form_field.dart';
import '../l10n/app_localizations.dart';

final class ComponentShowcase extends StatefulWidget {
  const ComponentShowcase({required this.apiConfigured, super.key});

  final bool apiConfigured;

  @override
  State<ComponentShowcase> createState() => _ComponentShowcaseState();
}

final class _ComponentShowcaseState extends State<ComponentShowcase> {
  final _formKey = GlobalKey<FormState>();
  final _picker = MediaPickerService();
  bool _enabled = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AdaptiveScaffold(
      title: l10n.showcaseTitle,
      body: AppContent(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.showcaseDescription),
                const SizedBox(height: 8),
                Text(
                  widget.apiConfigured
                      ? l10n.apiConfigured
                      : l10n.apiNotConfigured,
                ),
                const SizedBox(height: 24),
                const DefaultEmailFormField(),
                const SizedBox(height: 16),
                const DefaultPasswordFormField(),
                const SizedBox(height: 16),
                const DefaultPhoneFormField(),
                const SizedBox(height: 16),
                DefaultImageFormField(picker: _picker),
                const SizedBox(height: 16),
                DefaultFileFormField(picker: _picker),
                const SizedBox(height: 16),
                Row(
                  children: [
                    AdaptiveSwitch(
                      value: _enabled,
                      onChanged: (value) => setState(() => _enabled = value),
                    ),
                    const SizedBox(width: 8),
                    Text(_enabled ? l10n.enabled : l10n.disabled),
                  ],
                ),
                const SizedBox(height: 24),
                AdaptiveButton(
                  label: l10n.submit,
                  icon: adaptiveIcon(
                    context,
                    material: Icons.check,
                    cupertino: CupertinoIcons.check_mark,
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      AppFeedback.success(l10n.successMessage);
                    } else {
                      AppFeedback.error(l10n.errorMessage);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
