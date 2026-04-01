import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';

class YFTimePicker extends StatefulWidget {
  final String title;
  final String? initialTime;

  const YFTimePicker({super.key, required this.title, this.initialTime});

  static Future<String?> show({
    required BuildContext context,
    required String title,
    String? initialTime,
  }) {
    return showDialog<String>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.4),
      builder: (_) => YFTimePicker(title: title, initialTime: initialTime),
    );
  }

  @override
  State<YFTimePicker> createState() => _YFTimePickerState();
}

class _YFTimePickerState extends State<YFTimePicker> {
  late FixedExtentScrollController _hourCtrl;
  late FixedExtentScrollController _minuteCtrl;
  int _hour = 0;
  int _minute = 0;

  static const double _itemExtent = 52;
  static const double _wheelHeight = _itemExtent * 5;
  static const double _wheelWidth = 88;

  @override
  void initState() {
    super.initState();
    if (widget.initialTime != null) {
      final parts = widget.initialTime!.split(':');
      _hour = int.tryParse(parts[0]) ?? 0;
      _minute = int.tryParse(parts[1]) ?? 0;
    } else {
      final now = TimeOfDay.now();
      _hour = now.hour;
      _minute = now.minute;
    }
    _hourCtrl = FixedExtentScrollController(initialItem: _hour);
    _minuteCtrl = FixedExtentScrollController(initialItem: _minute);
  }

  @override
  void dispose() {
    _hourCtrl.dispose();
    _minuteCtrl.dispose();
    super.dispose();
  }

  String get _result =>
      '${_hour.toString().padLeft(2, '0')}:${_minute.toString().padLeft(2, '0')}';

  void _nudge(FixedExtentScrollController ctrl, int current, int max, int delta) {
    final next = (current + delta).clamp(0, max - 1);
    ctrl.animateToItem(
      next,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: YouthFieldColor.white,
      elevation: 0,
      child: SizedBox(
        width: 320,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.title,
                style: YouthFieldTextStyle.body4.copyWith(
                  color: YouthFieldColor.black800,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 28),
              SizedBox(
                height: _wheelHeight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _DrumWheel(
                      controller: _hourCtrl,
                      count: 24,
                      selected: _hour,
                      onChanged: (i) => setState(() => _hour = i),
                      onUp: () => _nudge(_hourCtrl, _hour, 24, -1),
                      onDown: () => _nudge(_hourCtrl, _hour, 24, 1),
                      formatter: (i) => i.toString().padLeft(2, '0'),
                      label: '시',
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        ':',
                        style: YouthFieldTextStyle.body3.copyWith(
                          color: YouthFieldColor.blue700,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    _DrumWheel(
                      controller: _minuteCtrl,
                      count: 60,
                      selected: _minute,
                      onChanged: (i) => setState(() => _minute = i),
                      onUp: () => _nudge(_minuteCtrl, _minute, 60, -1),
                      onDown: () => _nudge(_minuteCtrl, _minute, 60, 1),
                      formatter: (i) => i.toString().padLeft(2, '0'),
                      label: '분',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: YouthFieldColor.black300),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          '취소',
                          style: YouthFieldTextStyle.smallButton.copyWith(
                            color: YouthFieldColor.black500,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context, _result),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: YouthFieldColor.blue700,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          '확인',
                          style: YouthFieldTextStyle.smallButton.copyWith(
                            color: YouthFieldColor.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrumWheel extends StatelessWidget {
  final FixedExtentScrollController controller;
  final int count;
  final int selected;
  final ValueChanged<int> onChanged;
  final VoidCallback onUp;
  final VoidCallback onDown;
  final String Function(int) formatter;
  final String label;

  static const double _itemExtent = _YFTimePickerState._itemExtent;
  static const double _wheelHeight = _YFTimePickerState._wheelHeight;
  static const double _wheelWidth = _YFTimePickerState._wheelWidth;

  const _DrumWheel({
    required this.controller,
    required this.count,
    required this.selected,
    required this.onChanged,
    required this.onUp,
    required this.onDown,
    required this.formatter,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _ArrowButton(icon: Icons.keyboard_arrow_up_rounded, onTap: onUp),
        const SizedBox(height: 4),
        SizedBox(
          width: _wheelWidth,
          height: _wheelHeight - (_itemExtent + 4) * 2,
          child: Stack(
            children: [
              ListWheelScrollView.useDelegate(
                controller: controller,
                itemExtent: _itemExtent,
                diameterRatio: 100.0,
                overAndUnderCenterOpacity: 0.4,
                physics: const FixedExtentScrollPhysics(),
                onSelectedItemChanged: onChanged,
                childDelegate: ListWheelChildBuilderDelegate(
                  childCount: count,
                  builder: (context, index) => Center(
                    child: Text(
                      formatter(index),
                      style: YouthFieldTextStyle.body3.copyWith(
                        color: index == selected
                            ? YouthFieldColor.blue700
                            : YouthFieldColor.black500,
                        fontWeight: index == selected
                            ? FontWeight.w700
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 4),
        _ArrowButton(icon: Icons.keyboard_arrow_down_rounded, onTap: onDown),
        const SizedBox(height: 6),
        Text(
          label,
          style: YouthFieldTextStyle.placeholder.copyWith(
            color: YouthFieldColor.black500,
          ),
        ),
      ],
    );
  }
}

class _ArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ArrowButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: SizedBox(
          width: 36,
          height: 36,
          child: Icon(icon, size: 24, color: YouthFieldColor.blue700),
        ),
      ),
    );
  }
}
