import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../data/previous_job.dart';

class PreviousJobForm extends StatefulWidget {
  final PreviousJob job;
  final Locale locale;
  final VoidCallback onRemove;
  const PreviousJobForm({super.key, required this.job, required this.locale, required this.onRemove});

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
          ? DateFormat.yMd(widget.locale.languageCode).format(widget.job.start!)
          : '',
    );
    _endController = TextEditingController(
      text: widget.job.end != null ? DateFormat.yMd(widget.locale.languageCode).format(widget.job.end!) : '',
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
      locale: widget.locale,
    );
    if (picked != null) {
      controller.text = DateFormat.yMd(widget.locale.languageCode).format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isFa = widget.locale.languageCode == 'fa';
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: Text(isFa ? 'شغل قبلی' : 'Previous Job')),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: widget.onRemove,
                  tooltip: isFa ? 'حذف' : 'Remove',
                ),
              ],
            ),
            TextFormField(
              controller: _jobTitleController,
              decoration: InputDecoration(labelText: isFa ? 'عنوان شغلی' : 'Job Title'),
              onChanged: (v) => widget.job.jobTitle = v,
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _companyController,
              decoration: InputDecoration(labelText: isFa ? 'شرکت' : 'Company'),
              onChanged: (v) => widget.job.company = v,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _startController,
                    decoration: InputDecoration(
                      labelText: isFa ? 'تاریخ شروع' : 'Start Date',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _pickDate(_startController),
                      ),
                    ),
                    readOnly: true,
                    onChanged: (v) {
                      widget.job.start = DateFormat.yMd(widget.locale.languageCode).parse(v);
                    },
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFormField(
                    controller: _endController,
                    decoration: InputDecoration(
                      labelText: isFa ? 'تاریخ پایان' : 'End Date',
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.calendar_today),
                        onPressed: () => _pickDate(_endController),
                      ),
                    ),
                    readOnly: true,
                    onChanged: (v) {
                      widget.job.end = DateFormat.yMd(widget.locale.languageCode).parse(v);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _descController,
              decoration: InputDecoration(labelText: isFa ? 'توضیحات' : 'Description'),
              onChanged: (v) => widget.job.description = v,
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}
