import 'package:flutter/material.dart';
import 'package:reactive_forms/reactive_forms.dart';

class ReactiveRadioGroup<T> extends StatelessWidget {
  final String formControlName;
  final List<Map<String, dynamic>> options;

  const ReactiveRadioGroup({
    super.key,
    required this.formControlName,
    required this.options,
  });

  @override
  Widget build(BuildContext context) {
    return ReactiveFormField<T, T>(
      formControlName: formControlName,
      validationMessages: {
        ValidationMessage.required: (_) => 'Harap pilih salah satu opsi',
      },
      builder: (field) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ...options.map(
              (opt) => RadioListTile<T>(
                value: opt['value'],
                groupValue: field.value,
                title: Text(opt['label']),
                onChanged: field.didChange,
                visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
              ),
            ),
            if (field.control.invalid && field.control.touched)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text(
                  field.errorText ?? '',
                  style: const TextStyle(color: Colors.red),
                ),
              ),
          ],
        );
      },
    );
  }
}
