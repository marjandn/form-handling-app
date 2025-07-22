import 'package:flutter/material.dart';
import 'package:form_handling_app/core/extensions/localization_extension.dart';
import 'package:intl/intl.dart';

import '../../data/previous_job.dart';

class PreviousJobForm extends StatefulWidget {
  final PreviousJob job;

  final VoidCallback onRemove;
  const PreviousJobForm({super.key, required this.job, required this.onRemove});

  @override
  State<PreviousJobForm> createState() => _PreviousJobFormState();
}

class _PreviousJobFormState extends State<PreviousJobForm> {
  late TextEditingController _jobTitleController;
  late TextEditingController _companyController;
  late TextEditingController _startController;
  late TextEditingController _endController;
  late TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _jobTitleController = TextEditingController(text: widget.job.jobTitle);
    _companyController = TextEditingController(text: widget.job.company);
    _startController = TextEditingController(
      text: widget.job.start != null
          ? DateFormat.yMd(context.localization.localeName).format(widget.job.start!)
          : '',
    );
    _endController = TextEditingController(
      text: widget.job.end != null
          ? DateFormat.yMd(context.localization.localeName).format(widget.job.end!)
          : '',
    );
    _descController = TextEditingController(text: widget.job.description);
  }

  @override
  void dispose() {
    _jobTitleController.dispose();
    _companyController.dispose();
    _startController.dispose();
    _endController.dispose();
    _descController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2015),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: context.currentLocale,
    );
    if (picked != null) {
      controller.text = DateFormat.yMd(context.localization.localeName).format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text(context.localization.previousJob)),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: widget.onRemove,
                  tooltip: context.localization.remove,
                ),
              ],
            ),
            TextFormField(
              controller: _jobTitleController,
              decoration: InputDecoration(labelText: context.localization.jobTitle),
              onChanged: (v) => widget.job.jobTitle = v,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _companyController,
              decoration: InputDecoration(labelText: context.localization.company),
              onChanged: (v) => widget.job.company = v,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _startController,
                    decoration: InputDecoration(
                      labelText: context.localization.startDate,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _pickDate(_startController),
                      ),
                    ),
                    readOnly: true,
                    onChanged: (v) {
                      widget.job.start = DateFormat.yMd(context.localization.localeName).parse(v);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _endController,
                    decoration: InputDecoration(
                      labelText: context.localization.endtDate,
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _pickDate(_endController),
                      ),
                    ),
                    readOnly: true,
                    onChanged: (v) {
                      widget.job.end = DateFormat.yMd(context.localization.localeName).parse(v);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descController,
              decoration: InputDecoration(labelText: context.localization.description),
              onChanged: (v) => widget.job.description = v,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
