import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import '../l10n/app_localizations.dart';
import '../models/activity_template_model.dart';
import '../utils/constants.dart';

class AddEditTemplateSheet extends StatefulWidget {
  final ActivityTemplate? templateToEdit;
  const AddEditTemplateSheet({super.key, this.templateToEdit});

  @override
  State<AddEditTemplateSheet> createState() => _AddEditTemplateSheetState();
}

class _AddEditTemplateSheetState extends State<AddEditTemplateSheet> {
  final _formKey = GlobalKey<FormState>();
  final _templateNameController = TextEditingController();
  final _noteController = TextEditingController();
  final _durationController = TextEditingController();
  final _tagsController = TextEditingController();

  late Color _selectedColor;
  int? _selectedNotificationMinutes;
  bool _isRecurring = false;

  final List<Color> _availableColors = [
    const Color(0xFF42A5F5),
    const Color(0xFFFFEE58),
    const Color(0xFFEF5350),
    const Color(0xFF66BB6A),
    const Color(0xFFFFA726),
    const Color(0xFFAB47BC),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.templateToEdit != null) {
      final template = widget.templateToEdit!;
      _templateNameController.text = template.name;
      _durationController.text = template.durationInMinutes.toString();
      _selectedColor = template.color;
      _noteController.text = template.note ?? '';
      _tagsController.text = template.tags.join(', ');
      _selectedNotificationMinutes = template.notificationMinutesBefore;
      _isRecurring = template.isNotificationRecurring;
    } else {
      _selectedColor = Colors.blue;
      _selectedNotificationMinutes = null;
      _durationController.text = '60'; // Varsayılan süre 60 dakika
      _isRecurring = false;
    }
  }

  @override
  void dispose() {
    _templateNameController.dispose();
    _noteController.dispose();
    _tagsController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _showColorPickerDialog() async {
    final l10n = AppLocalizations.of(context)!;
    Color pickerColor = _selectedColor;

    final result = await showDialog<Color>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.chooseColor),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: pickerColor,
            onColorChanged: (color) => pickerColor = color,
            paletteType: PaletteType.hueWheel,
            labelTypes: const [],
            hexInputBar: false,
            displayThumbColor: true,
            enableAlpha: false,
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(l10n.cancel),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text(l10n.save),
            onPressed: () => Navigator.of(context).pop(pickerColor),
          ),
        ],
      ),
    );

    if (result != null) {
      setState(() {
        _selectedColor = result;
      });
    }
  }

  void _submitForm() {
    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (!isFormValid) {
      return;
    }

    final tagsText = _tagsController.text.trim();
    final List<String> tags = tagsText.isEmpty
        ? []
        : tagsText
            .split(',')
            .map((tag) {
              final trimmedTag = tag.trim();
              if (trimmedTag.startsWith('#')) {
                return trimmedTag.substring(1).trim();
              }
              return trimmedTag;
            })
            .where((tag) => tag.isNotEmpty)
            .toList();

    final template = ActivityTemplate(
      id: widget.templateToEdit?.id,
      name: _templateNameController.text,
      durationInMinutes: int.parse(_durationController.text),
      color: _selectedColor,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      notificationMinutesBefore: _selectedNotificationMinutes,
      tags: tags,
      isNotificationRecurring: _isRecurring,
    );
    Navigator.pop(context, template);
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.templateToEdit != null;
    final l10n = AppLocalizations.of(context)!;
    final isCustomColorSelected = !_availableColors.contains(_selectedColor);

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom +
              MediaQuery.of(context).padding.bottom,
          left: 24,
          right: 24,
          top: 24,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).dialogTheme.backgroundColor ??
              Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20.0),
            topRight: Radius.circular(20.0),
          ),
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  isEditing
                      ? l10n.editTemplate
                      : l10n.addTemplate, // Yeni metinler
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextFormField(
                controller: _templateNameController,
                maxLength: AppConstants.activityNameMaxLength,
                decoration: InputDecoration(
                  labelText: l10n.templateName, // Yeni metin
                  border: const OutlineInputBorder(),
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? l10n.templateNameHint
                    : null, // Yeni metin
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: l10n.durationInMinutes, // Yeni metin
                  border: const OutlineInputBorder(),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) {
                    return l10n.durationHint;
                  }
                  final duration = int.tryParse(v);
                  if (duration == null || duration <= 0) {
                    return l10n.durationInvalidHint;
                  }
                  // YENİ: Üst sınır kontrolü
                  if (duration > 1440) {
                    // 24 saat sınırı
                    return l10n.durationMaxHint; // Yeni metin
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Text(l10n.chooseColor,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12.0,
                runSpacing: 12.0,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  ..._availableColors.map((color) => InkWell(
                        onTap: () => setState(() => _selectedColor = color),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: color,
                            shape: BoxShape.circle,
                            border: _selectedColor == color
                                ? Border.all(
                                    color: Theme.of(context).primaryColor,
                                    width: 3)
                                : null,
                          ),
                        ),
                      )),
                  InkWell(
                    onTap: _showColorPickerDialog,
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isCustomColorSelected
                              ? Theme.of(context).primaryColor
                              : Colors.grey,
                          width: isCustomColorSelected ? 3 : 1,
                        ),
                      ),
                      child: const Icon(Icons.palette_outlined, size: 24),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(l10n.notificationSettings,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
              const SizedBox(height: 10),
              DropdownButtonFormField<int?>(
                value: _selectedNotificationMinutes,
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedNotificationMinutes = newValue;
                    // YENİ: Eğer "5/15 dk önce" seçilirse, tekrarı otomatik kapat.
                    if (newValue != 0 && newValue != null) {
                      _isRecurring = false;
                    }
                  });
                },
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                items: [
                  DropdownMenuItem<int?>(
                      value: null, child: Text(l10n.notificationsOff)),
                  DropdownMenuItem<int?>(
                      value: 0, child: Text(l10n.notifyOnTime)),
                  DropdownMenuItem<int?>(
                      value: 5, child: Text(l10n.notify5MinBefore)),
                  DropdownMenuItem<int?>(
                      value: 15, child: Text(l10n.notify15MinBefore)),
                ],
              ),
              if (_selectedNotificationMinutes == 0)
                SwitchListTile(
                  title: Text(l10n.repeatNotificationWeekly),
                  value: _isRecurring,
                  onChanged: (bool value) {
                    setState(() {
                      _isRecurring = value;
                    });
                  },
                  contentPadding: EdgeInsets.zero,
                ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _tagsController,
                maxLength: AppConstants.activityTagsMaxLength,
                decoration: InputDecoration(
                  labelText: l10n.tagsLabel,
                  hintText: l10n.tagsHint,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: l10n.notes,
                  border: const OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                maxLines: 3,
                maxLength: AppConstants.activityNoteMaxLength,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(l10n.cancel)),
                  const SizedBox(width: 10),
                  ElevatedButton(
                      onPressed: _submitForm,
                      child: Text(isEditing ? l10n.save : l10n.add)),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
