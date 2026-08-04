import 'package:flutter/material.dart';

import '../../media/media_picker_service.dart';
import '../../../l10n/app_localizations.dart';

final class DefaultFileFormField extends FormField<MediaSelection> {
  DefaultFileFormField({
    required MediaPickerService picker,
    List<String>? allowedExtensions,
    ValueChanged<MediaSelection?>? onChanged,
    super.key,
  }) : super(
         builder: (state) {
           final l10n = AppLocalizations.of(state.context)!;
           return InputDecorator(
             decoration: InputDecoration(
               labelText: l10n.pickFile,
               errorText: state.errorText,
             ),
             child: ListTile(
               contentPadding: EdgeInsets.zero,
               leading: const Icon(Icons.attach_file),
               title: Text(state.value?.name ?? l10n.pickFile),
               onTap: () async {
                 final value = await picker.pickFile(
                   allowedExtensions: allowedExtensions,
                 );
                 state.didChange(value);
                 onChanged?.call(value);
               },
             ),
           );
         },
       );
}
