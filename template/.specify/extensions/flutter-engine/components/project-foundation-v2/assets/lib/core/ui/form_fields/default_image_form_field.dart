import 'package:flutter/material.dart';

import '../../media/media_picker_service.dart';
import '../../../l10n/app_localizations.dart';

final class DefaultImageFormField extends FormField<MediaSelection> {
  DefaultImageFormField({
    required MediaPickerService picker,
    ValueChanged<MediaSelection?>? onChanged,
    super.key,
  }) : super(
         builder: (state) {
           final l10n = AppLocalizations.of(state.context)!;
           return InputDecorator(
             decoration: InputDecoration(
               labelText: l10n.pickImage,
               errorText: state.errorText,
             ),
             child: ListTile(
               contentPadding: EdgeInsets.zero,
               leading: const Icon(Icons.image_outlined),
               title: Text(state.value?.name ?? l10n.pickImage),
               onTap: () async {
                 final value = await picker.pickImage();
                 state.didChange(value);
                 onChanged?.call(value);
               },
             ),
           );
         },
       );
}
