import 'package:flutter/material.dart';
import 'package:form_handling_app/core/extensions/context_theme_extension.dart';

class AddressForm extends StatelessWidget {
  final TextEditingController streetController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController zipController;
  final Locale locale;
  const AddressForm({
    super.key,
    required this.streetController,
    required this.cityController,
    required this.stateController,
    required this.zipController,
    required this.locale,
  });

  @override
  Widget build(BuildContext context) {
    final isFa = locale.languageCode == 'fa';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(isFa ? 'آدرس' : 'Address', style: context.textTheme.titleMedium),
        TextFormField(
          controller: streetController,
          decoration: InputDecoration(labelText: isFa ? 'خیابان' : 'Street'),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: cityController,
                decoration: InputDecoration(labelText: isFa ? 'شهر' : 'City'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: stateController,
                decoration: InputDecoration(labelText: isFa ? 'استان' : 'State'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: zipController,
                decoration: InputDecoration(labelText: isFa ? 'کد پستی' : 'ZIP Code'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
