import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:gunluk_planlayici/models/activity_model.dart';
import 'package:gunluk_planlayici/l10n/app_localizations.dart';
import '../utils/constants.dart';

class AddActivitySheet extends StatefulWidget {
  final Activity? activityToEdit;
  const AddActivitySheet({super.key, this.activityToEdit});

  @override
  State<AddActivitySheet> createState() => _AddActivitySheetState();
}

class _AddActivitySheetState extends State<AddActivitySheet>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _activityNameController = TextEditingController();
  final _noteController = TextEditingController();
  final _tagsController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _shakeAnimation;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  late Color _selectedColor;
  String? _timeError;
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

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 8).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticIn,
    ));

    if (widget.activityToEdit != null) {
      final activity = widget.activityToEdit!;
      _activityNameController.text = activity.name;
      _startTime = activity.startTime;
      _endTime = activity.endTime;
      _selectedColor = activity.color;
      _noteController.text = activity.note ?? '';
      _tagsController.text = activity.tags.join(', ');
      _selectedNotificationMinutes = activity.notificationMinutesBefore;
      _isRecurring = activity.isNotificationRecurring;
    } else {
      _selectedColor = _availableColors[0];
      _selectedNotificationMinutes = null;
      _isRecurring = false;
    }
  }

  @override
  void dispose() {
    _activityNameController.dispose();
    _noteController.dispose();
    _tagsController.dispose();
    _animationController.dispose();
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
        )),
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

  String _formatTime(TimeOfDay time) =>
      "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";

  Future<void> _selectTime(BuildContext context,
      {required bool isStartTime}) async {
    final l10n = AppLocalizations.of(context)!;
    final bool isEditing = widget.activityToEdit != null;
    TimeOfDay initialTimeValue;

    if (isEditing) {
      final selectedTime = isStartTime ? _startTime : _endTime;
      initialTimeValue = selectedTime ?? const TimeOfDay(hour: 0, minute: 0);
    } else {
      initialTimeValue = const TimeOfDay(hour: 0, minute: 0);
    }

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTimeValue,
      cancelText: l10n.cancel.toUpperCase(),
      confirmText: l10n.timePickerSet.toUpperCase(),
      helpText: l10n.timePickerSelect.toUpperCase(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        if (isStartTime) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  void _submitForm() {
    final l10n = AppLocalizations.of(context)!;

    setState(() {
      _timeError = null;
    });

    final isFormValid = _formKey.currentState?.validate() ?? false;
    if (!isFormValid) {
      return;
    }

    if (_startTime == null || _endTime == null) {
      setState(() {
        _timeError = l10n.errorSelectAllTimes;
      });
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

    final activity = Activity(
      id: widget.activityToEdit?.id,
      name: _activityNameController.text,
      startTime: _startTime!,
      endTime: _endTime!,
      color: _selectedColor,
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      notificationMinutesBefore: _selectedNotificationMinutes,
      tags: tags,
      isNotificationRecurring: _isRecurring,
    );
    Navigator.pop(context, activity);
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.activityToEdit != null;
    final l10n = AppLocalizations.of(context)!;
    final isCustomColorSelected = !_availableColors.contains(_selectedColor);
    final bool isRecurringEnabled = _isRecurring;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom +
                MediaQuery.of(context).padding.bottom,
            left: 24,
            right: 24,
            top: 24),
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
              Text(isEditing ? l10n.editActivity : l10n.addNewActivity,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              TextFormField(
                controller: _activityNameController,
                maxLength: AppConstants.activityNameMaxLength,
                decoration: InputDecoration(
                    labelText: l10n.activityName,
                    border: const OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? l10n.activityNameHint
                    : null,
              ),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(
                    child: InkWell(
                        onTap: () => _selectTime(context, isStartTime: true),
                        child: InputDecorator(
                            decoration: InputDecoration(
                                labelText: l10n.startTime,
                                border: const OutlineInputBorder()),
                            child: Text(_startTime != null
                                ? _formatTime(_startTime!)
                                : l10n.selectTime)))),
                const SizedBox(width: 16),
                Expanded(
                    child: InkWell(
                        onTap: () => _selectTime(context, isStartTime: false),
                        child: InputDecorator(
                            decoration: InputDecoration(
                                labelText: l10n.endTime,
                                border: const OutlineInputBorder()),
                            child: Text(_endTime != null
                                ? _formatTime(_endTime!)
                                : l10n.selectTime)))),
              ]),
              if (_timeError != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 4.0),
                  child: Text(
                    _timeError!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                      fontSize: 12,
                    ),
                  ),
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
                onChanged: isRecurringEnabled
                    ? null
                    : (int? newValue) {
                        setState(() {
                          _selectedNotificationMinutes = newValue;
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
                    value: null,
                    child: Text(l10n.notificationsOff),
                  ),
                  DropdownMenuItem<int?>(
                    value: 0,
                    child: Text(l10n.notifyOnTime),
                  ),
                  DropdownMenuItem<int?>(
                    value: 5,
                    child: Text(l10n.notify5MinBefore),
                  ),
                  DropdownMenuItem<int?>(
                    value: 15,
                    child: Text(l10n.notify15MinBefore),
                  ),
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
              AnimatedBuilder(
                animation: _shakeAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(_shakeAnimation.value, 0),
                    child: child,
                  );
                },
                child: TextFormField(
                  controller: _noteController,
                  decoration: InputDecoration(
                    labelText: l10n.notes,
                    border: const OutlineInputBorder(),
                    alignLabelWithHint: true,
                  ),
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                  onChanged: (value) {
                    setState(() {});
                    if (value.length > AppConstants.activityNoteMaxLength) {
                      _animationController.forward(from: 0.0);
                      final truncatedText = value.substring(
                          0, AppConstants.activityNoteMaxLength);
                      _noteController.value = TextEditingValue(
                        text: truncatedText,
                        selection: TextSelection.fromPosition(
                          TextPosition(offset: truncatedText.length),
                        ),
                      );
                    }
                  },
                  buildCounter: (
                    BuildContext context, {
                    required int currentLength,
                    required bool isFocused,
                    required int? maxLength,
                  }) {
                    final ayniStil = Theme.of(context).textTheme.bodySmall;
                    final sinirdaStil =
                        Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            );
                    const max = AppConstants.activityNoteMaxLength;
                    if (isFocused || currentLength > 0) {
                      return Text(
                        '$currentLength / $max',
                        style: currentLength >= max ? sinirdaStil : ayniStil,
                      );
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 30),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text(l10n.cancel)),
                const SizedBox(width: 10),
                ElevatedButton(
                    onPressed: _submitForm,
                    child: Text(isEditing ? l10n.save : l10n.add)),
              ]),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
