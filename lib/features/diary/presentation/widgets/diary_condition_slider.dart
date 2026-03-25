import 'package:flutter/material.dart';
import 'package:youthfield/core/constants/color.dart';
import 'package:youthfield/core/constants/text_style.dart';

class DiaryConditionSlider extends StatelessWidget {
  final double value;
  final ValueChanged<double>? onChanged;

  const DiaryConditionSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const labelStyle = YouthFieldTextStyle.smallButton;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                '0%',
                style: labelStyle,
              ),
              Text(
                '25%',
                style: labelStyle,
              ),
              Text(
                '50%',
                style: labelStyle,
              ),
              Text(
                '75%',
                style: labelStyle,
              ),
              Text(
                '100%',
                style: labelStyle,
              ),
            ],
          ),
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: YouthFieldColor.blue700,
            inactiveTrackColor: YouthFieldColor.black50,
            thumbColor: YouthFieldColor.blue700,
            overlayColor: YouthFieldColor.blue300.withValues(alpha: 0.2),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
            disabledActiveTrackColor: YouthFieldColor.blue300,
            disabledInactiveTrackColor: YouthFieldColor.black50,
            disabledThumbColor: YouthFieldColor.blue300,
          ),
          child: Slider(
            value: value,
            min: 0,
            max: 100,
            divisions: 4,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}
