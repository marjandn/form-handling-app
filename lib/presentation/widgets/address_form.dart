import 'package:flutter/material.dart';
import 'package:form_handling_app/core/extensions/context_theme_extension.dart';
import 'package:form_handling_app/core/extensions/localization_extension.dart';

class AddressForm extends StatelessWidget {
  final TextEditingController streetController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController zipController;

  const AddressForm({
    super.key,
    required this.streetController,
    required this.cityController,
    required this.stateController,
    required this.zipController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(context.localization.address, style: context.textTheme.titleMedium),
        TextFormField(
          controller: streetController,
          decoration: InputDecoration(labelText: context.localization.street),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: cityController,
                decoration: InputDecoration(labelText: context.localization.city),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: stateController,
                decoration: InputDecoration(labelText: context.localization.state),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: zipController,
                decoration: InputDecoration(labelText: context.localization.zipCode),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
